import 'dart:convert';

enum Complexity { simple, medium, difficult }

enum Cost { cheap, fair, expensive }

extension ComplexityExtension on Complexity {
  int get value => index;
  static Complexity fromInt(int value) => Complexity.values[value];
}

extension CostExtension on Cost {
  int get value => index;
  static Cost fromInt(int value) => Cost.values[value];
}

class Meal {
  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  final Complexity complexity;
  final Cost cost;

  const Meal({
    required this.id,
    required this.categories,
    required this.duration,
    required this.imageUrl,
    required this.ingredients,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
    required this.steps,
    required this.title,
    required this.complexity,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categories': jsonEncode(categories),
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': jsonEncode(ingredients),
      'steps': jsonEncode(steps),
      'duration': duration,
      'isGlutenFree': isGlutenFree ? 1 : 0,
      'isLactoseFree': isLactoseFree ? 1 : 0,
      'isVegan': isVegan ? 1 : 0,
      'isVegetarian': isVegetarian ? 1 : 0,
      'complexity': complexity.index,
      'cost': cost.index,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      categories: List<String>.from(jsonDecode(map['categories'])),
      title: map['title'],
      imageUrl: map['imageUrl'],
      ingredients: List<String>.from(jsonDecode(map['ingredients'])),
      steps: List<String>.from(jsonDecode(map['steps'])),
      duration: map['duration'],
      isGlutenFree: map['isGlutenFree'] == 1,
      isLactoseFree: map['isLactoseFree'] == 1,
      isVegan: map['isVegan'] == 1,
      isVegetarian: map['isVegetarian'] == 1,
      complexity: ComplexityExtension.fromInt(map['complexity']),
      cost: CostExtension.fromInt(map['cost']),
    );
  }

  String get complexityText {
    switch (complexity) {
      case Complexity.simple:
        return "Simples";
      case Complexity.medium:
        return "Normal";
      case Complexity.difficult:
        return "Difícil";
    }
  }

  String get costText {
    switch (cost) {
      case Cost.cheap:
        return "Barato";
      case Cost.fair:
        return "Justo";
      case Cost.expensive:
        return "Caro";
    }
  }
}
