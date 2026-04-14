import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marmidon/Services/api_services.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import '../../../Services/model_service.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

class InvoicingPage extends StatefulWidget {
  @override
  InvoicingPageState createState() => InvoicingPageState();
}

class InvoicingPageState extends State<InvoicingPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  late bool newBool = false;

  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String formatter = DateFormat('yMMMMd').format(DateTime.now());
  final salesDate = new DateFormat('yyyy-MM-dd').format(DateTime.now());

  var _currentSupplierSelected = "-- Select Agent --";
  var _currentProductSelected = "-- Select Item --";

  TextEditingController clientNameController = TextEditingController();
  TextEditingController invoiceRefController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController costController = TextEditingController();

  TextEditingController textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var numberInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
  ];
  bool _validateQty = false;
  bool _validateCost = false;
  bool _validateInvoice = false;

  late String maxQty = "0";
  late String validBal = "false";

  List productsListToProcess = [];
  List productsList = globals.productsList;

  void _formRefresh() {
    setState(() {
      newBool = false;
      productsListToProcess = [];
      validBal = "false";
      maxQty = "0";
      _validateCost = false;
      _validateQty = false;
      newBool = false;
      clientNameController.clear();
      invoiceRefController.clear();
      descriptionController.clear();
      quantityController.clear();
      costController.clear();
      textController.clear();
      _currentSupplierSelected = "-- Select Agent --";
      _currentProductSelected = "-- Select Item --";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            /*
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Invoicing '),
            ),
             */
            body: Stack(children: <Widget>[
              SingleChildScrollView(
                child: Builder(builder: (BuildContext context) {
                  return Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.01,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Center(
                                child: Text(
                                  formatter,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 5, right: 5, bottom: 3),
                              child: _agentsDropdown2(globals.agentsList[
                                  1]), //_productsDropdown2(productsList[1])
                            ),
                            /*
                            Container(
                              height: height * 0.105,
                              child: _agentsWidget(globals.agentsList[1]),
                            ),
                             */
                            Container(
                              height: height * 0.095,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const Text(
                                    "Client:",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  title: TextField(
                                    controller: clientNameController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Client Name',
                                        hintStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.095,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const Text(
                                    "Invoice Ref:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blue),
                                  ),
                                  title: TextFormField(
                                    controller: invoiceRefController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Invoice Number ',
                                        hintStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 25, right: 25, top: 15),
                              child: TextField(
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic),
                                    hintText: 'Enter Description',
                                    hintStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5, left: 5, right: 5, bottom: 3),
                              child: _productsDropdown2(productsList[1]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: costController,
                                        inputFormatters: numberInputFormatters,
                                        decoration: InputDecoration(
                                          errorText:
                                              _validateCost ? 'numbers' : null,
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: 'Price (UGX)',
                                          labelStyle: TextStyle(fontSize: 13),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: quantityController,
                                        inputFormatters: numberInputFormatters,
                                        decoration: InputDecoration(
                                          errorText:
                                              _validateQty ? 'numbers' : null,
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: 'Qty(Max:$maxQty)',
                                          labelStyle: TextStyle(fontSize: 13),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle),
                                      color: Colors.blue,
                                      onPressed: () {
                                        costController.text.isEmpty
                                            ? _validateCost = true
                                            : _validateCost = false;

                                        if (validBal == "true") {
                                          quantityController.text.isNotEmpty &&
                                                  double.parse(
                                                          quantityController
                                                              .text) <=
                                                      double.parse(maxQty)
                                              ? _validateQty = false
                                              : _validateQty = true;
                                        } else {
                                          quantityController.text.isEmpty
                                              ? _validateQty = true
                                              : _validateQty = false;
                                        }

                                        invoiceRefController.text.isEmpty
                                            ? _validateInvoice = true
                                            : _validateInvoice = false;

                                        if (_currentProductSelected !=
                                                "-- Select Item --" &&
                                            !_validateCost &&
                                            !_validateQty) {
                                          Map<String, String> productMap = {
                                            "item": _currentProductSelected
                                                .substring(
                                                    _currentProductSelected
                                                            .indexOf(' ') +
                                                        1),
                                            "itemCode": productsList[3][int
                                                .parse(_currentProductSelected
                                                    .substring(
                                                        0,
                                                        _currentProductSelected
                                                            .indexOf(' ')))],
                                            "qty": quantityController.text,
                                            "unitPrice": costController.text,
                                          };
                                          productsListToProcess.add(productMap);
                                          quantityController.clear();
                                          //costController.clear();
                                          setState(() {});
                                        } else {
                                          final snackbar = SnackBar(
                                            content:  Text(
                                                'Select Product, add cost & check max quantity before adding...!!!'),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                              },
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5, left: 30, right: 30, bottom: 10),
                              child: ListTileTheme.merge(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0.0),
                                      itemCount: productsListToProcess.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int Index) {
                                        return ListTile(
                                          leading: Text("${Index + 1}"),
                                          title: Text(
                                              "${productsListToProcess[Index]["item"]}"),
                                          subtitle: Text(
                                              "Qty: ${productsListToProcess[Index]["qty"]}   ${" Unit Price: ${productsListToProcess[Index]["unitPrice"]}".toString().replaceAllMapped(globals.reg, globals.mathFunc)}"),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete_forever_rounded,
                                            ),
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              productsListToProcess
                                                  .removeAt(Index);
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      })),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  //primary: Colors.red, // background
                                ),
                                onPressed: () async {
                                  if (clientNameController.text.isNotEmpty &&
                                      productsListToProcess.isNotEmpty &&
                                      _currentSupplierSelected !=
                                          "-- Select Agent --" &&
                                      _currentProductSelected !=
                                          "-- Select Item --") {
                                    //process invoice
                                    showConfirmSheet(
                                        context,
                                        _scaffoldKey,
                                        height,
                                        "20000",
                                        "07982934",
                                        "0781215370",
                                        "UGA");

                                    //{Message: INV000160}
                                  } else {
                                    //Navigator.pop(context);
                                    final snackbar = SnackBar(
                                      content: const Text(
                                          'Select Agent & Product, add client name and at least one Item before previewing Invoice.'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () async {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                  }
                                },
                                child: const Text('Preview'),
                              ),
                            ),
                          ]));
                }),
              ),
            ])));
  }

  showConfirmSheet(BuildContext context, key, height, amount, fromAccount,
      mobileNumber, operator) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: height * 0.6,
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text('Process Invoice',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'constantia',
                            color: Colors.blue,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 5),
                    child: Row(children: [
                      const Text("Client Name: ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'constantia',
                            color: Color(0xfc22577b),
                          )),
                      Text(clientNameController.text,
                          textAlign: TextAlign.center)
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 5),
                    child: Row(children: [
                      const Text("Invoice Ref: ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'constantia',
                            color: Color(0xfc22577b),
                          )),
                      Text(invoiceRefController.text,
                          textAlign: TextAlign.center)
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Table(
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                      children: [
                        TableRow(children: [
                          Column(children: const [
                            Text('Item',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ]),
                          Column(children: const [
                            Text('Qty',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ]),
                          Column(children: const [
                            Text('Price ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ]),
                          Column(children: const [
                            Text('Total (UGX)',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ]),
                        ]),
                        for (var i in productsListToProcess)
                          TableRow(children: [
                            Column(children: [
                              Text(
                                i["item"],
                                textAlign: TextAlign.left,
                              )
                            ]),
                            Column(children: [
                              Text(
                                i["qty"],
                                textAlign: TextAlign.center,
                              )
                            ]),
                            Column(children: [
                              Text(
                                i["unitPrice"].replaceAllMapped(
                                    globals.reg, globals.mathFunc),
                                textAlign: TextAlign.center,
                              )
                            ]),
                            Column(children: [
                              Text(
                                "${double.parse(i["unitPrice"]) * double.parse(i["qty"])}"
                                    .replaceAllMapped(
                                        globals.reg, globals.mathFunc),
                                textAlign: TextAlign.right,
                              )
                            ])
                          ]),
                        TableRow(children: [
                          Column(children: const [
                            Text('',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic))
                          ]),
                          Column(children: const [
                            Text('',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic))
                          ]),
                          Column(children: const [
                            Text('TOTAL:',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [
                            Text(
                                getInvoiceAmountSum(productsListToProcess)
                                    .replaceAllMapped(
                                        globals.reg, globals.mathFunc),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                    fontFamily: 'constantia',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Text('Narration:',
                        style: TextStyle(
                          fontFamily: 'constantia',
                          color: Color(0xfc22577b),
                        )),
                    title: Text(
                      descriptionController.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    onTap: () => {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          try {
                            final result = await InternetAddress.lookup(
                                'www.google.com'); //checking for internet connection
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              Navigator.pop(key.currentContext);
                              showLoaderDialog(key.currentContext);

                              final results = await ApiService.processInvoice(
                                  invoiceRefController.text,
                                  globals.agentsList[0][int.parse(
                                      _currentSupplierSelected.substring(
                                          0,
                                          _currentSupplierSelected
                                              .indexOf(' ')))],
                                  getInvoiceAmountSum(productsListToProcess),
                                  salesDate,
                                  globals.userID,
                                  descriptionController.text,
                                  clientNameController.text,
                                  productsListToProcess);

                              if (results["statuscode"] == "203") {
                                Navigator.pop(key.currentContext);
                                showAlertDialog(
                                    key.currentContext, results["invoiceNo"]);
                              } else {
                                Navigator.pop(key.currentContext);
                                showAlertDialog3(
                                    key.currentContext, results["Message"]);
                              }
                            }
                          } on SocketException catch (_) {
                            //print('not connected');
                            Navigator.pop(key.currentContext);
                            showAlertDialog_Network(key.currentContext, "");
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                          child: const Center(
                              child: Text(
                            'Continue',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  showLoaderDialogPrinter(BuildContext context) {
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text(
                "  Processing Invoice...",
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

  Card _agentsWidget(
    List AgentsList,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Text(
          "Agent:",
          style: TextStyle(
              fontSize: 15, fontStyle: FontStyle.italic, color: Colors.blue),
        ),
        title: _agentsDropdown2(AgentsList),
      ),
    );
  }

  CustomSearchableDropDown _agentsDropdown2(List agentsList) {
    return CustomSearchableDropDown(
      dropdownHintText: 'Search Agent Here... ',
      showLabelInMenu: false,
      primaryColor: Colors.blue,
      menuMode: true,
      labelStyle: TextStyle(
          color: Colors.black54,
          fontStyle: FontStyle.italic,
          fontFamily: 'constantia'),
      items: agentsList,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(30.0),
      ),
      dropdownItemStyle: const TextStyle(fontSize: 12, color: Colors.black),
      label: ' Search Agent',
      menuHeight: MediaQuery.of(context).size.height * 0.4,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 5.0),
        child: Icon(
          Icons.search,
          color: Colors.blue,
        ),
      ),
      dropDownMenuItems: agentsList.map((item) {
        return item;
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            // you may need an external function that
            _currentSupplierSelected = value!;

            if (globals.agentsList[2][int.parse(_currentSupplierSelected
                    .substring(0, _currentSupplierSelected.indexOf(' ')))] ==
                true) {
              clientNameController.text = "";
            } else {
              String clientName = _currentSupplierSelected
                  .substring(_currentSupplierSelected.indexOf(' ') + 1);
              clientNameController.text = clientName;
            }
            //call the other model function with selected maker
            //_modelList = getModelList(newValueSelected);
          });
        } else {
          _currentSupplierSelected = _currentSupplierSelected;
        }
      },
    );
  }

  CustomSearchableDropDown _productsDropdown2(List productsAList) {
    return CustomSearchableDropDown(
      dropdownHintText: 'Search Product Here... ',
      showLabelInMenu: false,
      primaryColor: Colors.blue,
      menuMode: true,
      labelStyle: const TextStyle(
          color: Colors.black54,
          fontStyle: FontStyle.italic,
          fontFamily: 'constantia'),
      items: productsAList,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(30.0),
      ),
      dropdownItemStyle: const TextStyle(fontSize: 12, color: Colors.black),
      label: ' Search Product',
      menuHeight: MediaQuery.of(context).size.height * 0.4,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 5.0),
        child: Icon(
          Icons.search,
          color: Colors.blue,
        ),
      ),
      dropDownMenuItems: productsAList.map((item) {
        return item;
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            // you may need an external function that
            _currentProductSelected = value!;
            newBool = true;

            int number = int.parse(_currentProductSelected.substring(
                0, _currentProductSelected.indexOf(' ')));
            print(number);
            costController.text = productsList[2][number];
            maxQty = productsList[4][number];
            validBal = productsList[5][number];

            /*
         costController.text = productsList[2][int.parse(
              productsList[1][int.parse(_currentProductSelected
                  .substring(0, _currentProductSelected.indexOf(' '))?? '0')] ?? '0')];
           */

            //call the other model function with selected maker
            //_modelList = getModelList(newValueSelected);
          });
        } else {
          _currentSupplierSelected = _currentSupplierSelected;
        }
      },
    );
  }

  DropdownButtonHideUnderline _agentsDropdown(List agentsList) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      //element 3
      isExpanded: true,
      itemHeight: 50.0,
      style: const TextStyle(fontSize: 4.0, color: Color(0xFF083663)),
      items: agentsList.map((var dropDownStringItem) {
        return DropdownMenuItem<String>(
          //instantiation ofDropdown
          value: dropDownStringItem,
          child: Text(
            dropDownStringItem,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (String? newValueSelected) {
        //action code when the item is selcted from the drop down menu
        setState(() {
          // you may need an external function that
          _currentSupplierSelected = newValueSelected!;

          if (globals.agentsList[2][int.parse(_currentSupplierSelected
                  .substring(0, _currentSupplierSelected.indexOf(' ')))] ==
              true) {
            clientNameController.text = "";
          } else {
            String clientName = _currentSupplierSelected
                .substring(_currentSupplierSelected.indexOf(' ') + 1);
            clientNameController.text = clientName;
          }
          //call the other model function with selected maker
          //_modelList = getModelList(newValueSelected);
        });
      },
      value: _currentSupplierSelected,
    ));
  }

  DropdownButtonHideUnderline _productsDropdown(List productsAList) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      //element 3
      isExpanded: true,
      itemHeight: 50.0,
      style: const TextStyle(fontSize: 4.0, color: Color(0xFF083663)),
      items: productsAList.map((var dropDownStringItem) {
        return DropdownMenuItem<String>(
          //instantiation ofDropdown
          value: dropDownStringItem,
          child: Text(
            dropDownStringItem,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (String? newValueSelected) {
        //action code when the item is selcted from the drop down menu
        setState(() {
          // you may need an external function that
          _currentProductSelected = newValueSelected!;
          newBool = true;

          int number = int.parse(_currentProductSelected.substring(
              0, _currentProductSelected.indexOf(' ')));
          print(number);
          costController.text = productsList[2][number];

          /*
         costController.text = productsList[2][int.parse(
              productsList[1][int.parse(_currentProductSelected
                  .substring(0, _currentProductSelected.indexOf(' '))?? '0')] ?? '0')];
           */

          //call the other model function with selected maker
          //_modelList = getModelList(newValueSelected);
        });
      },
      value: _currentProductSelected,
    ));
  }

  showAlertDialog(BuildContext context, String invoiceToSubmit) {
    // set up the buttons
    Widget nowButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        //primary: Colors.red, // background
      ),
      onPressed: () async {
        //Submit invoice
        try {
          final result = await InternetAddress.lookup(
              'www.google.com'); //checking for internet connection
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            Navigator.pop(context);
            showLoaderDialog2(context, invoiceToSubmit);
            final results = await ApiService.submitInvoice(invoiceToSubmit);
            print("Submit Invoice Results");
            print(result);
            print(results["Returncode"]); //203
            print(results["Message"]); //null

            if (results["Returncode"] == "203") {
              final results2 = await ApiService.loginDetails(globals.userID);
              print(results2["products"]);
              setState(() {
                globals.productsList = getProductsDetailsLists(results2[
                    "products"]); //updating product list after successful submit
                productsList = globals.productsList;
              });

              Navigator.pop(context);
              _formRefresh();

              _formRefresh();
              showAlertDialog2(context, results["Message"],
                  results["Returncode"], invoiceToSubmit);
            } else {
              Navigator.pop(context);
              showAlertDialog2_err(
                  context, results["Message"], results["Returncode"]);
            }
          }
        } on SocketException catch (_) {
          //print('not connected');
          Navigator.pop(context);
          showAlertDialog_Network(context, "");
        }
      },
      child: const Text('Submit'),
    );

    /*
    Widget laterButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        primary: Colors.amber, // background
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      child: const Text('Submit Later'),
    );
     */

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Successful!",
        style: TextStyle(color: Colors.green),
      ),
      content: Text(
          "Sales invoice successfully processed. Invoice Number:  *$invoiceToSubmit*"),
      actions: [
        nowButton,
        //laterButton,
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

  showAlertDialog2(BuildContext context, String message, String returnCode,
      String invoiceToSubmit) {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        //primary: Colors.amber, // background
      ),
      onPressed: () async {
        Navigator.pop(context);
        //print through printer
        showLoaderDialog1(context);
        final results = await ApiService.printInvoice(invoiceToSubmit);
        // Amount: 337500.00,
        //Tax: 0,
        // Qrcode: ,
        print("Invoice print successful");
        print(results);
        if (results["statuscode"] == "203") {
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
      },
      child: const Text('Print'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Successful!",
        style: TextStyle(color: Colors.green),
      ),
      content: Text("Invoice Number:  *$message* : $returnCode"),
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

  showAlertDialog3(BuildContext context, String message) {
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
      content: Text("Sales invoice processing Error:  *$message*"),
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

  showAlertDialog_Network(BuildContext context, String message) {
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
      content: const Text(
          "Network Error! Please Check your Internet connection ...."),
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
          text: sumTotal
              .toString()
              .replaceAllMapped(globals.reg, globals.mathFunc), //amount
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
          text: taxAmount.replaceAllMapped(
              globals.reg, globals.mathFunc), //amount
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
          text: amount.replaceAllMapped(globals.reg, globals.mathFunc),
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
      await PrintBluetoothThermal.writeBytes(bytes);
    } else {
      if (!mounted) return;
      showLoaderDialogPrinter(context);
    }
  }
}
