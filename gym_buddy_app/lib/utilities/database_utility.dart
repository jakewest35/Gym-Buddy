import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/diet_model.dart';
import '../models/exercise_model.dart';
import '../models/journal_model.dart';
import '../models/workout_model.dart';

class DatabaseUtility extends ChangeNotifier {
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
      print("No workout data for $id");
      return null;
    }
  }

  ///Structures and posts the data to the database
  void postWorkout(List<ExerciseModel> workoutList) async {
    ///ensuring that a user cannot submit an empty workout
    if (workoutList.isEmpty) {
      print("Cannot submit an empty workout list");
      return;
    }
    //construct the data
    String timestamp =
        "${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}";
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
      (value) => print("Successfully posted workout to database."),
      onError: (e) {
        print("Error posting to the database. Error: $e");
      },
    );
    notifyListeners();
  }

  ///####### JOURNAL FUNCTIONS #######
  //get a single journal entry
  Future<JournalModel?> getJournal(String id) async {
    try {
      JournalModel journal = JournalModel(date: id, entry: "", rating: "");
      final journalRef =
          FirebaseFirestore.instance.collection("journals").doc(id);
      await journalRef.get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        JournalModel tmp = JournalModel(
            date: id, entry: data["entry"], rating: data["rating"]);
        journal = tmp;
      });
      return journal;
    } catch (e) {
      print("No journal data for $id");
      //return an empty object so the widget can still be rendered
      return null;
    }
  }

  //structures and posts the data to the database
  void postJournalEntry(String entry, String rating) async {
    //ensure that the journal is populated before posting to db
    if (entry.isEmpty) {
      print("cannot submit an empty journal");
      return;
    }
    //post the data
    String timestamp =
        "${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}";
    CollectionReference journals =
        FirebaseFirestore.instance.collection("journals");
    await journals.doc(timestamp).set({
      "entry": entry,
      "rating": rating,
    }).then((value) => print("Successfully posted journal entry to database."),
        onError: (e) {
      print("Error posting the journal to the database. Error: $e");
    });
  }

  ///####### DIET FUNCTIONS #######
  ///Structures and posts the diet data to the database
  void postDiet(List<DietModel> entriesList) async {
    //ensure that the diet entry is populated before posting to the database
    if (entriesList.isEmpty) {
      print("Cannot submit an empty meal list");
      return;
    }
    //Format the data
    String timestamp =
        "${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}";

    var dietList = [];
    int index = 0;
    for (var item in entriesList) {
      dietList.insert(index, item.toJson());
      index++;
    }

    //Post the data
    CollectionReference diets = FirebaseFirestore.instance.collection("diet");
    await diets.doc(timestamp).set({"dietEntries": dietList}).then(
        (value) => print("Successfully posted the meal list to database"),
        onError: (e) {
      print("Error posting meal list to the database. Error: $e");
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
      print("Found diet ${mealList.length} entries.");
      return mealList;
    } catch (e) {
      print("No diet data for $id. Error: $e");
      return null;
    }
  }
}
