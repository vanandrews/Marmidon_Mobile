import 'package:flutter/material.dart';
import 'package:marmidon/Screens/login.dart';


Future<void> main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marmidon',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromRGBO(52, 140, 228, 1),
        ),
      ),
      home: Login(),
    );
  }
}