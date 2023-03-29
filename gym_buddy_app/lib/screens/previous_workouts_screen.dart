import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/workout_model.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';

class PreviousWorkoutsPage extends StatefulWidget {
  const PreviousWorkoutsPage({
    super.key,
  });

  @override
  State<PreviousWorkoutsPage> createState() => _PreviousWorkoutsPageState();
}

class _PreviousWorkoutsPageState extends State<PreviousWorkoutsPage> {
  late Future<List<WorkoutModel>> workouts;
  DatabaseUtility db = DatabaseUtility();

  @override
  void initState() {
    super.initState();
    workouts = db.getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Previous workouts"),
        ),
        body: Placeholder());
  }
}
