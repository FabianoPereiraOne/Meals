import 'package:flutter/material.dart';
import 'package:meals/components/categoryItem.dart';
import "package:meals/models/category.dart";

class CategoriesScreen extends StatelessWidget {
  final List<Category> listCategories;
  const CategoriesScreen(this.listCategories, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: listCategories.map((cat) => CategoryItem(cat)).toList(),
    );
  }
}
