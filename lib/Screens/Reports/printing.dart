import 'package:flutter/material.dart';
import 'dart:async';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:permission_handler/permission_handler.dart';

class AddMyPrinter extends StatefulWidget {
  @override
  _AddMyPrinterState createState() => _AddMyPrinterState();
}

class _AddMyPrinterState extends State<AddMyPrinter> {
  @override
  void initState() {
    super.initState();
  }

  bool connected = false;
  List<BluetoothInfo> availableBluetoothDevices = [];
  List ColorsList = [];

  Future<bool> requestAccess() async {
    //request here your permissions
    bool permOne = await Permission.bluetoothScan.request().isGranted;
    bool permTwo = await Permission.bluetoothAdvertise.request().isGranted;
    bool permThree = await Permission.bluetoothConnect.request().isGranted;

    //This will only bring up one permission pop-up, but will only grant the permissions you have been requested here
    //in this method.

    //Return your boolean here
    return permOne && permTwo && permThree ? true : false;
  }

  Future<void> getBluetooth() async {
    final List<BluetoothInfo>? bluetooths = await PrintBluetoothThermal.pairedBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
      ColorsList = List.filled(availableBluetoothDevices.length, Colors.white);
    });
  }

  Future<void> setConnect(String name,String mac,BuildContext context,final index) async {
    showLoaderDialog(context);
    print("*****Printer Mac Adress******");  //04:7F:0E:54:EF:7E, 04:7F:0E:55:31:38
    print(mac);
    final bool? result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conneected $result");
    if (result == true) {
      setState(() {
        Navigator.of(context).pop(true);
        connected = true;
        globals.printerState = true;
        ColorsList[index] = Colors.green;
        //showAlertDialog(context,name+":"+mac);
      });
    }else{
      globals.printerState = false;
      ColorsList[index] = Colors.red;
      //showAlertDialog2(context,name+":"+mac);
    }
  }

  Future<void> printTicket() async {
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      globals.printerState = true;
      List<int> bytes = await getTicket();
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> printGraphics() async {
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getGraphicsTicket();
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];

    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Print QR Code using native function
    bytes += generator.qrcode('example.com');

    bytes += generator.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.cut();

    return bytes;
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("Demo Shop",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(
        "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919591708470',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Sada Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "30",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "3", width: 1),
      PosColumn(
          text: "Masala Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "50",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "4", width: 1),
      PosColumn(
          text: "Rova Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "70",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
      PosColumn(
          text: "160",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("26-11-2020 15:22:45",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  List connectedList = [];
  int i = 0;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Connect Printer '),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.red, // background
                  ),
                  onPressed: () {
                      requestAccess();
                      this.getBluetooth();
                    },
                  child: Text('Search Paired Bluetooth Printer'),
                ),
              ),
          Expanded(
            child: Container(
              height: 200,
              child: ListView.builder(
                itemCount: availableBluetoothDevices.length > 0
                    ? availableBluetoothDevices.length
                    : 0,
                itemBuilder: (context, index) {
                  final color = ColorsList[index];
                  return ListTile(
                    onTap: () {
                      BluetoothInfo btInfo = availableBluetoothDevices[index];
                      // String name = list[0];
                      String name = btInfo.name;
                      String mac = btInfo.macAdress;
                      this.setConnect(name,mac,context,index);
                    },
                    title: Text('${availableBluetoothDevices[index].name}: ${availableBluetoothDevices[index].macAdress} ',overflow: TextOverflow.ellipsis,),
                    subtitle: Text("Click to connect"),
                    tileColor:color,
                  );
                },
              ),
            ),
          ),

            ],
          ),
        ),
      );

  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(" Connecting Printer....",overflow: TextOverflow.ellipsis, )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context,String address) {
    Widget launchButton = TextButton(
      child: Text(" Ok "),
      onPressed:  () {
        //Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("$address Connected successfully!!"),
      actions: [
        launchButton,
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

  showAlertDialog2(BuildContext context,String address) {
    Widget launchButton = TextButton(
      child: Text(" Ok "),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("$address Not Connected. Search Printer!!"),
      actions: [
        launchButton,
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

