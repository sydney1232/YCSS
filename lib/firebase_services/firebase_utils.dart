import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getLocalDateAndTime() {
  //Convert Timestamp to date string
  Timestamp t = Timestamp.now();
  DateTime date = t.toDate();
  String dateString = date.toString();

  // Parse the timestamp
  DateTime timestamp = DateTime.parse(dateString);

  // Convert to local time in the Philippines
  DateTime localTime = timestamp.toLocal();

  // Format the local time
  String formattedTime =
      DateFormat("MMMM d, yyyy, hh:mm a", 'en_US').format(localTime);

  return formattedTime;
}

String convertToLocalDateAndTime(Timestamp tstamp) {
  //Convert Timestamp to date string

  Timestamp t = tstamp;
  DateTime date = t.toDate();
  String dateString = date.toString();

  // Parse the timestamp
  DateTime timestamp = DateTime.parse(dateString);

  // Convert to local time in the Philippines
  DateTime localTime = timestamp.toLocal();

  // Format the local time
  String formattedTime = DateFormat("MM/d/hh:mm a", 'en_US').format(localTime);

  return formattedTime;
}
