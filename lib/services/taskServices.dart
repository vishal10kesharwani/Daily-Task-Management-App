import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:userauthsqlite/models/user.dart';

class TaskServices {
  static final TaskServices _instance = TaskServices.internal();
  factory TaskServices() => _instance;
  TaskServices.internal();

  var _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'task-data.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Task(userid INTEGER, task TEXT, date TEXT, time TEXT, alarm TEXT)');
  }

//insertion
  Future<int> addTask(Task task) async {
    var dbClient = await db;
    int res = await dbClient.insert(
      "Task",
      task.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Task $res Added Successfully");
    return res;
  }

  Future<List<Task>> getAllTask(int? id) async {
    var dbClient = await db;
    List<Task> tasks = [];
    List<Map<String, dynamic>> res =
        await dbClient.query("Task", where: '"userid" = ?', whereArgs: [id]);
    for (var row in res) {
      //print(row['id']);
      tasks.add(Task.map(row));
    }
    print("Task Get Success");
    return Future<List<Task>>.value(tasks);
  }

  Future<Future<int>> deleteSingleTask(Task task) async {
    var dbClient = await db;
    Future<int> res =
        dbClient.delete("Task", where: '"task" = ?', whereArgs: [task.task]);
    return res;
  }
}
