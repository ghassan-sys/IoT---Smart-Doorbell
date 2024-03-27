
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

String doubleToTimeString(double time) { // casting from double to string
  int hours = time.truncate();
  int minutes = ((time - hours) * 60).round();
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

double timeStringToDouble(String time) { // casting from string to double
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  double minutes = int.parse(parts[1]) / 60;
  return hours + minutes;
}

String extractTime(String datetime) { // getting the hours from given string
  // Parse the datetime string to a DateTime object
  DateTime parsedDateTime = DateTime.parse(datetime);
  DateTime adjustedDateTime = parsedDateTime.add(Duration(hours: 2));

  // Format the DateTime object to a time string (HH:mm)
  String formattedTime = DateFormat('HH:mm').format(adjustedDateTime);

  return formattedTime;
}

Future<String> getTime() async { // get the current time using http
  // make the request
  String urlString = "http://worldtimeapi.org/api/timezone/Asia/Jerusalem";
  Uri uri = Uri.parse(urlString);
  Response response = await get(uri);
  Map data = jsonDecode(response.body);

  // get properties from json
  String datetime = data['datetime'];
  // print(datetime);
  return datetime;
}

Future<int> getDayOfTheYear() async { // getting the day of the year 
  // make the request
  String urlString = "http://worldtimeapi.org/api/timezone/Asia/Jerusalem";
  Uri uri = Uri.parse(urlString);
  Response response = await get(uri);
  Map data = jsonDecode(response.body);

  // get properties from json
  int dayOfYear = data['day_of_year'];

  return dayOfYear;
}

Future<bool> isTimeGreaterThanCurrent(String specificTime) async { // comparing between given time and current time
  String currentDatetime=await getTime();
  String currentTimeString = extractTime(currentDatetime);
  double specificTimeDouble = timeStringToDouble(specificTime);
  double currentTimeDouble = timeStringToDouble(currentTimeString);

  return specificTimeDouble > currentTimeDouble;
}
bool checkTimeInputValid(String start , String end)  {

  double startTimeDouble = timeStringToDouble(start);
  double endTimeDouble = timeStringToDouble(end);

  return endTimeDouble > startTimeDouble;
}