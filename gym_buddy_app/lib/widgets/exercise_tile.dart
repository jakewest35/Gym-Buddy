import 'package:flutter/material.dart';

class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckboxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckboxChanged,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        title: Text(
          widget.exerciseName,
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                "${widget.weight} lbs.",
                style: TextStyle(fontSize: 11.0),
              ),
            ),
            Chip(
              label: Text(
                "${widget.sets} sets",
                style: TextStyle(fontSize: 11.0),
              ),
            ),
            Chip(
              label: Text(
                "${widget.reps} reps",
                style: TextStyle(fontSize: 11.0),
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: widget.isCompleted,
          onChanged: (value) => widget.onCheckboxChanged!(value),
        ),
      ),
    );
  }
}
