import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/exercise_model.dart';

/// Manages creating workouts and exercises.
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
//      Exercise(name: "Barbell Bench", weight: "225", reps: "7", sets: "3"),
//      Exercise(name: "Tricep Extensions", weight: "65", reps: "3", sets: "10"),
//      Exercise(name: "Pec Fly", weight: "85", reps: "3", sets: "12"),
//    ];
class WorkoutUtility extends ChangeNotifier {
  List<Exercise> _currentWorkout = [];

  // get a list of workouts
  List<Exercise> getCurrentWorkout() {
    return _currentWorkout;
  }

  ///clear the current workout list
  void clearWorkout() {
    _currentWorkout.clear();
    notifyListeners();
  }

  /// add an exercise to a workout
  /// This builds the workout exercise by exercise
  void addExercise(
      String exerciseName, String weight, String reps, String sets) {
    _currentWorkout.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
  }
}
