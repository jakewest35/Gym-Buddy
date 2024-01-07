import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //logo
              Icon(
                Icons.message,
                size: 80,
                color: Colors.grey,
              ),

              // welcome back message
              Text(
                "Welcome back you've been missed!",
                style: TextStyle(fontSize: 16),
              ),

              //email textfield
              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false),

              // password textfield

              // sign in button

              // not a member? register here
            ],
          ),
        ),
      ),
    );
  }
}
