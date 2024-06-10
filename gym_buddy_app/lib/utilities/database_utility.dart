import 'dart:core';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/diet_model.dart';
import '../models/exercise_model.dart';
import '../models/journal_model.dart';
import '../models/workout_model.dart';

class DatabaseUtility extends ChangeNotifier {
  // timestamp used when posting any data to the DB
  String timestamp =
      "${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}";

  ///####### WORKOUT FUNCTIONS #######
  ///get all workouts from the database
  Future<List<String>> getAllWorkoutDates() async {
    final workoutRef =
        await FirebaseFirestore.instance.collection("workouts").get();
    final workoutDates = workoutRef.docs.map((doc) => doc.id).toList();
    notifyListeners();
    return workoutDates;
  }

  ///Get a single workout that matches a specified date
  Future<WorkoutModel?> getWorkout(String id) async {
    try {
      WorkoutModel workout = WorkoutModel(date: id, exercises: []);
      final workoutRef =
          FirebaseFirestore.instance.collection("workouts").doc(id);
      await workoutRef.get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        for (var exercise in data["exercises"]) {
          ExerciseModel tmpExercise = ExerciseModel(
              name: exercise["name"],
              weight: exercise["weight"],
              reps: exercise["reps"],
              sets: exercise["sets"],
              isCompleted: exercise["isCompleted"]);
          workout.exercises.add(tmpExercise);
        }
      });
      return workout;
    } catch (e) {
      if (kDebugMode) log("No workout data for $id");
      return null;
    }
  }

  ///Structures and posts the data to the database
  void postWorkout(List<ExerciseModel> workoutList) async {
    ///ensuring that a user cannot submit an empty workout
    if (workoutList.isEmpty) {
      if (kDebugMode) ("Cannot submit an empty workout list");
      return;
    }
    //construct the data
    var exercises = [];
    int index = 0;

    for (var item in workoutList) {
      var tmp = {};
      tmp["name"] = item.name;
      tmp["weight"] = item.weight;
      tmp["sets"] = item.sets;
      tmp["reps"] = item.reps;
      tmp["isCompleted"] = item.isCompleted;
      exercises.insert(index, tmp);
      index++;
    }

    //post the data
    CollectionReference workouts =
        FirebaseFirestore.instance.collection("workouts");
    await workouts.doc(timestamp).set({"exercises": exercises}).then(
      (value) {
        if (kDebugMode) log("Successfully posted workout to database.");
      },
      onError: (e) {
        log("Error posting to the database. Error: $e");
      },
    );
    notifyListeners();
  }

  ///####### JOURNAL FUNCTIONS #######
  //get a single journal entry
  Future<JournalModel?> getJournal(String id) async {
    try {
      JournalModel journal =
          JournalModel(date: id, entry: "", rating: "", weight: "");
      final journalRef =
          FirebaseFirestore.instance.collection("journals").doc(id);
      await journalRef.get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        JournalModel tmp = JournalModel(
            date: id,
            entry: data["entry"],
            rating: data["rating"],
            // do null check for weight since it was added after initial journal data was entered
            weight: data["weight"] != null ? data["weight"] : "");
        journal = tmp;
      });
      return journal;
    } catch (e) {
      if (kDebugMode) log("No journal data for $id");
      //return an empty object so the widget can still be rendered
      return null;
    }
  }

  //structures and posts the data to the database
  void postJournalEntry(String entry, String rating, String weight) async {
    //ensure that the journal is populated before posting to db
    if (entry.isEmpty) {
      if (kDebugMode) log("cannot submit an empty journal");
      return;
    }
    //post the data
    CollectionReference journals =
        FirebaseFirestore.instance.collection("journals");
    await journals
        .doc(timestamp)
        .set({"entry": entry, "rating": rating, "weight": weight}).then(
            (value) {
      if (kDebugMode) log("Successfully posted journal entry to database.");
    }, onError: (e) {
      if (kDebugMode)
        log("Error posting the journal to the database. Error: $e");
    });
  }

  ///####### DIET FUNCTIONS #######
  ///Structures and posts the diet data to the database
  void postDiet(List<DietModel> entriesList) async {
    //ensure that the diet entry is populated before posting to the database
    if (entriesList.isEmpty) {
      if (kDebugMode) log("Cannot submit an empty meal list");
      return;
    }
    //Format the data

    var dietList = [];
    int index = 0;
    for (var item in entriesList) {
      dietList.insert(index, item.toJson());
      index++;
    }

    //Post the data
    CollectionReference diets = FirebaseFirestore.instance.collection("diet");
    await diets.doc(timestamp).set({"dietEntries": dietList}).then((value) {
      if (kDebugMode) log("Successfully posted the meal list to database");
    }, onError: (e) {
      if (kDebugMode) log("Error posting meal list to the database. Error: $e");
    });
    notifyListeners();
  }

  ///Get a single diet entry
  Future<List<DietModel>?> getDietEntry(String id) async {
    try {
      List<DietModel> mealList = [];
      final dietRef = FirebaseFirestore.instance.collection("diet").doc(id);
      await dietRef.get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        for (var meal in data["dietEntries"]) {
          DietModel tmp = DietModel(
              mealName: meal["mealName"],
              calories: meal["calories"],
              fats: meal["fats"],
              carbs: meal["carbs"],
              protein: meal["protein"]);
          mealList.add(tmp);
        }
      });
      if (kDebugMode) log("Found diet ${mealList.length} entries.");
      return mealList;
    } catch (e) {
      if (kDebugMode) log("No diet data for $id. Error: $e");
      return null;
    }
  }
}
