class DietModel {
  String mealName;
  String calories;
  String fats;
  String carbs;
  String protein;

  DietModel({
    required this.mealName,
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.protein,
  });

  Map<String, dynamic> toJson() => {
        'mealName': mealName,
        'calories': calories,
        'fats': fats,
        'carbs': carbs,
        'protein': protein,
      };

  factory DietModel.fromJson(Map<String, dynamic> json) => DietModel(
        mealName: json["mealName"],
        calories: json["calories"],
        fats: json["fats"],
        carbs: json["carbs"],
        protein: json["protein"],
      );
}
