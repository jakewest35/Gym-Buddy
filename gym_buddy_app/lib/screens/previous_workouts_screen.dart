import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';

import '../widgets/previous_exercise_tile.dart';

class PreviousWorkoutsPage extends StatefulWidget {
  const PreviousWorkoutsPage({
    super.key,
  });

  @override
  State<PreviousWorkoutsPage> createState() => _PreviousWorkoutsPageState();
}

class _PreviousWorkoutsPageState extends State<PreviousWorkoutsPage> {
  DatabaseUtility db = DatabaseUtility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Previous workouts"),
        ),
        body: FutureBuilder(
          future: db.getAllWorkoutDates(),
          builder: (context, snapshot) {
            //if data is done loading
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final workoutDates = snapshot.data!;
                return ListView.builder(
                  itemCount: workoutDates.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        workoutDates[index],
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviousWorkoutDetails(
                                  date: workoutDates[index]),
                            ));
                      },
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text("There's no data to show."),
                );
              }
            }
            // if there was an error
            if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Something went wrong :("),
              );
            }
            //still loading, show progress inidcator
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

/// Page to show all previous exercises and their corresponding information
class PreviousWorkoutDetails extends StatelessWidget {
  PreviousWorkoutDetails({super.key, required this.date});
  final String date;
  final DatabaseUtility _db = DatabaseUtility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details for $date workout"),
        ),
        body: FutureBuilder(
          future: _db.getWorkout(date),
          builder: (context, snapshot) {
            //if data is done loading
            if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Something went wrong :("),
              );
            }
            // if still waiting for the data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // got the data
            else {
              if (snapshot.hasData) {
                final workouts = snapshot.data!;
                return ListView.builder(
                  itemCount: workouts.exercises.length,
                  itemBuilder: (context, index) => PreviousExerciseTile(
                    exerciseName: workouts.exercises[index].name,
                    weight: workouts.exercises[index].weight,
                    reps: workouts.exercises[index].reps,
                    sets: workouts.exercises[index].sets,
                    isCompleted: workouts.exercises[index].isCompleted,
                  ),
                );
              } else {
                return Center(
                  child: Text("There's no data to show."),
                );
              }
            }
          },
        ));
  }
}
