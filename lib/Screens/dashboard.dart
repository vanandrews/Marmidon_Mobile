import 'package:flutter/material.dart';

import 'package:marmidon/Screens/Profile/page_profile.dart';
import 'package:marmidon/Services/my_globals.dart';

import 'package:marmidon/Screens/Home/inventory_page.dart';
import 'package:marmidon/Screens/Home/sales_page.dart';
import 'package:marmidon/Screens/Home/finance_page.dart';

import 'package:marmidon/Screens/Reports/reports.dart';
import 'package:marmidon/Screens/Reports/submit_pending_invoice.dart';
import 'package:marmidon/Screens/Reports/search_invoice.dart';

import 'package:marmidon/Screens/Reports/printing.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'Home/Sales Management/invoincing.dart';


class DashboardPage extends StatefulWidget {
  final String username;
  final String password;

  DashboardPage(this.username, this.password);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  final List _pages = [
    ReportsPage(), // Reports Screens
    InvoicingPage(), //HomePages(),
    ProfilePage(username,password),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Marmidon Mobile'),
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap:_onItemTapped,
      ),
    );
  }
}


class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState()  {
    checkBTPrinterConnection();
    super.initState();
  }

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Reports',
                  ),
                  Tab(
                    text: 'Search',
                  ),
                  Tab(
                    text: 'Pending',
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Reports(),
            SearchInvoice(),
            SubmitInvoice(),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
              if (globals.printerState != true) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddMyPrinter())).then((_) {
                  // This block runs when you have come back to the 1st Page from 2nd.
                  setState(() {
                    checkBTPrinterConnection();
                    // Call setState to refresh the page.
                  });
                });
              }
            },
          backgroundColor: globals.printerState == true? Colors.green:Colors.red,

          child: const Icon(Icons.local_print_shop_outlined,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

}


class HomePages extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Inventory',
                  ),
                  Tab(
                    text: 'Sales',
                  ),
                  Tab(
                    text: 'Finance',
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InventoryPage(),
            SalesPage(),
            FinancePage(),
          ],
        ),
      ),
    );
  }
}
