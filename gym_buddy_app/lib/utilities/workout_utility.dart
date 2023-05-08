import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gym_buddy_app/models/exercise_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // set the list of workouts
  void setCurrentWorkout(List<ExerciseModel> workout) {
    _currentWorkout = workout;
    _updateState();
    notifyListeners();
  }

  ///clear the current workout list
  void clearWorkout() {
    _currentWorkout.clear();
    _updateState();
    notifyListeners();
  }

  void printCurrentWorkout() {
    if (_currentWorkout.isEmpty) {
      print("WorkoutUtility::printCurrentWorkout: No exercises in list");
      return;
    }
    for (var item in _currentWorkout) {
      print(
          "${item.name} at ${item.weight}lbs. for ${item.sets} sets of ${item.reps} reps, completed: ${item.isCompleted}");
    }
  }

  ///mark the exercise as completed
  void checkOffExercise(String exerciseName) {
    if (kDebugMode)
      print("WorkoutUtility::checkOffExercise: printing current workout list");
    printCurrentWorkout();

    //find the exercise
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      tmp.isCompleted = !tmp.isCompleted;
      if (kDebugMode)
        print(
            "WorkoutUtility::checkOffExercise: Toggled completed status of $exerciseName to ${tmp.isCompleted}");
      _updateState();
      notifyListeners();
    } catch (e) {
      if (kDebugMode)
        print(
            "WorkoutUtility::checkOffExercise: couldn't find exercise to mark as completed");
    }
  }

  /// add an exercise to a workout
  /// This builds the workout exercise by exercise
  void addExercise(
      String exerciseName, String weight, String reps, String sets) {
    try {
      //create the new exercise object
      var tmp = ExerciseModel(
          name: exerciseName, weight: weight, reps: reps, sets: sets);

      // add to the workout list before updating state
      _currentWorkout.add(tmp);

      // update the shared_preferences state
      _updateState();
      if (kDebugMode)
        print(
            "WorkoutUtility::addExercise: added exercise: $exerciseName at $weight lbs. for $sets sets of $reps reps.");
    } catch (e) {
      if (kDebugMode)
        print("WorkoutUtility::addExercise, Couldn't add the exercise");
    }
  }

  /// remove an exercise from the workout
  void removeExercise(String exerciseName) {
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      _currentWorkout.remove(tmp);
      if (kDebugMode) print("Deleted $exerciseName");
      _updateState();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error removing $exerciseName. $e");
    }
  }

  /// STATE MANAGMENT FUNCTIONS

  /// overwrites the current snapshot of the state and saves
  /// the current snapshot
  void _updateState() async {
    final prefs = await SharedPreferences.getInstance();
    // JsonEncode the current workout if it exists
    if (_currentWorkout.isNotEmpty) {
      if (kDebugMode) print("In WorkoutUtility::_updateState:");
      printCurrentWorkout();
      final jsonList =
          jsonEncode(_currentWorkout.map((e) => e.toJson()).toList());
      if (kDebugMode)
        print("WorkoutUtility::_updateState(): jsonList = $jsonList");
      // update the state
      await prefs.setString("state", jsonList).then((value) {
        if (kDebugMode) print("updated state.");
      });
    } else {
      if (kDebugMode)
        print("WorkoutUtility::_updateState(): state is already empty");
    }
    notifyListeners();
  }
}
