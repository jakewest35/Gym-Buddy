import 'package:flutter/material.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
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
    String diet = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Enter your diet for the day",
            errorText: _validate ? "diet can't be empty" : null,
          ),
          onChanged: (value) => diet = value,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _controller.text.isEmpty ? _validate = true : _validate = false;
              });
              print("User submitted their diet: $diet");
            },
            child: Text(
              'submit',
            )),
      ],
    );
  }
}
