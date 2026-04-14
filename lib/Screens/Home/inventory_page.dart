import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with AutomaticKeepAliveClientMixin<InventoryPage> {
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
                  title: Text("Inventory Management",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'constantia',
                      )),
                  leading: IconButton(
                    icon: Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                  onTap: () {
                  },
                ),
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
                          "Store Close Period",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //final savingsAccounts = getLoanSavingsAccountsList(globals.AccountsList)[1];

                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) =>
                          //TransfersToAccounts(savingsAccounts)));
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "View Stock Items",
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
                          "Add Stock Items",
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
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "View Vendors",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //final loanAccounts = getLoanSavingsAccountsList(globals.AccountsList)[0];

                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) =>
                          //TransfersLoanRepay(loanAccounts)));
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Add Vendors",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //final loanAccounts = getLoanSavingsAccountsList(globals.AccountsList)[0];

                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) =>
                          //TransfersLoanRepay(loanAccounts)));
                        },
                      ),
                    ],
                  ),
                ),   //Module Data Setup
                Divider(
                  color: Colors.grey,
                ),
                Theme(
                  data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text("Inventory In",
                        style: TextStyle(
                          fontFamily: 'constantia',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                    leading: Icon(
                      Icons.transit_enterexit_sharp,
                      color: Colors.blue,
                      size: 30,
                    ),
                    children: <Widget>[
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Stock In Batch",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //model to get accounts List for savings and total sum
                          //List savingAccountsList = getLoanSavingsAccountsList(globals.AccountsList)[1];
                          //String accBal = getAccountsSum(savingAccountsList).toString();
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) => BalanceSavings(savingAccountsList,accBal))); // accounts list and balances
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text("View Stock In", style: TextStyle(fontSize: 12)),
                        onTap: () {
                          //model to get accounts List for savings and total sum
                          //List loanAccountsList = getLoanSavingsAccountsList(globals.AccountsList)[0];
                          //String accBal = getAccountsSum(loanAccountsList).toString();
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) => BalanceLoans(loanAccountsList,accBal))); // accounts list and balances
                        },
                      ),
                    ],
                  ),
                ), //Inventory In
                Divider(
                  color: Colors.grey,
                ),
                Theme(  //Inventory Out
                  data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text("Inventory Out",
                        style: TextStyle(
                          fontFamily: 'constantia',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                    leading: Icon(
                      Icons.outbond_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    children: <Widget>[
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                          "Stock Out Batch",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          //provide savings accounts list
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) => StatementSavings()));
                        },
                      ),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        title: Text("View Stock Out", style: TextStyle(fontSize: 12)),
                        onTap: () {
                          //Navigator.of(context).pop();
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (BuildContext context) => StatementLoans()));
                        },
                      ),
                    ],
                  ),
                ), //Inventory Out
                Divider(
                  color: Colors.grey,
                ),

              ],
            ),
            )
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
}