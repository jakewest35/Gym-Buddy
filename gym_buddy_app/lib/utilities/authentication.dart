import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_widgets.dart';

/// Handles the authentication workflow for the dashboard login/logout
/// button. Redirects to src/authentication.dart
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
            onPressed: () {
              !loggedIn ? context.push('/sign-in') : signOut();
            },
            child: !loggedIn ? const Text('Login') : const Text('Logout'),
          ),
        ),
        Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  onPressed: () {
                    context.push('/profile');
                  },
                  child: const Text('Profile')),
            )),
      ],
    );
  }
}
