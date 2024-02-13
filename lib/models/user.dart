// TODO Implement this library.
class User {
  var _username;
  var _password;
  var _fullname;
  var _dob;
  var _id;
  var _email;

  User(this._username, this._password, this._fullname, this._dob, this._email);

  User.map(dynamic obj) {
    _id = obj['id'];
    _username = obj['username'];
    _password = obj['password'];
    _fullname = obj['fullname'];
    _dob = obj['dob'];
    _email = obj['email'];
  }

  String get username => _username;
  String get password => _password;
  int get id => _id;
  String get fullname => _fullname!;
  String get dob => _dob;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["fullname"] = _fullname;
    map["dob"] = _dob;
    map["email"] = _email;
    return map;
  }
}

// TODO Implement this library.
class Task {
  int? _user_id;
  var _task;
  var _date;
  var _time;
  var _alarm;

  Task(this._user_id, this._task, this._date, this._time, this._alarm);

  Task.map(dynamic obj) {
    _user_id = obj['userid'];
    _task = obj['task'];
    _date = obj['date'];
    _time = obj['time'];
    _alarm = obj['alarm'];
  }

  int? get userid => _user_id;
  String get task => _task;
  String get date => _date;
  String get time => _time;
  String get alarm => _alarm;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userid"] = _user_id;
    map["task"] = _task;
    map["date"] = _date;
    map["time"] = _time;
    map["alarm"] = _alarm;
    return map;
  }
}
