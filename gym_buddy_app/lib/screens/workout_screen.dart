import 'package:flutter/material.dart';
import 'package:gym_buddy_app/screens/previous_workouts_screen.dart';
import 'package:gym_buddy_app/utilities/workout_utility.dart';
import 'package:provider/provider.dart';

import 'new_workout_screen.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                            create: (context) => WorkoutUtility(),
                            builder: (context, child) => WorkoutScreen(),
                          )));
            },
            child: Text("Start new workout")),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviousWorkoutsPage(),
                  ));
            },
            child: Text("View previous workouts")),
      ],
    );
  }
}
