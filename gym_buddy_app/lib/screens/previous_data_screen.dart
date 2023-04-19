import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';

import '../widgets/previous_exercise_tile.dart';

class PreviousDataPage extends StatefulWidget {
  final String date;

  const PreviousDataPage({
    super.key,
    required this.date,
  });

  @override
  State<PreviousDataPage> createState() => _PreviousDataPageState();
}

class _PreviousDataPageState extends State<PreviousDataPage> {
  DatabaseUtility _db = DatabaseUtility();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data for ${widget.date}"),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _db.getWorkout(widget.date),
          _db.getDietEntry(widget.date),
          _db.getJournal(widget.date),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<dynamic> results = snapshot.data!;
              final workouts = results[0];
              final diet = results[1];
              final journal = results[2];
              return Column(
                children: [
                  // Diet entry
                  SafeArea(
                    child: ListTile(
                      title: Text(
                        "Diet Entry:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${diet.entry}"),
                    ),
                  ),
                  // Journal entry
                  SafeArea(
                    child: ListTile(
                      title: Text("Journal Entry:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                          Text("${journal.entry} \nRating: ${journal.rating}"),
                    ),
                  ),
                  // Exercise ListView
                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        itemCount: workouts.exercises.length,
                        itemBuilder: (context, index) => PreviousExerciseTile(
                            exerciseName: workouts.exercises[index].name,
                            weight: workouts.exercises[index].weight,
                            reps: workouts.exercises[index].reps,
                            sets: workouts.exercises[index].sets,
                            isCompleted: workouts.exercises[index].isCompleted),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text("Theres no data for the selected day.");
            }
          }
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text("Something went wrong :("),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
