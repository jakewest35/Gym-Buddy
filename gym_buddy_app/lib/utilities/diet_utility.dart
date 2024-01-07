import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gym_buddy_app/models/diet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietUtility extends ChangeNotifier {
  List<DietModel> dietEntries = [];
  Map<String, int> totalMacros = {
    "Fat": 0,
    "Carbs": 0,
    "Protein": 0,
    "TotalCalories": 0,
  };

  // get the diet list
  List<DietModel> get getDietEntriesList => dietEntries;

  // get the macro totals
  Map<String, int> get getMacroTotals => totalMacros;

  // set the diet list if it exists from the previous state
  void setDietEntriesList(List<DietModel> list) {
    dietEntries = list;
    _updateState();
    notifyListeners();
  }

  // set the macro total if they exist from the previous state
  void setMacroTotals(Map<String, int> totals) {
    totalMacros = totals;
    _updateState();
    notifyListeners();
  }

  // clear the diet list
  void clearDietList() {
    dietEntries.clear();
    totalMacros = {
      "Fat": 0,
      "Carbs": 0,
      "Protein": 0,
      "TotalCalories": 0,
    };
    printDietList();
    print("Total macros reset to:${totalMacros}");
    _updateState();
    notifyListeners();
  }

  // print the diet list
  void printDietList() {
    if (dietEntries.isEmpty) {
      print("There are no entries in the diet list.");
      return;
    }
    for (var entry in dietEntries) {
      print(
          "- ${entry.mealName}. It is ${entry.calories} total calories, containing ${entry.fats} g. fat, ${entry.carbs} g. carbs, and ${entry.protein} g. protein.");
    }
  }

  // add an entry to the diet list
  void addDietEntry(String mealName, String calories, String fats, String carbs,
      String protein) {
    try {
      DietModel newEntry = DietModel(
          mealName: mealName,
          calories: calories,
          fats: fats,
          carbs: carbs,
          protein: protein);
      dietEntries.add(newEntry);
      if (kDebugMode)
        print("dietUtility::addDietEntry: added $mealName to the list.");
      _updateState();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Unable to add diet entry. Error: $e");
    }
  }

  // remove an entry from the diet list
  void removeDietEntry(String mealName) {
    try {
      DietModel tmp =
          dietEntries.firstWhere((element) => element.mealName == mealName);

      // update the macro count before removing the entry
      totalMacros["Fat"] = totalMacros["Fat"]! - int.parse(tmp.fats);
      totalMacros["Carbs"] = totalMacros["Carbs"]! - int.parse(tmp.carbs);
      totalMacros["Protein"] = totalMacros["Protein"]! - int.parse(tmp.protein);
      totalMacros["TotalCalories"] =
          totalMacros["TotalCalories"]! - int.parse(tmp.calories);

      dietEntries.remove(tmp);
    } catch (e) {
      if (kDebugMode) print("Couldn't find $mealName in the dietEntries list");
    }
    _updateState();
    notifyListeners();
  }

  // updates total macros for the page
  void updateMacros(
      String operation, int fat, int carbs, int protein, int calories) {
    if (operation == "add") {
      totalMacros["Fat"] = totalMacros["Fat"]! + fat;
      totalMacros["Carbs"] = totalMacros["Carbs"]! + carbs;
      totalMacros["Protein"] = totalMacros["Protein"]! + protein;
      totalMacros["TotalCalories"] = totalMacros["TotalCalories"]! + calories;
    } else if (operation == "subtract") {
      totalMacros["Fat"] = totalMacros["Fat"]! - fat;
      totalMacros["Carbs"] = totalMacros["Carbs"]! - carbs;
      totalMacros["Protein"] = totalMacros["Protein"]! - protein;
      totalMacros["TotalCalories"] = totalMacros["TotalCalories"]! - calories;
    }
    if (kDebugMode)
      print(
          "TOTAL MACROS: Fat: ${totalMacros["Fat"]}, carbs: ${totalMacros["Carbs"]}, protein: ${totalMacros["Protein"]}, calories: ${totalMacros["TotalCalories"]}");
    _updateState();
  }

  void _updateState() async {
    final prefs = await SharedPreferences.getInstance();

    // encode the meal list
    if (dietEntries.isNotEmpty) {
      final jsonMealList =
          jsonEncode(dietEntries.map((e) => e.toJson()).toList());
      if (kDebugMode)
        print("DietUtility::_updateState: jsonMealList = $jsonMealList");
      await prefs.setString("dietState", jsonMealList).then((value) {
        if (kDebugMode) print("Updated diet state");
      });
    } else {
      if (kDebugMode)
        print("DietUtility::_updateState(): meal state is already empty.");
    }

    // encode the current macro state
    if (totalMacros["TotalCalories"] != 0) {
      String jsonEncodedMacros = json.encode(totalMacros);
      await prefs.setString("macroState", jsonEncodedMacros).then((value) {
        if (kDebugMode) print("Update macro state");
      });
    } else {
      if (kDebugMode)
        print("DietUtility::_updateState(): macro state is already empty.");
    }
  }
}
