import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String name;
  final String weight;
  final String reps;
  final String sets;

  Exercise(
      {required this.name,
      required this.weight,
      required this.reps,
      required this.sets});

  factory Exercise.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;
    return Exercise(
        name: data["name"],
        weight: data["weight"],
        reps: data["reps"],
        sets: data["sets"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "weight": weight,
      "reps": reps,
      "sets": sets,
    };
  }
}
