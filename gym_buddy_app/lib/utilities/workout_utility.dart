import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/exercise_model.dart';

/// Manages creating workouts and exercises locally.
///
/// WORKOUT DATA STRUCTURE
///
/// - Each workout is a list containing 1 or more exercises
/// - Each exercise contains:
///   - Exercise name
///   - weight used
///   - reps
///   - sets
///
/// An example workout would be:
//    List<Exercise> _currentWorkout = [
//      Exercise(name: "Barbell Bench", weight: "225", reps: "7", sets: "3", completed: false),
//      Exercise(name: "Tricep Extensions", weight: "65", reps: "3", sets: "10", completed: false),
//      Exercise(name: "Pec Fly", weight: "85", reps: "3", sets: "12", completed: false),
//    ];
class WorkoutUtility extends ChangeNotifier {
  List<ExerciseModel> _currentWorkout = [];

  // get a list of workouts
  List<ExerciseModel> get getCurrentWorkout => _currentWorkout;

  ///clear the current workout list
  void clearWorkout() {
    _currentWorkout.clear();
    notifyListeners();
  }

  void printCurrentWorkout() {
    if (_currentWorkout.isEmpty) {
      print("No exercises in list");
      return;
    }
    for (var item in _currentWorkout) {
      print(
          "${item.name} at ${item.weight}lbs. for ${item.sets} sets of ${item.reps} reps, completed: ${item.isCompleted}");
    }
  }

  ///mark the exercise as completed
  void checkOffExercise(String exerciseName) {
    //find the exercise
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      tmp.isCompleted = !tmp.isCompleted;
      print("Toggled completed status of $exerciseName to ${tmp.isCompleted}");
      notifyListeners();
    } catch (e) {
      print("couldn't find exercise to mark as completed");
    }
  }

  /// add an exercise to a workout
  /// This builds the workout exercise by exercise
  void addExercise(
      String exerciseName, String weight, String reps, String sets) {
    try {
      var tmp = ExerciseModel(
          name: exerciseName, weight: weight, reps: reps, sets: sets);
      _currentWorkout.add(tmp);
      print(
          "added exercise: $exerciseName at $weight lbs. for $sets sets of $reps reps.");
    } catch (e) {
      print("Couldn't add the exercise");
    }
    notifyListeners();
  }

  /// remove an exercise from the workout
  void removeExercise(String exerciseName) {
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      _currentWorkout.remove(tmp);
      print("Deleted $exerciseName");
      notifyListeners();
    } catch (e) {
      print("Error removing $exerciseName. $e");
    }
  }
}
