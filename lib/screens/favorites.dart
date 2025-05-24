import 'package:flutter/material.dart';
import 'package:meals/components/mealItem.dart';
import 'package:meals/models/meal.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Meal> favorites;
  const FavoritesScreen(this.favorites, {super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) {
      return Center(child: Text("Nenhuma refeição favorita!"));
    }

    return ListView.builder(
      itemCount: widget.favorites.length,
      itemBuilder: (ctx, index) {
        return MealItem(widget.favorites[index]);
      },
    );
  }
}
