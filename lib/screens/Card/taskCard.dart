import 'dart:core';

import 'package:dashed_path/dashed_path.dart';
import 'package:flutter/material.dart';
import 'package:userauthsqlite/utils/colorConstants.dart';

import '../../models/user.dart';
import '../../services/taskServices.dart';

List<Task> tasks = [];
int? userid;
Task? task;
DateTime today = DateTime.now();
DateTime date = DateTime(today.year, today.month, today.day);
int itemCount = tasks.length;

class TaskCard extends StatefulWidget {
  final int? id;

  TaskCard({Key? key, required this.id}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
    userid = widget.id;
    var db = TaskServices();
    db.getAllTask(userid).then((value) {
      setState(() {
        tasks = value;
        itemCount = tasks.length;
        print("Records:$tasks");
      });
    });
    setState(() {});
  }

  List<dynamic> _parseTaskTime(String timeString) {
    // Remove spaces from the time string
    timeString = timeString.replaceAll(' ', '');

    // Split the time string to separate hours, minutes, and AM/PM
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].substring(0, 2));
    String period = timeString.substring(timeString.length - 2); // Get AM/PM

    // Adjust hour if it's PM and not noon
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0; // Convert 12 AM (midnight) to 0
    }

    // Return the parsed time as a list
    return [hour, minute, period];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final isSingleItem = itemCount == 1 && index == 0;
        final isLastItem = index == itemCount - 1;
        final colorIndex = index % colors.length;
        final taskIndex = index % taskColor.length;
        // final taskDate = taskDates[index];
        task = tasks[index];
        // print(task?.date);
        // print("Date ${date.toString()}");
        // Check if the task date is today
        List<dynamic> parsedTime = _parseTaskTime(task!.time.toString());
        DateTime currentTime = DateTime.now();
        DateTime taskTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          parsedTime[0], // Hour
          parsedTime[1], // Minute
        );
        // DateTime taskDate = DateTime.parse(task!.date);
        // print(taskDate);
        // Compare task time with current time
        if (taskTime.isBefore(currentTime)) {
          // If task time is in the past, return an empty SizedBox
          // var db = TaskServices();
          // db.deleteSingleTask(tasks[index]).then((value) {
          //   print("Unwanted Records deletion success");
          // });
          return SizedBox.shrink();
        }

        final isToday = date.toString() == task?.date.toString();

        if (!isToday) {
          // If it's not today's task, return an empty SizedBox
          return SizedBox.shrink();
        }

        return Dismissible(
          // Specify the direction to swipe and delete
          key: Key("itemCount"),
          onDismissed: (DismissDirection direction) {
            // Removes that item the list on swipe
            tasks.removeAt(index);
            // Shows the information on Snackbar
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height > 1000
                        ? MediaQuery.of(context).size.width * 0.16
                        : MediaQuery.of(context).size.width * 0.08,
                    top: 0,
                    right: 40,
                    bottom: 0),
                child: Row(
                  children: [
                    Container(
                      height: 150,
                      width: 70,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colors[colorIndex],
                            blurRadius: 10.0,
                            offset: Offset(0, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: colors[colorIndex],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            _getTaskLabel(task?.task),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    //second card
                    Expanded(
                      child: Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width * 0.58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(20),
                          ),
                          color: colors[colorIndex],
                        ),
                        //card top card
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                  height: 140,
                                  width:
                                      MediaQuery.of(context).size.width * 0.53 +
                                          3,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.23, color: colors[colorIndex]),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: taskColor[taskIndex],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 30, left: 20),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          //timing
                                          child: Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  color: colors[colorIndex]),
                                              SizedBox(width: 5),
                                              Text(
                                                "${task?.time}",
                                                style: TextStyle(
                                                    color: colors[colorIndex],
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //task
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Text(
                                                  (task?.task != '')
                                                      ? "\u2022   ${task?.task.toString().substring(0, 1).toUpperCase()}${task?.task.substring(1)} "
                                                      : task!.task,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLastItem)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height > 1000
                          ? MediaQuery.of(context).size.width * 0.21
                          : MediaQuery.of(context).size.width * 0.17,
                    ),
                    child: Transform(
                      transform: Matrix4.identity()..rotateZ(280 / 180),
                      child: CustomPaint(
                        painter: DashedPathPainter(
                          originalPath: Path()..lineTo(100, 0),
                          pathColor: colors[colorIndex],
                          strokeWidth: 3.0,
                          dashGapLength: 5.0,
                          dashLength: 7.0,
                        ),
                        size: const Size(100.0, 2.0),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 50)
            ],
          ),
        );
      },
    );
  }

  String _getTaskLabel(String? taskName) {
    if (taskName == null) return ''; // Handle null case

    taskName = taskName
        .toLowerCase(); // Convert to lowercase for case-insensitive matching

    if (taskName.contains('meeting') || taskName.contains('meet')) {
      return 'Meeting';
    } else if (taskName.contains('study') ||
        taskName.contains('learn') ||
        taskName.contains('homework')) {
      return 'Study';
    } else if (taskName.contains('travel') || taskName.contains('trip')) {
      return 'Travel';
    } else {
      if (taskName.contains(' ')) {
        List<String> words =
            taskName.split(' '); // Split the taskName into words
        String lastWord = words.last; // Get the last word
        return _capitalizeFirstLetter(
            lastWord); // Capitalize the first letter of the last word
      } else {
        // If taskName contains only one word, capitalize its first letter
        return _capitalizeFirstLetter(taskName);
      }
      return taskName;
    }
  }

  String _capitalizeFirstLetter(String word) {
    if (word != '') {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    } else {
      return word;
    }
  }
}
