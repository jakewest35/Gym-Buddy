import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/app_state.dart';
import 'package:gym_buddy_app/utilities/authentication.dart';
import 'package:provider/provider.dart';

/// Dashboard page
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to Gym-Buddy!",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthenticationPage(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
        ],
      ),
    );
  }
}
