import 'dart:ui';

class ColorConstants {
  static Color mainColor = Color(0xFFFF9F74);
  static Color secondColor = Color(0xFFFF95B7);
  static Color thirdColor = Color(0xFFFFC853);
}

List<Color> colors = [
  ColorConstants.mainColor,
  ColorConstants.secondColor,
  ColorConstants.thirdColor,
];
List<Color> taskColor = [
  Color(0xFFFFC5AB),
  Color(0xFFFFDEE8),
  Color(0xFFFFE9B9),
];

List<DateTime> taskDates = [
  DateTime.now(), // Today's date
  DateTime.now().subtract(Duration(days: 1)), // Yesterday's date
  DateTime.now().add(Duration(days: 1)), // Tomorrow's date
  DateTime.now().subtract(Duration(days: 1)), // Yesterday's date
  DateTime.now().add(Duration(days: 1)),
];
