import 'package:flutter/material.dart';
import 'package:gym_buddy_app/models/diet_model.dart';

class DietUtility extends ChangeNotifier {
  List<DietModel> dietEntries = [];

  // get the diet list
  List<DietModel> get getDietEntriesList => dietEntries;

  // set the diet list
  void setDietEntriesList(List<DietModel> list) {
    dietEntries = list;
    notifyListeners();
  }

  // clear the diet list
  void clearDietList() {
    dietEntries.clear();
    printDietList();
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
      print("dietUtility::addDietEntry: added $mealName to the list.");
      notifyListeners();
    } catch (e) {
      print("Unable to add diet entry. Error: $e");
    }
  }

  // remove an entry from the diet list
  void removeDietEntry(String mealName) {
    try {
      DietModel tmp =
          dietEntries.firstWhere((element) => element.mealName == mealName);
      dietEntries.remove(tmp);
    } catch (e) {
      print("Couldn't find $mealName in the dietEntries list");
    }
    notifyListeners();
  }
}
