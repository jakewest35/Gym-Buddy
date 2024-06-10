import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/screens/previous_data_screen.dart';
import 'package:gym_buddy_app/utilities/firebase_init.dart';
import 'package:gym_buddy_app/utilities/google_authentication.dart';
import 'package:provider/provider.dart';

/// Dashboard page
class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TextEditingController _dateController = new TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _loggedIn = Provider.of<UserAuthenticationState>(context).loggedIn;
    if (_loggedIn) {
      final userName = FirebaseAuth.instance.currentUser!.displayName;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome back, \n$userName!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  log("${pickedDate}");
                  setState(() {
                    _dateController.text =
                        "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
                  });
                }
              },
            ),
            SizedBox(
              height: 12.0,
            ),
            SizedBox(
              width: 225.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PreviousDataPage(date: "${_dateController.text}"),
                      ));
                },
                child: Text("Get previous data"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Consumer<UserAuthenticationState>(
              builder: (context, appState, _) => GoogleAuthenticationPage(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  }),
            ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 100.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Welcome to Gym-Buddy!",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Consumer<UserAuthenticationState>(
              builder: (context, appState, _) => GoogleAuthenticationPage(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  }),
            ),
          ),
        ],
      );
    }
  }
}
