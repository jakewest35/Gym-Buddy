import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  final String date;
  final String entry;
  final String rating;

  JournalModel({required this.date, required this.entry, required this.rating});

  factory JournalModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return JournalModel(
      date: data["date"],
      entry: data["entry"],
      rating: data["rating"],
    );
  }
}
