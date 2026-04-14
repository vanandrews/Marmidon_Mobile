import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:image/image.dart' as myImageLib;
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:marmidon/Services/api_services.dart';

class SearchInvoice extends StatefulWidget {
  @override
  _SearchInvoiceState createState() => _SearchInvoiceState();
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

class _SearchInvoiceState extends State<SearchInvoice> {
  final _inputController = TextEditingController();
  final salesDate = new DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _debouncer = Debouncer();
  List invoicesListAll = [];
  List invoicesListAllFromServer = [];
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  bool _isLoading = false;

  Future<dynamic> getInvoicesListList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
          await ApiService.searchInvoices("", "", salesDate.toString(), "");
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
                                style: TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                                softWrap: true,
                              ),
                              trailing: Column(
                                children: [
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
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: invoicesListAll[index]["FDN"] != ""
                                          ? () async {
                                              showLoaderDialog1(context);
                                              final results =
                                                  await ApiService.printInvoice(
                                                      invoicesListAll[index]
                                                          ["InvoinceNumber"]);
                                              // Amount: 337500.00,
                                              //Tax: 0,
                                              // Qrcode: ,
                                              print(results);
                                              if (results["statuscode"] ==
                                                  "203") {
                                                printTicket(
                                                    results["cpnyName"],
                                                    results["cpnyAddress"],
                                                    results["cpnyContact"],
                                                    results["ClientName"],
                                                    results["Clientcategory"],
                                                    results["invoiceNo"],
                                                    results["issuedDate"],
                                                    results["antifakeCode"],
                                                    results["fdn"],
                                                    results["goodsDetails"],
                                                    results["Amount"],
                                                    results["Tax"],
                                                    results["Qrcode"],
                                                    results["cpnyTin"],
                                                    results["cusTin"]);
                                                Navigator.pop(context);
                                              }
                                            }
                                          : null,
                                      child: const Text(
                                        "Print",
                                        style: TextStyle(color: Colors.blue),
                                      ),
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: const Text(
                " Please Connect Printer....",
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          Duration(seconds: 3),
          () {
            Navigator.of(context).pop(true);
          },
        );
        return alert;
      },
    );
  }

  showLoaderDialog1(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: const Text(
                "  Preparing Invoice....",
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

  Future<void> printTicket(
      String companyName,
      String companyAddress,
      String companyContact,
      String clientName,
      String clientCategory,
      String invoiceN0,
      String issueDate,
      String verifyCode,
      String fDN,
      List itemDetailsList,
      String amount,
      String taxAmount,
      String qrCode,
      String cmpyTin,
      String clientTn) async {
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getTicket(
          companyName,
          companyAddress,
          companyContact,
          clientName,
          clientCategory,
          invoiceN0,
          issueDate,
          verifyCode,
          fDN,
          itemDetailsList,
          amount,
          taxAmount,
          qrCode,
          cmpyTin,
          clientTn);
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      print("Print $result");
    } else {
      showLoaderDialog(context);
    }
  }

  Future<List<int>> getTicket(
      String companyName,
      String companyAddress,
      String companyContact,
      String clientName,
      String clientCategory,
      String invoiceN0,
      String issueDate,
      String verifyCode,
      String fDN,
      List itemDetailsList,
      String amount,
      String taxAmount,
      String qrCode,
      String companyTin,
      String clientTin) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("$companyName",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("$companyAddress",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(companyContact,
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(companyTin,
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text(
      "** TAX INVOICE **",
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
          bold: true
        //width: PosTextSize.size1,
      ),
    );

    bytes += generator.text(
      "",
      styles: PosStyles(align: PosAlign.center),
    );

    bytes += generator.row([
      //client Name
      PosColumn(
          text: 'To:',
          width: 2,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: clientName,
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          )),
    ]);

    bytes += generator.row([
      //client Tin
      PosColumn(
          text: 'Client Tin:',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: clientTin,
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
    ]);

    bytes += generator.row([
      //client category
      PosColumn(
          text: 'Type:',
          width: 4,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: clientCategory,
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
          )),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Invoice:',
          width: 4,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
        text: invoiceN0,
        width: 8,
        styles: PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Date Issued:',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
        text: issueDate,
        width: 7,
        styles: PosStyles(
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += generator.row([
      //
      PosColumn(
          text: 'FDN:',
          width: 2,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: fDN,
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          )),
    ]);

    bytes += generator.row([
      //client Name
      PosColumn(
          text: 'Code:',
          width: 3,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: verifyCode,
          width: 9,
          styles: PosStyles(
            align: PosAlign.left,
          )),
    ]);

    bytes += generator.text(
      "",
      styles: PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 4,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Cost',
          width: 3,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);

    double sumTotal = 0;

    if (itemDetailsList.isNotEmpty) {
      for (int i = 0; i < itemDetailsList.length; i++) {
        bytes += generator.row([
          //Items
          PosColumn(
              text: "${itemDetailsList[i]["qty"]}",
              width: 2,
              styles: const PosStyles(
                align: PosAlign.left,
              )), //Quantity
          PosColumn(
              text: "${itemDetailsList[i]["item"]}".length > 10
                  ? "${itemDetailsList[i]["item"]}".substring(0, 10)
                  : "${itemDetailsList[i]["item"]}", //Item name
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              )),
          PosColumn(
              text: "${itemDetailsList[i]["unitPrice"]}", //unit price
              width: 3,
              styles: const PosStyles(
                align: PosAlign.center,
              )),

          PosColumn(
              text:
                  "${double.parse(itemDetailsList[i]["unitPrice"]) * double.parse(itemDetailsList[i]["qty"])}", //amount
              width: 3,
              styles: PosStyles(align: PosAlign.right)),
        ]);
        sumTotal = sumTotal +
            double.parse(itemDetailsList[i]["unitPrice"]) *
                double.parse(itemDetailsList[i]["qty"]);
      }
    }

    bytes += generator.row([
      //Items
      PosColumn(
          text: sumTotal.toString().replaceAllMapped(reg, mathFunc), //amount
          width: 12,
          styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      //Items
      PosColumn(text: "", width: 1), //Quantity
      PosColumn(
          text: "VAT Tax", //Item name
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "18%", //unit price
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: taxAmount.replaceAllMapped(reg, mathFunc), //amount
          width: 3,
          styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
          )),
      PosColumn(
          text: amount.replaceAllMapped(reg, mathFunc),
          width: 8,
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // Print QR Code using native function
    bytes += generator.qrcode(qrCode);

    bytes += generator.text("** END OF TAX INVOICE **",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('POWERED BY: \n.. MARMIDON BUSINESS SOFTWARE ..',
        styles: PosStyles(align: PosAlign.center, bold: false));

    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> getGraphicsTicket() async {
    final ByteData data = await rootBundle.load('Images/invoice.png');
    final Uint8List Imagebytes = data.buffer.asUint8List();
    final myImageLib.Image image1 =
        myImageLib.decodeImage(Imagebytes) as myImageLib.Image;
    // Using `ESC *`

    List<int> bytes = [];

    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // Print QR Code using native function
    bytes += generator.qrcode(
        '02000000116AHC322050783484000016E3600000037DCD000000000123A10065006960~HYSYS '
        'GLOBAL SOLUTIONS (U) LIMITED~BAGUMA ANDREW~test 23,TEST 24,Baguma Test"');

    bytes += generator.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //Adding Image
    bytes += generator.image(image1, align: PosAlign.center);

    bytes += generator.cut();
    return bytes;
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
