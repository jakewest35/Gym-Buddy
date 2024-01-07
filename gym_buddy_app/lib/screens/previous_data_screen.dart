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
  PageController _pageController = PageController();
  //Text Styleing constants
  final fontSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              return PageView(
                controller: _pageController,
                children: [
                  // Journal entry
                  SafeArea(
                    child: journalLog != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Journal Entry",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${journalLog.entry}",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text("Rating: ${journalLog.rating}"),
                            ],
                          )
                        : Center(child: Text("No journal data for today.")),
                  ),
                  // Diet entry
                  SafeArea(
                    child: dietLog != null
                        ? Column(children: [
                            Text(
                              "Meal List:",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
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
                              ),
                            ),
                          ])
                        : Center(child: Text("No diet entry data for today.")),
                  ),
                  // Exercise ListView
                  SafeArea(
                    child: workoutsLog != null
                        ? Column(children: [
                            Text(
                              "Workout Log:",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
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
                              ),
                            ),
                          ])
                        : Center(
                            child: Text("There is no workout data for today."),
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
