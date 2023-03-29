import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/exercise_model.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';
import 'package:gym_buddy_app/widgets/exercise_tile.dart';
import 'package:provider/provider.dart';

import '../utilities/workout_utility.dart';
import '../widgets/workout_exapndable_fab.dart';

class WorkoutScreenHandler extends StatelessWidget {
  const WorkoutScreenHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutUtility(),
      child: WorkoutScreen(),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  DatabaseUtility db = DatabaseUtility();
  String sets = '0', reps = '0', weight = '0';

  ///Alert dialog to display the UI to add an exercise to the current workout
  void addExerciseAlertDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
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
                    save(nameController.text, weightController.text,
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
            )));
  }

  ///Add the exercise to the current local workout
  void save(String name, String weight, String sets, String reps) {
    Provider.of<WorkoutUtility>(context, listen: false)
        .addExercise(name, weight, reps, sets);
  }

  ///checkbox was tapped, toggle exercise completed status
  void onCheckboxChanged(String exerciseName) {
    print("new_workout::onCheckboxChanged searching for $exerciseName");
    Provider.of<WorkoutUtility>(context, listen: false)
        .checkOffExercise(exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutUtility>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text("Current workout"),
          backgroundColor: Theme.of(context).focusColor,
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
                onPressed: () => value.printCurrentWorkout(),
                icon: Icon(Icons.print)),
            ActionButton(
              onPressed: () => addExerciseAlertDialog(context),
              icon: const Icon(Icons.add),
            ),
            ActionButton(
              onPressed: () {
                List<ExerciseModel> workout = value.getCurrentWorkout;
                if (workout.isNotEmpty) {
                  db.postWorkout(workout);
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
                      title: Text("Can't submit an empty workout"),
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
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: value.getCurrentWorkout.length,
                itemBuilder: (context, index) {
                  ExerciseModel eachExercise = value.getCurrentWorkout[index];
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(eachExercise.name),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          Provider.of<WorkoutUtility>(context, listen: false)
                              .removeExercise(eachExercise.name);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Deleted ${eachExercise.name}!",
                              ),
                            ),
                          );
                        },
                        child: ExerciseTile(
                            exerciseName: eachExercise.name,
                            weight: eachExercise.weight,
                            reps: eachExercise.reps,
                            sets: eachExercise.sets,
                            isCompleted: eachExercise.isCompleted,
                            onCheckboxChanged: (val) {
                              onCheckboxChanged(eachExercise.name);
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
