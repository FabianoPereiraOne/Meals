import 'package:flutter/material.dart';
import 'package:meals/components/mealItem.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category;
    final listMeals =
        dummyMeals.where((meal) {
          return meal.categories.contains(category.id);
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
