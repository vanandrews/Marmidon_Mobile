import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marmidon/Services/my_globals.dart' as globals;
import 'package:marmidon/Screens/login.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userPassword;

  // receive data from the FirstScreen as a parameter
  ProfilePage(this.userName,this.userPassword);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 25.0,color: Colors.white);

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName;
    String userPassword = widget.userPassword;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    userName = globals.fullName;

    return Scaffold(
      body: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.blue,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.blue),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              SizedBox(height: 100,child: userProfileBoxCard(userName)),
              SizedBox(height: 15),
              Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: accountSection(userName,userPassword,context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget upperPart(String Username) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Center(child: titleWidget(Username),)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text titleWidget(String Username) {
    return Text("My Profile",textAlign: TextAlign.center,
      style: style,);
  }

  Container userProfileBoxCard(String userName) {
    return Container(
        height: 100,
        child: Padding(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child:ListTile(
                      leading: IconButton(
                        iconSize: 70,
                        color: Colors.white,
                        icon: Icon(Icons.account_circle),
                        onPressed: (){
                          //go to reports search page
                          //navigateToReportsSearchPage();
                        },
                      ),
                      subtitle: Text(' $userName ',style: TextStyle(fontSize: 20,color: Colors.white),)
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}


Widget accountSection(String userName,String userPassword,BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Text("Change Username"),
              onTap: () {
                //change username
                //navigationToChangeUsername(userName,userPassword);
              },
              trailing: Icon(Icons.arrow_forward_ios,color: Colors.blueAccent,),
              // Si,
            ),
          )
      ),
      Divider(
        color: Colors.grey,
      ),

      Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Text("Change Password"),
              trailing: Icon(Icons.arrow_forward_ios,color: Colors.blueAccent),
              onTap: () {
                //change password
                //navigationToChangePassword(userName,userPassword);
              },
            ),
          )
      ),
      Divider(
        color: Colors.grey,
      ),

      Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Text("Add new user",),
              trailing: Icon(Icons.arrow_forward_ios,color: Colors.blueAccent),
              onTap: () {
                //add new user
                // navigationToAddUser(exRateValue);
              },
            ),

          ),
      ),
      Divider(
        color: Colors.grey,
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListTile(
            leading: Text("LogOut",),
            onTap: () {
              //add new user
              Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Login()));
            },
          ),

        ),
      ),
      Divider(
        color: Colors.grey,
      ),
    ],
  );
}


