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
  bool _journalValid = false;
  bool _ratingValid = false;

  //dispose of the controller when the widget is unmounted
  @override
  void dispose() {
    _textController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String journal = "", rating = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: "Enter your journal for the day",
            errorText: _journalValid ? "Journal can't be empty" : null,
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
        TextFormField(
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
        ElevatedButton(
            onPressed: () {
              if (_ratingValid && _journalValid) {
                _db.postJournalEntry(journal, rating);
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
              }
            },
            child: Text(
              'submit',
            )),
      ],
    );
  }
}
