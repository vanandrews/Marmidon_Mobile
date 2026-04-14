import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:marmidon/Services/api_services.dart';
import 'package:path_provider/path_provider.dart';

class SubmitInvoice extends StatefulWidget {
  @override
  _SubmitInvoiceState createState() => _SubmitInvoiceState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _SubmitInvoiceState extends State<SubmitInvoice> {
  final _inputController = TextEditingController();
  final salesDate = new DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _debouncer = Debouncer();
  List invoicesListAll = [];
  List invoicesListAllFromServer = [];

  bool _isLoading = false;
  Future<dynamic> getInvoicesListList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await ApiService.searchPendingInvoices(
          "", "", salesDate.toString(), "");
      setState(() {
        _isLoading = false;
      });

      return response["invoiceDetails"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getInvoicesListList().then((listFromServer) {
      setState(() {
        invoicesListAllFromServer = listFromServer;
        invoicesListAll = invoicesListAllFromServer;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
        padding: EdgeInsets.all(15),
        child: TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            suffixIcon: const InkWell(
              child: Icon(Icons.search),
            ),
            contentPadding: EdgeInsets.all(15.0),
            hintText: 'Search ',
          ),
          onChanged: (stringInput) {
            _debouncer.run(() {
              setState(() {
                invoicesListAll = invoicesListAllFromServer
                    .where(
                      (mysubject) =>
                          (mysubject.toString().toLowerCase().contains(
                                stringInput.toLowerCase(),
                              )),
                    )
                    .toList();
              });
            });
          },
        ),
      ),
      Container(
        child: !_isLoading
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  itemCount: invoicesListAll.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "${invoicesListAll[index]["InvoinceNumber"]}",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                                softWrap: true,
                              ),
                              subtitle: Text(
                                "${invoicesListAll[index]["ClientName"]}\nAgent: "
                                "${invoicesListAll[index]["Agent"]}\nFDN: ${invoicesListAll[index]["FDN"]}\n${invoicesListAll[index]["TransactionDate"]}",
                                style: const TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                                softWrap: true,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () async {
                                          showLoaderDialog2(
                                              context,
                                              invoicesListAll[index]
                                              ["InvoinceNumber"]);
                                          final results =
                                          await ApiService.submitInvoice(
                                              invoicesListAll[index]
                                              ["InvoinceNumber"]);

                                          if (results["statuscode"] == "203") {
                                            Navigator.pop(context);
                                            showAlertDialog2(
                                                context,
                                                results["Message"],
                                                results["Returncode"]);
                                          } else {
                                            Navigator.pop(context);
                                            showAlertDialog2_err(context, results["Message"], results["Returncode"]);
                                          }
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )),
                                  Expanded(
                                    child: Text(
                                      "UGX ${invoicesListAll[index]["Amount"]}\n"
                                          .toString()
                                          .replaceAllMapped(
                                              globals.reg, globals.mathFunc),
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.amber),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const CircularProgressIndicator(),
      ),
    ])));
  }

  showLoaderDialog2(BuildContext context, String invoiceNumber) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: const Text(
                "Submitting Invoice...",
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog_Network(BuildContext context) {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        //primary: Colors.amber, // background
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      child: const Text('Ok'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Notice!",
      ),
      content: const Text("Network Error! Please Check your Internet connection ...."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog2(
      BuildContext context, String invoiceToSubmit, String returnCode) {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        //primary: Colors.amber, // background
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      child: const Text('Ok'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Successful!",
        style: TextStyle(color: Colors.green),
      ),
      content: Text("Invoice Number:  *$invoiceToSubmit* : $returnCode"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog2_err(
      BuildContext context, String invoiceToSubmit, String returnCode) {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        //primary: Colors.amber, // background
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      child: const Text('Ok'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Notice!",
        style: TextStyle(color: Colors.red),
      ),
      content: Text("Invoice Number:  *$invoiceToSubmit* : $returnCode"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

//Declare Subject class for json data or parameters of json string/data
//Class For Subject
class Subject {
  var invoiceID;
  var InvoinceNumber;
  var Reference;
  var FDN;
  var ClientName;
  var Amount;
  var TransactionDate;
  var Agent;
  var Status;

  Subject({
    required this.invoiceID,
    required this.InvoinceNumber,
    required this.Reference,
    required this.FDN,
    required this.ClientName,
    required this.Amount,
    required this.TransactionDate,
    required this.Agent,
    required this.Status,
  });

  factory Subject.fromJson(Map<dynamic, dynamic> json) {
    return Subject(
      invoiceID: json['invoiceID'],
      InvoinceNumber: json['InvoinceNumber'],
      Reference: json['Reference'],
      FDN: json['FDN'],
      ClientName: json['ClientName'],
      TransactionDate: json['TransactionDate'],
      Agent: json['Agent'],
      Status: json['Status'],
      Amount: json['Amount'],
    );
  }
}
