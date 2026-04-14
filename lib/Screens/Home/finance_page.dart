import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with AutomaticKeepAliveClientMixin<FinancePage> {
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
                ListTile(
                  title: Text("Finance General",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'constantia',
                      )),
                  leading: IconButton(
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                  onTap: () {
                  },
                ), //Sales management
                Divider(
                  color: Colors.grey,
                ),
                Theme(
                  data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text("Module Data Setup",
                        style: TextStyle(
                          fontFamily: 'constantia',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                    leading: Icon(
                      Icons.create_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    children: <Widget>[

                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "View Accounting Codes",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //final savingsAccounts = getLoanSavingsAccountsList(globals.AccountsList)[1];
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) =>
                          //TransfersToMobileWallet(savingsAccounts)));
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Add Accounting Codes",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //final savingsAccounts = getLoanSavingsAccountsList(globals.AccountsList)[1];
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) =>
                          //TransfersDeposit(savingsAccounts)));
                        },
                      ),

                    ],
                  ),
                ),   //Module Data Setup
                Divider(
                  color: Colors.grey,
                ),


              ],
            ),
            ),
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
}