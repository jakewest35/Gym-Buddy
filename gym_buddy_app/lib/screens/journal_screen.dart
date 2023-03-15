import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _controller = TextEditingController();
  bool _validate = false;

  //dispose of the controller when the widget is unmounted
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String journal = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Enter your journal for the day",
            errorText: _validate ? "journal can't be empty" : null,
          ),
          onChanged: (value) => journal = value,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _controller.text.isEmpty ? _validate = true : _validate = false;
              });
              print("User submitted their journal: $journal");
            },
            child: Text(
              'submit',
            )),
      ],
    );
  }
}
