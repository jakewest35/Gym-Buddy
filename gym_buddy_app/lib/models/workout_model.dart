import 'exercise_model.dart';

class Workout {
  final DateTime timestamp;
  final List<Exercise> exercises;

  Workout({required this.timestamp, required this.exercises});
}
