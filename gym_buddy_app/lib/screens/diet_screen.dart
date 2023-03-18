import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final _controller = TextEditingController();
  DatabaseUtility _db = DatabaseUtility();
  bool _dietEntryValid = false;

  //dispose of the controller when the widget is unmounted
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String entry = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Enter your diet for the day",
            errorText: _dietEntryValid ? "diet can't be empty" : null,
          ),
          onChanged: (value) {
            entry = value;
            _dietEntryValid = true;
          },
        ),
        ElevatedButton(
            onPressed: () {
              if (_dietEntryValid == false) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Make sure diet entry is not empty"),
                    actions: [
                      MaterialButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                );
              } else {
                _db.postDiet(entry);
                _controller.clear();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Diet entry saved!"),
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
            child: Text(
              'submit',
            )),
      ],
    );
  }
}
