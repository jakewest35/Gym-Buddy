class ExerciseModel {
  final String name;
  final String weight;
  final String reps;
  final String sets;
  bool isCompleted;

  ExerciseModel(
      {required this.name,
      required this.weight,
      required this.reps,
      required this.sets,
      this.isCompleted = false});

  Map<String, dynamic> toJson() => {
        'name': name,
        'weight': weight,
        'reps': reps,
        'sets': sets,
        'isCompleted': isCompleted,
      };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
      name: json["name"],
      weight: json["weight"],
      reps: json["reps"],
      sets: json["sets"],
      isCompleted: json["isCompleted"]);
}
