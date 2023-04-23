import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gym_buddy_app/themes/color_schemes.g.dart';
import 'package:provider/provider.dart';
import 'utilities/firebase_init.dart';
import 'package:go_router/go_router.dart';
import 'utilities/side_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash(); // show the splash screen
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserAuthenticationState(),
      builder: (context, child) => App(),
    ),
  );
}

///authentication routes definition for the application
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SideBar(),
      routes: [
        ///sign in route
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            ///wrap in Scaffold to provide back button functionality
            return Scaffold(
              appBar: AppBar(),
              body: SignInScreen(
                actions: [
                  ForgotPasswordAction(((context, email) {
                    final uri = Uri(
                      path: '/sign-in/forgot-password',
                      queryParameters: <String, String?>{
                        'email': email,
                      },
                    );
                    context.push(uri.toString());
                  })),
                  AuthStateChangeAction(((context, state) {
                    if (state is SignedIn || state is UserCreated) {
                      var user = (state is SignedIn)
                          ? state.user
                          : (state as UserCreated).credential.user;
                      if (user == null) {
                        return;
                      }
                      if (state is UserCreated) {
                        user.updateDisplayName(user.email!.split('@')[0]);
                      }
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            content: Text(
                                'Please check your email to verify your email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      context.pushReplacement('/');
                    }
                  })),
                ],
              ),
            );
          },

          ///forgot password route
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.queryParams;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),

        ///profile route
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(""),
              ),
              body: ProfileScreen(
                providers: const [],
                actions: [
                  SignedOutAction((context) {
                    context.pushReplacement('/');
                  }),
                ],
              ),
            );
          },
        ),
      ],
    ),
  ],
);

///"Main" widget for the application
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gym-Buddy',
      debugShowCheckedModeBanner: false, //disables debug flag on simulator
      theme: ThemeData(
          useMaterial3: true, colorScheme: CustomTheme.lightColorScheme),
      darkTheme: ThemeData(
          useMaterial3: true, colorScheme: CustomTheme.darkColorScheme),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
