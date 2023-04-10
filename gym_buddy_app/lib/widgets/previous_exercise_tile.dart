import 'package:flutter/material.dart';

class PreviousExerciseTile extends StatefulWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;

  PreviousExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
  });

  @override
  State<PreviousExerciseTile> createState() => _PreviousExerciseTileState();
}

class _PreviousExerciseTileState extends State<PreviousExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        title: Text(widget.exerciseName),
        subtitle: Row(
          children: [
            Chip(
              label: Text("${widget.weight} lbs."),
            ),
            Chip(
              label: Text("${widget.sets} sets"),
            ),
            Chip(
              label: Text("${widget.reps} reps"),
            ),
            Chip(
              label: widget.isCompleted
                  ? Text("Completed")
                  : Text("Not completed"),
              backgroundColor:
                  widget.isCompleted ? Colors.green[300] : Colors.red[200],
            ),
          ],
        ),
      ),
    );
  }
}
