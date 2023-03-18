import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import '../models/journal_model.dart';
import '../models/workout_model.dart';

class DatabaseUtility extends ChangeNotifier {
  ///####### WORKOUT FUNCTIONS #######
  ///get all workouts from the database
  Future<List<WorkoutModel>> getAllWorkouts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("workouts").get();
    return snapshot.docs.map((e) => WorkoutModel.fromFirestore(e)).toList();
  }

  ///Get a single workout that matches a specified date
  Future<WorkoutModel> getWorkout(String timestamp) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("workouts")
        .where("timestamp", isEqualTo: timestamp)
        .get();
    return snapshot.docs.map((e) => WorkoutModel.fromFirestore(e)).single;
  }

  ///Structures and posts the data to the database
  void postWorkout(List<Exercise> workoutList) async {
    ///ensuring that a user cannot submit an empty workout
    if (workoutList.isEmpty) {
      print("Cannot submit an empty workout list");
      return;
    }

    //construct the data
    String timestamp = "${DateTime.now().month}-${DateTime.now().day}";
    var exercises = [];
    int index = 0;

    for (var item in workoutList) {
      var tmp = {};
      tmp["name"] = item.name;
      tmp["weight"] = item.weight;
      tmp["sets"] = item.sets;
      tmp["reps"] = item.reps;
      exercises.insert(index, tmp);
      index++;
    }
    print(exercises);

    //post the data
    CollectionReference workouts =
        FirebaseFirestore.instance.collection("workouts");
    await workouts.doc(timestamp).set({"exercises": exercises}).then(
      (value) => print("Successfully posted workout to database."),
      onError: (e) {
        print("Error posting to the database. Error: $e");
      },
    );

    workoutList.clear();
    print("reset workout");
  }

  ///####### JOURNAL FUNCTIONS #######
  ///get all previous journal entries
  Future<List<JournalModel>> getAllJournals() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("journals").get();
    return snapshot.docs.map((e) => JournalModel.fromFirestore(e)).toList();
  }

  //get a single journal entry
  Future<JournalModel> getJournal(String timestamp) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("journals")
        .where("date", isEqualTo: timestamp)
        .get();
    return snapshot.docs.map((e) => JournalModel.fromFirestore(e)).single;
  }

  //structures and posts the data to the database
  void postJournalEntry(String entry, String rating) async {
    //ensure that the journal is populated before posting to db
    if (entry.isEmpty) {
      print("cannot submit an empty journal");
      return;
    }

    //post the data
    String timestamp = "${DateTime.now().month}-${DateTime.now().day}";
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
  void postDiet(String entry) async {
    //ensure that the diet entry is populated before posting to the database
    if (entry.isEmpty) {
      print("Cannot submit an empty diet entry");
      return;
    }

    //post the data
    String timestamp = "${DateTime.now().month}-${DateTime.now().day}";
    CollectionReference diet = FirebaseFirestore.instance.collection("diet");
    await diet.doc(timestamp).set({
      "entry": entry,
    }).then((value) => print("Successfully posted diet entry to database."),
        onError: (e) {
      print("Error posting the diet entry to the database. Error: $e");
    });
  }
}
