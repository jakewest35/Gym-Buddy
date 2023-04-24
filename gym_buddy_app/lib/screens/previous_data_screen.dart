import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';
import 'package:gym_buddy_app/widgets/meal_tile.dart';

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
  //Text Styleing constants
  final fontSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data for ${widget.date}"),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _db.getJournal(widget.date),
          _db.getDietEntry(widget.date),
          _db.getWorkout(widget.date),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<dynamic> results = snapshot.data!;
              final journalLog = results[0];
              final dietLog = results[1];
              final workoutsLog = results[2];
              return Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  // Journal entry
                  SafeArea(
                    child: journalLog != null
                        ? Column(
                            children: [
                              Text(
                                "Journal Entry",
                                style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${journalLog.entry}",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          )
                        : Text("No journal data for today."),
                  ),
                  // Diet entry
                  Text(
                    "Meal List:",
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold),
                  ),
                  SafeArea(
                    child: dietLog != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: dietLog.length,
                            itemBuilder: (context, index) => MealTile(
                              mealName: dietLog[index].mealName,
                              calories: dietLog[index].calories,
                              fats: dietLog[index].fats,
                              carbs: dietLog[index].carbs,
                              protein: dietLog[index].protein,
                            ),
                          )
                        : Text("No diet entry data for today."),
                  ),
                  // Exercise ListView
                  Text(
                    "Workout Log",
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold),
                  ),
                  SafeArea(
                    child: Card(
                      child: workoutsLog != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: workoutsLog.exercises.length,
                              itemBuilder: (context, index) =>
                                  PreviousExerciseTile(
                                      exerciseName:
                                          workoutsLog.exercises[index].name,
                                      weight:
                                          workoutsLog.exercises[index].weight,
                                      reps: workoutsLog.exercises[index].reps,
                                      sets: workoutsLog.exercises[index].sets,
                                      isCompleted: workoutsLog
                                          .exercises[index].isCompleted),
                            )
                          : Center(
                              child:
                                  Text("There is no workout data for today."),
                            ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("Theres no data for the selected day."),
              );
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
