import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Sales Management/invoincing.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with AutomaticKeepAliveClientMixin<SalesPage> {
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
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Sales Management",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'constantia',
                        )),
                    leading: IconButton(
                      icon: Icon(
                        Icons.attach_money,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                    onTap: () {},
                  ), //Sales management
                  Divider(
                    color: Colors.grey,
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "View Sales Agents",
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "Add Sales Agents",
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
                  ), //Module Data Setup
                  Divider(
                    color: Colors.grey,
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text("Loading and Ordering",
                          style: TextStyle(
                            fontFamily: 'constantia',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          )),
                      leading: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      children: <Widget>[
                        ListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "Customer Ordering",
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "Dispatch Close Period",
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text("Customer Invoincing",
                              style: TextStyle(fontSize: 12)),
                          onTap: () {
                            //model to get accounts List for savings and total sum
                            //List loanAccountsList = getLoanSavingsAccountsList(globals.AccountsList)[0];
                            //String accBal = getAccountsSum(loanAccountsList).toString();
                            //Navigator.of(context).pop();
                            //Navigator.of(context).push(MaterialPageRoute(
                            //builder: (BuildContext context) => BalanceLoans(loanAccountsList,accBal))); // accounts list and balances
                          },
                        ),
                        ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text("Invoincing",
                                style: TextStyle(fontSize: 12)),
                            onTap: () async {
                              //model to get accounts List for savings and total sum
                              //List loanAccountsList = getLoanSavingsAccountsList(globals.AccountsList)[0];
                              //String accBal = getAccountsSum(loanAccountsList).toString();
                              //Navigator.of(context).pop();
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => InvoicingPage()))
                                  .then((_) {
                                // This block runs when you have come back to the 1st Page from 2nd.
                                setState(() {
                                  // Call setState to refresh the page.
                                });
                              });
                            }),
                      ],
                    ),
                  ), //Loading and Ordering
                  Divider(
                    color: Colors.grey,
                  ),
                  Theme(
                    //Inventory Out
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text("Sales Invoincing",
                          style: TextStyle(
                            fontFamily: 'constantia',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          )),
                      leading: Icon(
                        Icons.money_sharp,
                        color: Colors.blue,
                        size: 30,
                      ),
                      children: <Widget>[
                        ListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "View Invoinces",
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            "Reverse Invoince",
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
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          title: Text("Orders/Invoices - Reversed",
                              style: TextStyle(fontSize: 12)),
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
}
