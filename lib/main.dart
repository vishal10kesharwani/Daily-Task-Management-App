import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userauthsqlite/screens/auth/login_page.dart';
import 'package:userauthsqlite/screens/auth/register_page.dart';
import 'package:userauthsqlite/screens/home_page.dart';

bool? loggedIn;
int? userid;

void main() => runApp(new MyApp());

final routes = {
  '/login': (BuildContext context) => const LoginPage(),
  '/home': (BuildContext context) => HomePage(id: userid),
  '/register': (BuildContext context) => RegisterPage(),
  '/': (BuildContext context) => SplashScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Task Management',
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  _checkLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getBool('isLoggedIn'));
      loggedIn = prefs.getBool('isLoggedIn') ?? false;
      print(prefs.getInt("userid"));
      userid = prefs.getInt("userid");
    } catch (e) {
      // Handle error when accessing shared preferences
      print('Error accessing shared preferences: $e');
    } finally {
      // Navigate after checking logged-in status
      _navigate();
    }
  }

  void _navigate() {
    Future.delayed(Duration(seconds: 2), () {
      if (loggedIn == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(id: userid)));
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize the background color if needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon.jpg', width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}
