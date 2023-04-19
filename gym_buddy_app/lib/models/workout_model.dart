import 'exercise_model.dart';

class WorkoutModel {
  final String date;
  final List<ExerciseModel> exercises;

  WorkoutModel({required this.date, required this.exercises});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'exercises': exercises,
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
        date: json['date'] ?? "", exercises: json['exercises'] ?? "");
  }
}
