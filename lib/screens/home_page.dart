import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userauthsqlite/models/user.dart';
import 'package:userauthsqlite/screens/Card/taskCard.dart';
import 'package:userauthsqlite/screens/addNewTask.dart';
import 'package:userauthsqlite/utils/colorConstants.dart';

import 'auth/login_page.dart';

List<User> users = [];
int activeStep = 1;
var userid;

class HomePage extends StatefulWidget {
  int? id; // Add id parameter

  HomePage({Key? key, required this.id}) : super(key: key);

  @override
  State createState() => DynamicList();
}

class DynamicList extends State<HomePage> {
  Key key = UniqueKey();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      userid = widget.id;
    });
    _checkLoggedIn();
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
    print(prefs.getInt("userid"));
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userid');
    print(prefs.getBool('isLoggedIn'));

    setState(() {
      isLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User Logged out successfully"),
    ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AddNewTask(id: userid),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedPage = '';
    Color iconColor = Colors.white;
    return isLoggedIn
        ? Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              child: const Icon(Icons.add),
              shape: CircleBorder(),
              backgroundColor: Color(0xFFFF9F74),
              foregroundColor: Colors.white,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 70,
              color: Color(0xFFFFE7D0),
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home_rounded,
                      color: ColorConstants.mainColor,
                    ),
                    onPressed: () {
                      setState(() {
                        // Change the color of the icon
                        iconColor = ColorConstants
                            .mainColor; // Change it to any color you want
                      });
                    },
                    focusColor: ColorConstants.mainColor,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 10),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Text(userid.toString()),
                            enabled: false,
                          ),
                          PopupMenuItem<String>(
                            onTap: () {
                              _logout();
                            },
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ];
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), //or 15.0
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          color: ColorConstants.mainColor,
                          child: Icon(Icons.person,
                              color: Colors.white, size: 30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 30, top: 100, bottom: 30),
                        child: Text(
                          "Daily Task",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height <= 740
                        ? MediaQuery.of(context).size.height + 80
                        : MediaQuery.of(context).size.height - 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFD2A2).withOpacity(0.70),
                          blurRadius: 3.0,
                          offset: Offset(0, -1),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Color(0xFFFBEFE4),
                    ),
                    //first card
                    child: TaskCard(id: userid),
                  )
                ],
              ),
            ),
          )
        : LoginPage();
  }
}
