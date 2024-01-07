import 'package:flutter/material.dart';
import 'package:job_post_aggrigation_mobile/components/drawer.dart';
import 'package:job_post_aggrigation_mobile/components/text_field.dart';
import 'package:job_post_aggrigation_mobile/pages/user_profile.dart';
import 'package:job_post_aggrigation_mobile/utils/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final queryController = TextEditingController();

  //TODO sign the user out of the app
  void signOut() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("User signed out :)"),
      ),
    );
  }

  // navigate to the user's profile
  void goToProfilePage() {
    // collapse the drawer
    Navigator.pop(context);

    // navigate to the user's profile
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const UserProfile()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job post aggrigator"),
        backgroundColor: Colors.grey[800],
      ),
      drawer: MyDrawer(onProfiletap: goToProfilePage, onSignOut: signOut),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextField(
                    controller: queryController,
                    hintText: "Search for a job",
                    obscureText: false),
                ElevatedButton(
                  onPressed: () {
                    fetchData(queryController.text);
                  },
                  child: const Text("Search jobs"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
