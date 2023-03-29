import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  final String name;
  final String weight;
  final String reps;
  final String sets;
  bool isCompleted;

  ExerciseModel(
      {required this.name,
      required this.weight,
      required this.reps,
      required this.sets,
      this.isCompleted = false});

  factory ExerciseModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;
    return ExerciseModel(
        name: data["name"],
        weight: data["weight"],
        reps: data["reps"],
        sets: data["sets"],
        isCompleted: data["isCompleted"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "weight": weight,
      "reps": reps,
      "sets": sets,
      "isCompleted": isCompleted,
    };
  }
}
