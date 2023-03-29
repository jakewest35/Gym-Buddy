import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise_model.dart';

class WorkoutModel {
  final String date;
  final List<ExerciseModel> exercises;

  WorkoutModel({required this.date, required this.exercises});

  ///Convert a Firestore database query into a WorkoutModel object
  factory WorkoutModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    print(data);
    return WorkoutModel(date: data["date"], exercises: data["exercises"]);
  }
}
