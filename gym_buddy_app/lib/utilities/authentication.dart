import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/custom_widgets.dart';

/// Handles the authentication workflow for the dashboard login/logout
/// button. Redirects to src/authentication.dart
class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  GoogleSignInAccount? _googleUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _googleUser = account;
      });
      if (_googleUser != null) {
        if (kDebugMode) {
          print(_googleUser!.displayName);
        }
      }
    });
    _googleSignIn.signInSilently();
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleGoogleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
            onPressed: () {
              if (_googleUser == null) {
                !widget.loggedIn ? context.push('/sign-in') : widget.signOut();
              } else {
                !widget.loggedIn
                    ? context.push('/sign-in')
                    : _handleGoogleSignOut();
              }
            },
            child:
                !widget.loggedIn ? const Text('Login') : const Text('Logout'),
          ),
        ),
        Visibility(
            visible: !widget.loggedIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                Buttons.Google,
                onPressed: () {
                  _handleGoogleSignIn();
                },
              ),
            )),
      ],
    );
  }
}
