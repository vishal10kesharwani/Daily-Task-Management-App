import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userauthsqlite/models/user.dart';
import 'package:userauthsqlite/screens/home_page.dart';

import '../../services/services.dart';

TextEditingController selectedDate = TextEditingController();
var date;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BuildContext? _ctx;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fullname = TextEditingController();
  User users = User("Vishal", "Vishal", "fggdg", "456476", "v@gmail.com");
  String? _username, _password, _email;
  void _submit() async {
    final form = formKey.currentState;
    print(form);
    if (form!.validate()) {
      setState(() {
        form.save();
        User newUser = User(
            _username.toString(),
            _password.toString(),
            _fullname.text, // Add the logic to get full name from the form
            selectedDate.text,
            _email.toString());
        print(newUser);
        print(" $_username $_password ${_fullname.text} $selectedDate $_email");
        var db = new Services();
        // var res = await db.insertUser(newUser);
        var res = db.insertUser(newUser);
        if (res != null) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool("isLoggedIn", true);
          });
          print("User Added");
          _showSnackBar("User Added Successfully");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(id: newUser.id)));
        }
      });
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            margin: EdgeInsets.only(left: 20, bottom: 250, right: 20, top: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "User Registration Page",
                        textScaleFactor: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextField(
                              controller: _fullname,
                              decoration: const InputDecoration(
                                  labelText: "Enter Your Full Name",
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: selectedDate,
                              decoration: InputDecoration(
                                labelText: "Enter Your Date of Birth",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              onChanged: (val) => _username = val,
                              decoration: const InputDecoration(
                                  labelText: "Enter Your Username",
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              onChanged: (val) => _password = val,
                              decoration: const InputDecoration(
                                  labelText: "Enter your Password",
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              onChanged: (val) => _email = val,
                              decoration: const InputDecoration(
                                  labelText: "Enter your Email ID",
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CupertinoButton(
                      child: new Text("Register"),
                      onPressed: _submit,
                      color: Colors.deepOrangeAccent),
                  CupertinoButton(
                      child: new Text("Login"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/login");
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        // initialDate: date,
        firstDate: DateUtils.dateOnly(DateTime(1901, 1)),
        lastDate: DateUtils.dateOnly(DateTime(2100)));
    var dateTime = DateTime.parse(picked.toString());
    var formate2 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    if (picked != null && picked != date)
      setState(() {
        date = formate2;
        selectedDate.value = TextEditingValue(text: formate2.toString());
      });
  }

  @override
  void onRegisterError(String error) {}

  @override
  void onRegisterSuccess(User user) async {}
}
