import 'package:cloud_firestore/cloud_firestore.dart';

class DietModel {
  final String date;
  final String entry;

  DietModel({required this.date, required this.entry});

  factory DietModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return DietModel(
      date: data["date"],
      entry: data["entry"],
    );
  }
}
