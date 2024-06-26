import 'dart:convert';
import 'dart:developer';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/exercise_model.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/workout_utility.dart';
import '../widgets/exercise_tile.dart';
import '../widgets/exapndable_fab.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  DatabaseUtility db = DatabaseUtility();
  List<ExerciseModel> exercises = [];
  String sets = '0', reps = '0', weight = '0';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPreferences(); // ensure preferences are initialized before widget tree is built
  }

//! STATE MANAGMENT FUNCTIONS

  /// initialize shared_preferences and set the state if it exists.
  void _initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getString("state");
    if (kDebugMode) log("jsonList: $jsonList");

    /// if a previous state exists, parse it and set
    /// it as the current exercise list
    if (jsonList != null) {
      if (kDebugMode) log("$jsonList");
      List<dynamic> jsonParsed = jsonDecode(jsonList);
      setState(() {
        exercises = jsonParsed
            .map((exercise) => ExerciseModel.fromJson(exercise))
            .toList();
        // set the list of exercises equal to the parsed list from the previous state
        Provider.of<WorkoutUtility>(context, listen: false)
            .setCurrentWorkout(exercises);
      });
    } else if (kDebugMode) {
      log("_initPreferences: No previous state.");
    }
  }

  /// Reset the shared_preferences state. Used if the user wants
  /// to reset or clear their workout
  void resetState() {
    setState(() {
      prefs.clear();
      exercises.clear();
    });
    if (kDebugMode) log("set workout state = null");
  }

  //! EXERCISE SPECIFIC FUNCTIONS

  ///Alert dialog to display the UI to add an exercise to the current workout
  void addExerciseAlertDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              titleTextStyle: Theme.of(context).textTheme.displayMedium,
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
                    decoration:
                        InputDecoration(hintText: "Weight used in lbs."),
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
                    saveExercise(nameController.text, weightController.text,
                        setsController.text, repsController.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            ));
  }

  ///Add the exercise to the current local workout and save the state
  void saveExercise(String name, String weight, String sets, String reps) {
    Provider.of<WorkoutUtility>(context, listen: false)
        .addExercise(name, weight, reps, sets);

    /// update the local exercise list after setting the private exercise
    /// list and updating shared_preferences state. This is useful when a user
    /// is trying to add exercises when they first load the page and no previous state exists.
    setState(() {
      exercises =
          Provider.of<WorkoutUtility>(context, listen: false).getCurrentWorkout;
    });
  }

  ///Update an existing exercise. This will overwrite the previous values in the exercise
  void updateExercise(
      int index, String name, String weight, String sets, String reps) {
    Provider.of<WorkoutUtility>(context, listen: false)
        .updateExercise(index, name, weight, sets, reps);
  }

  ///checkbox was tapped, toggle exercise completed status
  void onCheckboxChanged(String exerciseName) {
    Provider.of<WorkoutUtility>(context, listen: false)
        .checkOffExercise(exerciseName);
  }

  ///Alert dialog to display the UI to edit an existing exercise
  void editExerciseDialog(BuildContext context, int index) {
    ExerciseModel exercise = Provider.of<WorkoutUtility>(context, listen: false)
        .getCurrentWorkout[index];
    TextEditingController nameController =
        TextEditingController(text: exercise.name);
    TextEditingController weightController =
        TextEditingController(text: exercise.weight);
    TextEditingController setsController =
        TextEditingController(text: exercise.sets);
    TextEditingController repsController =
        TextEditingController(text: exercise.reps);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titleTextStyle: Theme.of(context).textTheme.displaySmall,
        title: Text("Edit Exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                nameController.text = value;
              },
              controller: nameController,
              decoration: InputDecoration(hintText: "Exercise Name"),
            ),
            TextFormField(
              onChanged: ((value) {
                weightController.text = value;
              }),
              controller: weightController,
              decoration: InputDecoration(hintText: "Weight"),
            ),
            TextFormField(
              onChanged: (value) {
                setsController.text = value;
              },
              controller: setsController,
              decoration: InputDecoration(hintText: "Sets"),
            ),
            TextFormField(
              onChanged: (value) {
                repsController.text = value;
              },
              controller: repsController,
              decoration: InputDecoration(hintText: "Reps"),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              updateExercise(index, nameController.text, weightController.text,
                  setsController.text, repsController.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutUtility>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Current workout",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            // add exercise button
            ActionButton(
              onPressed: () {
                setState(() {
                  addExerciseAlertDialog(context);
                });
              },
              icon: const Icon(Icons.add),
              toolTip: "Add an exercise",
            ),
            // post workout button
            ActionButton(
              onPressed: () {
                List<ExerciseModel> workout = value.getCurrentWorkout;
                if (workout.isNotEmpty) {
                  db.postWorkout(workout);
                  prefs.remove("state");
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
                  value.clearWorkout();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Can't save an empty workout. Try adding an exercise before saving."),
                      actions: [
                        MaterialButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
              toolTip: "Save the workout to the database",
            ),
            // clear workout list button
            ActionButton(
                icon: Icon(Icons.not_interested),
                onPressed: () {
                  resetState();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Cleared workout log!"),
                      actions: [
                        MaterialButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                toolTip: "Clear the current workout"),
          ],
        ),
        body: Column(
          children: [
            // render all exercises
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            // edit option
                            SlidableAction(
                              onPressed: (context) =>
                                  editExerciseDialog(context, index),
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            // delete option
                            SlidableAction(
                              onPressed: (context) {
                                Provider.of<WorkoutUtility>(context,
                                        listen: false)
                                    .removeExercise(exercises[index].name);
                                if (Provider.of<WorkoutUtility>(context,
                                            listen: false)
                                        .getCurrentWorkout
                                        .length ==
                                    0) {
                                  prefs.remove("state");
                                }
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.save,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ExerciseTile(
                            exerciseName: exercises[index].name,
                            weight: exercises[index].weight,
                            reps: exercises[index].reps,
                            sets: exercises[index].sets,
                            isCompleted: exercises[index].isCompleted,
                            onCheckboxChanged: (val) {
                              onCheckboxChanged(exercises[index].name);
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
