import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/diet_model.dart';
import 'package:gym_buddy_app/utilities/database_utility.dart';
import 'package:gym_buddy_app/utilities/diet_utility.dart';
import 'package:gym_buddy_app/widgets/exapndable_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DietUtility(),
      builder: (context, child) => DietScreen(),
    );
  }
}

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  DatabaseUtility db = DatabaseUtility();
  List<DietModel> dietEntries = [];
  String mealName = "", calories = "", fats = "", carbs = "", protein = "";
  late SharedPreferences prefs;
  Map<String, int> macroTotals = {
    "Fat": 0,
    "Carbs": 0,
    "Protein": 0,
    "TotalCalories": 0,
  };

  @override
  void initState() {
    _initPreferences();
    super.initState();
  }

  void _initPreferences() async {
    prefs = await SharedPreferences.getInstance();

    // decode meal list if it exists
    final jsonMealList = prefs.getString("dietState");
    if (jsonMealList != null) {
      List<dynamic> jsonParsed = jsonDecode(jsonMealList);
      setState(() {
        dietEntries = jsonParsed.map((e) => DietModel.fromJson(e)).toList();
      });
      Provider.of<DietUtility>(context, listen: false)
          .setDietEntriesList(dietEntries);
    }

    // decode macros if they exist
    final jsonMacroMap = prefs.getString("macroState");
    if (jsonMacroMap != null) {
      Map<String, dynamic> jsonParsed = jsonDecode(jsonMacroMap);
      setState(() {
        macroTotals =
            jsonParsed.map((key, value) => MapEntry(key, value as int));
      });
      Provider.of<DietUtility>(context, listen: false)
          .setMacroTotals(macroTotals);
    }

    if (kDebugMode) {
      if (jsonMealList == null) {
        print("_initPreferences: No previous meal state.");
      }
      if (jsonMacroMap == null) {
        print("_initPreferences: No previous macro state.");
      }
    }
  }

  /// Reset the shared_preferences state. Used if the user wants
  /// to reset or clear their meal list
  void resetState() {
    setState(() {
      Provider.of<DietUtility>(context, listen: false).clearDietList();
      macroTotals =
          Provider.of<DietUtility>(context, listen: false).getMacroTotals;
    });
    if (kDebugMode) print("set diet state = null");
  }

  // update macros
  void updateMacros(
      String operation, int fat, int carbs, int protein, int calories) {
    Provider.of<DietUtility>(context, listen: false)
        .updateMacros(operation, fat, carbs, protein, calories);
  }

  ///Add the exercise to the current local workout and save the state
  void save(String mealName, String calories, String fats, String carbs,
      String protein) {
    // save/update meals
    Provider.of<DietUtility>(context, listen: false)
        .addDietEntry(mealName, calories, fats, carbs, protein);
    dietEntries =
        Provider.of<DietUtility>(context, listen: false).getDietEntriesList;

    // save/update macros
    updateMacros("add", int.parse(fats), int.parse(carbs), int.parse(protein),
        int.parse(calories));
    macroTotals =
        Provider.of<DietUtility>(context, listen: false).getMacroTotals;
  }

  ///Alert dialog to display the UI to add an exercise to the current workout
  void addMealAlertDialog(BuildContext context) {
    TextEditingController mealNameController = TextEditingController();
    TextEditingController caloriesController = TextEditingController();
    TextEditingController fatsController = TextEditingController();
    TextEditingController carbsController = TextEditingController();
    TextEditingController proteinController = TextEditingController();
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              titleTextStyle: Theme.of(context).textTheme.displayMedium,
              title: Text("Add a meal"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: mealNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: "Meal name"),
                  ),
                  TextFormField(
                    controller: caloriesController,
                    decoration: InputDecoration(hintText: "Total calories"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  ),
                  TextFormField(
                    controller: fatsController,
                    decoration: InputDecoration(hintText: "Grams of fat"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextFormField(
                    controller: carbsController,
                    decoration: InputDecoration(hintText: "Grams of carbs"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextFormField(
                    controller: proteinController,
                    decoration: InputDecoration(hintText: "Grams of Protein"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    save(
                        mealNameController.text,
                        caloriesController.text,
                        fatsController.text,
                        carbsController.text,
                        proteinController.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DietUtility>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Diet Log",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            // add meal button
            ActionButton(
              icon: const Icon(Icons.add),
              toolTip: "Add a meal.",
              onPressed: () {
                setState(() {
                  addMealAlertDialog(context);
                });
              },
            ),
            // post diet list button
            ActionButton(
              icon: const Icon(Icons.save),
              toolTip: "Save the meal list.",
              onPressed: () {
                List<DietModel> entries = value.getDietEntriesList;
                if (entries.isNotEmpty) {
                  db.postDiet(entries);
                  prefs.remove("dietState");
                  Provider.of<DietUtility>(context, listen: false)
                      .clearDietList();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Meal list saved!"),
                      actions: [
                        MaterialButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Can't save an empty meal list. Try adding a meal before saving."),
                      actions: [
                        MaterialButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  );
                }
              },
            ),
            // clear diet list button
            ActionButton(
              icon: Icon(Icons.not_interested),
              toolTip: "Clear the meal list",
              onPressed: () {
                resetState();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Reset meal list!"),
                    actions: [
                      MaterialButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Total Fat: ${macroTotals["Fat"]} g.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Total Protein: ${macroTotals["Protein"]} g.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Total Carbs: ${macroTotals["Carbs"]}g.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Total Calories: ${macroTotals["TotalCalories"]} cal.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dietEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Dismissible(
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        key: Key(dietEntries[index].mealName),
                        onDismissed: (direction) {
                          Provider.of<DietUtility>(context, listen: false)
                              .removeDietEntry(dietEntries[index].mealName);
                          if (Provider.of<DietUtility>(context, listen: false)
                                  .getDietEntriesList
                                  .length ==
                              0) {
                            prefs.remove("dietState");
                            prefs.remove("macrosState");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            title: Text(
                              dietEntries[index].mealName,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: SafeArea(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Chip(
                                      label: Text(
                                        "${dietEntries[index].calories} cal.",
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        "${dietEntries[index].fats} fat",
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        "${dietEntries[index].carbs} carb.",
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        "${dietEntries[index].protein} protein",
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
