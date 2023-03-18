import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';
import 'package:gym_buddy_app/utilities/workout_utility.dart';
import 'package:provider/provider.dart';

import '../models/exercise_model.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WorkoutInformation(),
        ChangeNotifierProvider(
          create: (context) => WorkoutUtility(),
          child: WorkoutScreenButtons(),
        ),
      ],
    );
  }
}

class WorkoutInformation extends StatefulWidget {
  const WorkoutInformation({super.key});

  @override
  State<WorkoutInformation> createState() => _WorkoutInformationState();
}

class _WorkoutInformationState extends State<WorkoutInformation> {
  @override
  Widget build(BuildContext context) {
    //get all previous workouts from Firestore collection
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("workouts");
    docRef.get().then((querySnapshot) {
      print("Successfully completed retrieving workouts!");
      for (var docSnapshot in querySnapshot.docs) {
        docSnapshot.data().forEach((key, value) {
          for (var exercise in value) {
            print(
                "${docSnapshot.id} => ${exercise["name"]} for ${exercise["sets"]} sets of ${exercise["reps"]} reps at ${exercise["weight"]} lbs.");
          }
        });
      }
    });

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("workouts").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong."),
            );
          }
          return SizedBox(
            height: 3,
            child: ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Text("Title:"),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    ]);
  }
}

class WorkoutScreenButtons extends StatefulWidget {
  const WorkoutScreenButtons({super.key});

  @override
  State<WorkoutScreenButtons> createState() => _WorkoutScreenButtonsState();
}

class _WorkoutScreenButtonsState extends State<WorkoutScreenButtons> {
  String sets = '0', reps = '0', weight = '0';
  WorkoutUtility _workoutUtility = WorkoutUtility();
  DatabaseUtility _databaseUtility = DatabaseUtility();

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

  ///Add the exercise to the current local workout
  void save(String name, String weight, String sets, String reps) {
    _workoutUtility.addExercise(name, weight, reps, sets);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutUtility>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: addExercise,
              child: Text("Add an exercise to current workout")),
          ElevatedButton(
            onPressed: () {
              _databaseUtility.postWorkout(_workoutUtility.getCurrentWorkout());
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Workout saved!"),
                  actions: [
                    MaterialButton(
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              );
            },
            child: Text("Finish the workout"),
          ),

          //!DELETE THIS BUTTON LATER
          ElevatedButton(
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
            child: Text("Print the workout"),
          ),
        ],
      ),
    );
  }
}
