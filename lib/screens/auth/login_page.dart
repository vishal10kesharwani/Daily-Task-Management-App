import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userauthsqlite/screens/home_page.dart';
import 'package:userauthsqlite/services/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

int? user;

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _username, _password;

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      var db = Services();

      db.getUser(_username!, _password!).then((value) {
        if (value != null) {
          user = value;
          print(value);
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool("isLoggedIn", true);
            prefs.setInt("userid", userid);
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User Logged In Successfully"),
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage(id: user)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User Not Found"),
          ));
        }
      });
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(left: 30, bottom: 250, right: 30, top: 30),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0, top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Login Page",
                      textScaleFactor: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            onChanged: (val) => _username = val,
                            decoration: const InputDecoration(
                              labelText: "Enter Your Username",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            onChanged: (val) => _password = val,
                            decoration: const InputDecoration(
                              labelText: "Enter your Password",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Text("Login"),
                  onPressed: _submit,
                  color: Colors.deepOrangeAccent,
                ),
                CupertinoButton(
                  child: const Text("Register"),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/register");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
