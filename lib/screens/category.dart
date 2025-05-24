import 'package:flutter/material.dart';
import 'package:meals/components/mealItem.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';

class CategoryScreen extends StatelessWidget {
  final List<Meal> meals;

  const CategoryScreen({required this.meals, super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category;

    final listMeals =
        meals.where((meal) {
          return meal.categories.contains(category.title);
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: listMeals.length,
          itemBuilder: (ctx, index) {
            return MealItem(listMeals[index]);
          },
        ),
      ),
    );
  }
}
