import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:userauthsqlite/models/user.dart';

class Services {
  static final Services _instance = Services.internal();
  factory Services() => _instance;
  Services.internal();

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
    String path = join(documentDirectory.path, 'userdata.db');
    var db = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT, fullname TEXT, dob TEXT,email TEXT )');
  }

  //
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE User ADD COLUMN email TEXT;");
    }
    //onCreate(db, newVersion);
  }

//insertion
  Future<int> insertUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert(
      "User",
      user.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("User $res Added Successfully");
    return res;
  }

  dynamic getUser(String username, String password) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query("User",
        where: '"username" = ? and "password"=?',
        whereArgs: [username, password]);
    print(res);

    if (res.length > 0) {
      return res.first['id'];
    } else {
      return null;
    }
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await db;
    List<User> users = [];
    List<Map<String, dynamic>> res = await dbClient.query("User");
    for (var row in res) {
      //print(row['id']);
      users.add(User.map(row));
    }
    print("User Get Success");
    return Future<List<User>>.value(users);
  }

  Future<Future<int>> deleteSingleUser(int id) async {
    var dbClient = await db;
    Future<int> res =
        dbClient.delete("User", where: '"id" = ?', whereArgs: [id]);
    return res;
  }

  Future<void> updateUser(User user, int id) async {
    var dbclient = await db;
    await dbclient.update(
      'User',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    print("User Updated");
  }
}
