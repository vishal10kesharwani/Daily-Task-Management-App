import 'package:flutter/material.dart';
import 'package:userauthsqlite/models/user.dart';
import 'package:userauthsqlite/screens/home_page.dart';

import '../services/taskServices.dart';

List<User> users = [];
int activeStep = 1;
TimeOfDay _selectedTime = TimeOfDay.now();
bool light0 = true;
DateTime? selectedDate = DateTime.now();
int? userid;

class AddNewTask extends StatefulWidget {
  int? id;
  AddNewTask({Key? key, required this.id}) : super(key: key);
  @override
  State createState() => DynamicList();
}

DateTimeRange dateRange = DateTimeRange(
  start: DateTime(2024, 02, 5),
  end: DateTime(2024, 02, 10),
);

class DynamicList extends State<AddNewTask> {
  Key key = UniqueKey();

  final TextEditingController _task = TextEditingController();
  Task tasks = Task(1, "Cultural Meeting", "09/02/2024", "01 : 04 PM", true);
  String? _time;
  String? _alarm = light0.toString();
  void _submit() async {
    setState(() {
      _time =
          "${_selectedTime.hourOfPeriod.toString().padLeft(2, '0')} : ${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period.toString().toUpperCase().split('.').last}";
      if (_task.text.isEmpty || selectedDate == null || _time == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "⚠️ Title or Time should not be empty !!",
            style: TextStyle(
                color: Colors.red), // Optional: change text color to red
          ),
          showCloseIcon: true,
          closeIconColor: Colors.red,
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
          duration: Duration(seconds: 1),
          backgroundColor: Colors.white
              .withOpacity(0.4), // Optional: change background color to yellow
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            // Add border
            borderRadius: BorderRadius.circular(
                10.0), // Optional: adjust border radius as needed
            side: BorderSide(color: Colors.red), // Set border color to red
          ),
        ));
        return;
      }

      Task newTask =
          Task(userid, _task.text, selectedDate.toString(), _time, _alarm);
      print(newTask);
      print(" $userid ${_task.text} $selectedDate $_time $_alarm");
      var db = new TaskServices();
      // var res = await db.insertUser(newUser);
      var res = db.addTask(newTask);
      if (res != null) {
        print("Task Added");
        _showSnackBar("Task Added Successfully");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(id: userid)));
      }
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(text),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        print(_selectedTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userid = widget.id;
      print(userid);
    });
// Assign widget.id to globalId
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

    return Scaffold(
      backgroundColor: Color(0xFFFF9F74),
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leadingWidth: 140,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 15),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.35),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(id: userid)));
              },
              icon: Icon(
                // <-- Icon
                Icons.close,
                size: 24.0,
              ),
              label: Text('Back'), // <-- Text
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: const Padding(
                  padding: EdgeInsets.only(left: 30, top: 30, bottom: 50),
                  child: Text(
                    "Create New Task",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )),
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height <= 740
                      ? MediaQuery.of(context).size.height + 80
                      : MediaQuery.of(context).size.height - 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.30),
                        blurRadius: 98.0,
                        offset: Offset(0, -20),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: Color(0xFFFBEFE4),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(35),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () => pickDateRange(),
                                child: CalendarDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  onDateChanged: (value) {
                                    setState(() {
                                      selectedDate = value;
                                      print(
                                          selectedDate); // Update selectedDate variable
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Time",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 10),
                              child: Text(
                                "Hour        Minute",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFFF9F74),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      '${_selectedTime.hourOfPeriod}    :    ${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period.toString().split('.').last}',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  IconButton(
                                      onPressed: () => _selectTime(context),
                                      icon: Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Title",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _task,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text("Write the Title "),
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Alarm",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Switch(
                                value: light0,
                                onChanged: (bool value) {
                                  setState(() {
                                    light0 = value;
                                  });
                                },
                                activeColor: Colors.white,
                                activeTrackColor: Color(0xFFFF9F74),
                                inactiveThumbColor: Colors.black,
                                inactiveTrackColor: Colors.orange,
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  _submit();
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFFF9F74)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(130, 60),
                                    ),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void dateSelect(DateTime value) {}

  void onAlarm(bool value) {}

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    setState(() {
      dateRange = newDateRange ?? dateRange;

      // if (newDateRange == null) return;
      // setState(() => dateRange = newDateRange);
    });
  }
}
