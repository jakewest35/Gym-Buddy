import 'package:flutter/material.dart';
import 'package:gym_buddy_app/utilities/app_state.dart';
import '../screens/dashboard_screen.dart';
import '../screens/diet_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/workout_screen.dart';

/// Main page loader/sidebar logic for the application
class PageLoader extends StatefulWidget {
  @override
  State<PageLoader> createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  var _selectedIndex = 0;
  final _appState = ApplicationState();

  @override
  Widget build(BuildContext context) {
    Widget page;

    /// If the user is signed in, display the sidebar
    /// and let them navigate
    if (_appState.loggedIn) {
      switch (_selectedIndex) {
        case 0:
          page = DashboardPage();
          break;
        case 1:
          page = WorkoutPage();
          break;
        case 2:
          page = DietPage();
          break;
        case 3:
          page = JournalPage();
          break;
        default:
          throw UnimplementedError("no widget for $_selectedIndex");
      }
    }

    /// If not authenticated, redirect to the login page
    else {
      page = DashboardPage();
    }
    //render the sidebar
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.fitness_center),
                    label: Text('Workout Log'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.restaurant), label: Text('Diet log')),
                  NavigationRailDestination(
                      icon: Icon(Icons.mood), label: Text("Journal")),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
