import 'package:http/http.dart' as http;
import 'package:marmidon/Screens/Reports/submit_pending_invoice.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'package:marmidon/Services/my_globals.dart' as globals;

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
//String apiToUse = "38.242.155.180";
//38.242.155.180 - WAKISO
//38.242.230.76 - FORT
//38.242.230.78 - MITYANA
//79.143.179.71 - ELITE
//79.143.179.208 -Jinja
//79.143.178.58- MBALE
//38.242.203.200  - MAAM PRIDE
//79.143.178.196 - KIDDA BANDWE
//38.242.155.181 - Ntake
//38.242.230.81 - Trust
//79.143.181.37 - Kyapa
//79.143.179.249 - Jusco
//167.86.107.196 - Support



class ApiService {
  static Future<dynamic> login(String userName,String userPassword,String serialNumber) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://167.86.107.196/Connector/Wellington/api/login_new'); //support api :167.86.107.196

    var body = {
      "username": userName,
      "password": userPassword,
      "serial": serialNumber
    };
    var req = http.Request('GET', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }

  static Future<dynamic> loginDetails(String userId) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/LoginDetails'); //support api :167.86.107.196

    var body = {
      "UserID": userId
    };
    var req = http.Request('GET', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }

  static Future<dynamic> processInvoice(String invoiceNumber,String AgentID,String invoiceAmount,String salesDate,
      String userID,String narration, String clientName, List productsList) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/processInvoice');

    var body = {
      "invoiceNo": invoiceNumber,
      "AgentID": AgentID,
      "invoiceAmount": invoiceAmount,
      "SalesDate": salesDate,
      "UserID": userID,
      "taxCategory": "01",
      "taxrate": "18",
      "Narration": narration,
      "ClientName": clientName,
      "Invoiceitems": productsList
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }

  }

  static Future<dynamic> submitInvoice(String invoiceNumber) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/submitinvoice');

    var body = {
      "invoiceNo": invoiceNumber,
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }


  static Future<dynamic> searchInvoices(String invoiceNumber,String startDate,String endDate,String status) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/searchinvoice');

    var body = {
      "InvoinceNumber": invoiceNumber,
      "StartDate": "2000-04-10",
      "EndDate": endDate,
      "Status": status
    };
    var req = http.Request('GET', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }

  static Future<dynamic> searchPendingInvoices(String invoiceNumber,String startDate,String endDate,String status) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/searchinvoice');

    var body = {
      "InvoinceNumber": invoiceNumber,
      "StartDate": "2000-04-10",
      "EndDate": endDate,
      "Status": "PENDING"
    };
    var req = http.Request('GET', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }


  static Future<dynamic> printInvoice(String invoiceNumber) async{
    var headersList = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://${globals.ipToUse}/Connector/Wellington/api/printInvoice');

    var body = {
      "invoiceNo": invoiceNumber,
    };

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);
    req.body = convert.json.encode(body);

    final res = await req.send();

    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return convert.json.decode(resBody);
    }
    else {
      print(res.reasonPhrase);
      return null;
    }
  }


  static Future<dynamic> GetAccountsList(String profile,String company, String branch, String CustomerNumber)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB102/$profile/$company/'
        '$branch/$CustomerNumber/XXX999/XXX999/XXX999/XXX999/XXX999/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> GetTransactionsHistory(String profile,String company, String branch, String CustomerNumber,String accountCodes)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB103/$profile/$company/'
        '$branch/$CustomerNumber/$accountCodes/XXX999/XXX999/XXX999/XXX999/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> GetAccountStatement(String profile,String company, String branch,String memberNumber, String accountNumber)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB105/$profile/$company/'
        '$branch/$memberNumber/$accountNumber/XXX999/XXX999/XXX999/XXX999/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> PostTransferToWallet(String profile,String company, String branch, String glNumber,String fromAccount, String Telecom,
      String Phone, String Amount)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB109/$profile/$company/$branch/'
        '$glNumber/$fromAccount/$Telecom/$Phone/$Amount/XXX999/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> PostTransferFromMobile(String profile,String company, String branch, String glNumber,String fromAccount, String Telecom,
      String Phone, String Amount)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB110/$profile/$company/$branch/'
        '$glNumber/$fromAccount/$Telecom/$Phone/$Amount/XXX999/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> PostTransferToAccount(String profile,String company, String branch, String glNumber,String fromAccount, String Telecom,
      String Phone, String Amount, String accountTo)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://${globals.ipAddress}/MobileBanking/Wellington/MOB108/$profile/$company/$branch/'
        '$glNumber/$fromAccount/$Telecom/$Phone/$Amount/$accountTo/XXX999');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // now it's safe to send the request
    http.Response response = await http.get(Uri.parse(url),headers: headers);

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }


/*
  static Future<dynamic> PostTransferToWallet(String profile, String branch, String accountTo, String Telecom,
      String Phone, String Amount, String Reason)async{
    //final response = await http.get('${urls.BASE_API_URL}');
    String url = Uri.encodeFull('http://rehmsys1.000webhostapp.com/arafat_login.php?values=$Amount');

    // headers should be a subtype of Map<String, String>
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    Map<String, String> body1 ={
      'title': Amount,
    };

    // now it's safe to send the request
    http.Response response = await http.post(Uri.parse(url),headers: headers, body: convert.jsonEncode(body1));

    if (response.statusCode == 200){
      return convert.json.decode(response.body);
    }else{
      return null;
    }
  }

 */

}

