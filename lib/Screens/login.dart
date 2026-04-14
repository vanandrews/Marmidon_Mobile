import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marmidon/Screens/dashboard.dart';
import 'package:marmidon/Services/api_services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/model_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  bool _isChecked = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final serialController = TextEditingController();

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> checkBTPrinterConnection() async {
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      globals.printerState = true;
    } else {
      globals.printerState = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            //physics: const NeverScrollableScrollPhysics(),
            child: Builder(builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(top: height * 0.19),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.15,
                      child: Image.asset(
                        //TODO update this
                        'Images/logo.png',
                        fit: BoxFit.fill,
                        width: width * 0.6,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk-Regular',
                        fontSize: 27.0,
                        color: Color.fromRGBO(52, 140, 228, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      //TODO update this
                      'Login to Mermidon Software',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromRGBO(52, 140, 228, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(52, 140, 228, 1)),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.code_sharp,
                                    color: Color.fromRGBO(52, 140, 228, 1),
                                    size: 20,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: serialController,
                              decoration: const InputDecoration(
                                hintText: 'Serial',
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(52, 140, 228, 1)),
                              ),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(52, 140, 228, 1)),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(52, 140, 228, 1)),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.supervised_user_circle,
                                    color: Color.fromRGBO(52, 140, 228,
                                        1), //Color.fromRGBO(20, 84, 138,0.9)
                                    size: 20,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: usernameController,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(52, 140, 228, 1))),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(52, 140, 228, 1)),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(52, 140, 228, 1)),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.vpn_key,
                                    color: Color.fromRGBO(52, 140, 228, 1),
                                    size: 20,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Passcode',
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(52, 140, 228, 1)),
                              ),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(52, 140, 228, 1)),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (usernameController.text == "" ||
                            passwordController.text == "" ||
                            serialController.text == "") {
                          final snackbar = SnackBar(
                            content: const Text(
                                ' Make Sure all fields are filled ........'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          try {
                            final result = await InternetAddress.lookup(
                                'www.google.com'); //checking for internet connection
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              showLoaderDialog(context);
                              final results = await ApiService.login(
                                  usernameController.text,
                                  passwordController.text,
                                  serialController.text);
                              if (results["UserID"] == "") {
                                Navigator.pop(context);
                                if (!context.mounted) return;
                                final snackbar = SnackBar(
                                  content: const Text(
                                      'Incorrect Username, Password or Serial.'),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else {
                                print("result");
                                print(result);
                                _handleRemeberme(_isChecked);
                                checkBTPrinterConnection();
                                globals.username = usernameController.text;
                                globals.password = passwordController.text;
                                globals.userID = results["UserID"];
                                globals.ipToUse = results["Server"];
                                globals.ipToUse_Version = results["Version"];
                                print(globals.userID);
                                print(globals.ipToUse);
                                print(globals.ipToUse_Version);

                                final results2 = await ApiService.loginDetails(
                                    globals.userID);
                                //print(results2["products"]);
                                globals.fullName = results2["FullName"];
                                globals.productsList = getProductsDetailsLists(
                                    results2["products"]);
                                globals.agentsList =
                                    getAgentsDetailsLists(results2["Agents"]);
                                Navigator.pop(context);
                                navigateToHome(usernameController.text,
                                    passwordController.text);
                              }
                            }
                          } on SocketException catch (_) {
                            //print('not connected');
                            if (!context.mounted) return;
                            final snackbar = SnackBar(
                              content: Text(
                                  'Network Error! Please Check connection ....'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(52, 140, 228, 1),
                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: const Center(
                            child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 24.0,
                                  width: 24.0,
                                  child: Theme(
                                    data: ThemeData(
                                        useMaterial3: false,
                                        unselectedWidgetColor: Color.fromRGBO(
                                            52, 140, 228, 1) // Your color
                                        ),
                                    child: Checkbox(
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor:
                                            Color.fromRGBO(52, 140, 228, 1),
                                        value: _isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked = value!;
                                          });
                                        }),
                                  )),
                              SizedBox(width: 10.0),
                              const Text("Remember Me",
                                  style: TextStyle(
                                      color: Color.fromRGBO(52, 140, 228, 1),
                                      fontSize: 12,
                                      fontFamily: 'Rubic'))
                            ]))
                    /*
                            Align(
                              alignment: Alignment.bottomRight,
                              child: new InkWell(
                                  child: new Text('Update Serial... ',style: TextStyle(color: Colors.white,
                                    decoration: TextDecoration.underline,),),
                                  onTap: ()async{
                                    //navigationToAddIp();
                                  }
                              ),
                            ),

                             */
                  ],
                ),
              );
            }),
          ),
        ]));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Signing In...")),
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

  void _handleRemeberme(bool value) {
    _isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('PhoneNumber', usernameController.text);
        prefs.setString('Serial', serialController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _phoneNumber = _prefs.getString("PhoneNumber") ?? "";
      var _serial = _prefs.getString("Serial") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_serial);
      print(_phoneNumber);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        usernameController.text = _phoneNumber;
        serialController.text = _serial;
      }
    } catch (e) {
      print(e);
    }
  }

  void navigationToLogin() {
    Navigator.pop(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  void navigateToHome(String username, String password) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return DashboardPage(username, password);
    }));
  }
}
