import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports>
    with AutomaticKeepAliveClientMixin<Reports> {
  int count = 10;

  void clear() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(child:
            ListView(
              children: [
                Theme(
                  data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text("Sales Reports",
                        style: TextStyle(
                          fontFamily: 'constantia',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                    leading: const Icon(
                      Icons.analytics_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    children: <Widget>[
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Sales Details",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Vat Sales",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Credit Note App List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Invoice List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Daily Dispatch",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Sales Agent List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Sales Product List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text(
                          "Sales Analysis",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Theme(
                  data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text("Inventory Reports",
                        style: TextStyle(
                          fontFamily: 'constantia',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                    leading: Icon(
                      Icons.analytics_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    children: <Widget>[
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Purchases",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {

                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Stock Card",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {

                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Stockmovement List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {

                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Closing Balance List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {

                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Stock Item List",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () async {

                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
              ],
            ),
            ),

            // Text('Total incoming calls: $count',
            //     style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: clear,
      //   child: Icon(Icons.clear_all),
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(" Please Connect Printer....",overflow: TextOverflow.ellipsis, )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
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

}

