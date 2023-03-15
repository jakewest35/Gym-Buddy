import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/workout_utility.dart';

import '../models/exercise_model.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WorkoutScreen(),
        ],
      ),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String sets = '0', reps = '0', weight = '0';
  WorkoutUtility _workoutUtility = WorkoutUtility();

  ///Alert dialog to display the UI to add an exercise to the current workout
  void addExercise() {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text("Add an exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: "Exercise name"),
                  ),
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(hintText: "Weight used"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextFormField(
                    controller: setsController,
                    decoration: InputDecoration(hintText: "Number of sets"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  ),
                  TextFormField(
                    controller: repsController,
                    decoration: InputDecoration(hintText: "Number of reps"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    save(nameController.text, weightController.text,
                        setsController.text, repsController.text);
                  },
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                ),
              ],
            )));
  }

  ///Add the exercise to the current workout
  void save(String name, String weight, String sets, String reps) {
    _workoutUtility.addExercise(name, weight, reps, sets);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  ///Structures and posts the data to the databser
  void postWorkout(List<Exercise> workoutList) async {
    String timestamp = "${DateTime.now().month}-${DateTime.now().day}";
    print("User finished their workout for $timestamp. They did:");
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: addExercise,
            child: Text("Add an exercise to the workout")),
        ElevatedButton(
            onPressed: () {
              postWorkout(_workoutUtility.getCurrentWorkout());
            },
            child: Text("Finish the workout")),
        ElevatedButton(
            //!DELETE THIS BUTTON LATER
            onPressed: () {
              List<Exercise> workout = _workoutUtility.getCurrentWorkout();
              if (workout.isNotEmpty) {
                for (var item in workout) {
                  print(
                      "${item.name} at ${item.weight} lbs for ${item.sets}x${item.reps}");
                }
              } else {
                print("No exercises added yet");
              }
            },
            child: Text("Print the workout")),
      ],
    );
  }
}
