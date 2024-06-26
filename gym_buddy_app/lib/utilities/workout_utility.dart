import 'dart:convert';
import 'dart:developer';

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
  }

  ///clear the current workout list
  void clearWorkout() {
    _currentWorkout.clear();
    _updateState();
  }

  void printCurrentWorkout() {
    if (_currentWorkout.isEmpty) {
      log("WorkoutUtility::printCurrentWorkout: No exercises in list");
      return;
    }
    for (var item in _currentWorkout) {
      log("${item.name} at ${item.weight}lbs. for ${item.sets} sets of ${item.reps} reps, completed: ${item.isCompleted}");
    }
  }

  ///mark the exercise as completed
  void checkOffExercise(String exerciseName) {
    if (kDebugMode)
      log("WorkoutUtility::checkOffExercise: printing current workout list");
    printCurrentWorkout();

    //find the exercise
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      tmp.isCompleted = !tmp.isCompleted;
      if (kDebugMode)
        log("WorkoutUtility::checkOffExercise: Toggled completed status of $exerciseName to ${tmp.isCompleted}");
      _updateState();
    } catch (e) {
      if (kDebugMode)
        log("WorkoutUtility::checkOffExercise: couldn't find exercise to mark as completed");
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
        log("WorkoutUtility::addExercise: added exercise: $exerciseName at $weight lbs. for $sets sets of $reps reps.");
    } catch (e) {
      if (kDebugMode)
        log("WorkoutUtility::addExercise, Couldn't add the exercise");
    }
  }

  /// remove an exercise from the workout
  void removeExercise(String exerciseName) {
    try {
      ExerciseModel tmp = _currentWorkout
          .firstWhere((exercise) => exercise.name == exerciseName);
      _currentWorkout.remove(tmp);
      if (kDebugMode) log("Deleted $exerciseName");
      _updateState();
    } catch (e) {
      if (kDebugMode) log("Error removing $exerciseName. $e");
    }
  }

  /// update an exercise with new values. No need to check if entry exists because this
  /// function can only be called if the entry exists in the first place.
  void updateExercise(
      int index, String exerciseName, String weight, String sets, String reps) {
    try {
      ExerciseModel exercise = _currentWorkout[index];
      exercise.name = exerciseName;
      exercise.weight = weight;
      exercise.sets = sets;
      exercise.reps = reps;
      _updateState();
    } catch (e) {
      log("Didn't find ${exerciseName}");
    }
  }

  /// STATE MANAGMENT FUNCTIONS

  /// overwrites the current snapshot of the state and saves
  /// the current snapshot
  void _updateState() async {
    final prefs = await SharedPreferences.getInstance();
    // JsonEncode the current workout if it exists
    if (_currentWorkout.isNotEmpty) {
      if (kDebugMode) log("In WorkoutUtility::_updateState:");
      printCurrentWorkout();
      final jsonList =
          jsonEncode(_currentWorkout.map((e) => e.toJson()).toList());
      if (kDebugMode)
        log("WorkoutUtility::_updateState(): jsonList = $jsonList");
      // update the state
      await prefs.setString("state", jsonList).then((value) {
        if (kDebugMode) log("updated state.");
      });
    } else {
      if (kDebugMode)
        log("WorkoutUtility::_updateState(): state is already empty");
    }
    notifyListeners();
  }
}
