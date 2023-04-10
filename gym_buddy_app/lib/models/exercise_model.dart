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

  ExerciseModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot["name"],
        weight = snapshot["weight"],
        reps = snapshot["reps"],
        sets = snapshot["sets"],
        isCompleted = snapshot["isCompleted"];

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
