import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  DatabaseUtility _db = DatabaseUtility();
  final _textController = TextEditingController();
  final _ratingController = TextEditingController();
  final _weightController = TextEditingController();
  bool _journalValid = false;
  bool _ratingValid = false;
  bool _weightValid = false;

  //dispose of the controller when the widget is unmounted
  @override
  void dispose() {
    _textController.dispose();
    _ratingController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String journal = "", rating = "", weight = "";
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mood,
                size: 100.0,
              ),
              SizedBox(
                height: 120.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 45.0),
            child: Text(
              "Journal Log",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          TextField(
            controller: _textController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "How did you feel today?",
              errorText: _journalValid ? "Journal can't be empty" : null,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (_textController.text.isNotEmpty) {
                journal = value;
                _journalValid = true;
              } else {
                _journalValid = false;
              }
            },
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Rate how you felt from 1-10",
                errorText: _ratingValid ? "Enter a rating" : null),
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            controller: _ratingController,
            onChanged: (value) {
              if (_ratingController.text.isNotEmpty) {
                rating = value.toString();
                _ratingValid = true;
              } else {
                _ratingValid = false;
              }
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter today's bodyweight in lbs.",
              errorText:
                  _weightValid ? "Enter today's bodyweight in lbs." : null,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _weightController,
            onChanged: (value) {
              if (_weightController.text.isNotEmpty) {
                weight = value.toString();
                _weightValid = true;
              } else {
                _weightValid = false;
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (_ratingValid && _journalValid && _weightValid) {
                  _db.postJournalEntry(journal, rating, weight);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Journal Entry saved!"),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"),
                              )
                            ],
                          ));
                  _ratingController.clear();
                  _textController.clear();
                  _weightController.clear();
                } else if (_journalValid == false) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Make sure journal entry is not empty"),
                      actions: [
                        MaterialButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  );
                } else if (_ratingValid == false) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Make sure rating is not empty"),
                      actions: [
                        MaterialButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  );
                } else if (_weightValid == false) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Make sure weight is not empty"),
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
      ),
    );
  }
}
