import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles the authentication workflow for the dashboard login/logout
/// button.
class GoogleAuthenticationPage extends StatefulWidget {
  GoogleAuthenticationPage({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  State<GoogleAuthenticationPage> createState() =>
      _GoogleAuthenticationPageState();
}

class _GoogleAuthenticationPageState extends State<GoogleAuthenticationPage> {
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

  /// Define ALL allowed authentication scopes for the application,
  /// not just the Google scope(s).
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  /// Sign into Google
  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) print(error);
    }
  }

  /// Sign out
  Future<void> _handleGoogleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// login/logout button formatting
        SizedBox(
          width: 225.0,
          child: ElevatedButton(
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
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
        Visibility(
            visible: !widget.loggedIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: () {
                  _handleGoogleSignIn();
                },
              ),
            )),
      ],
    );
  }
}
