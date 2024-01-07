import 'package:cloud_firestore/cloud_firestore.dart';

// reutrn a formatted date as a string
String formatDate(Timestamp timestamp) {
  // Timestamp is the object we recieve from firebase
  // so to display it, we need to convert it to a string
  DateTime dateTime = timestamp.toDate();

  //get year
  String year = dateTime.year.toString();

  //get month
  String month = dateTime.month.toString();

  //get day
  String day = dateTime.day.toString();

  return "$month/$day/$year";
}
