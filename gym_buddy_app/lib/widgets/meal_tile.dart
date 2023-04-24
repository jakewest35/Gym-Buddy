import 'package:flutter/material.dart';

class MealTile extends StatefulWidget {
  final String mealName;
  final String calories;
  final String fats;
  final String carbs;
  final String protein;

  MealTile({
    super.key,
    required this.mealName,
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.protein,
  });

  @override
  State<MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<MealTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        title: Text(
          widget.mealName,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        subtitle: SafeArea(
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Chip(
                    label: Text(
                      "${widget.calories} cal",
                    ),
                  ),
                  Chip(
                    label: Text(
                      "${widget.fats} fat",
                    ),
                  ),
                  Chip(
                    label: Text(
                      "${widget.carbs} carb.",
                    ),
                  ),
                  Chip(
                    label: Text(
                      "${widget.protein} protein",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
