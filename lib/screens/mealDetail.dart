import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

import '../helper/database.dart';

class MealDetailScreen extends StatefulWidget {
  final Function(bool? isFav, Meal? meal, Function() checkIfFavorite)
  onSelectMealFavorite;
  const MealDetailScreen(this.onSelectMealFavorite, {super.key});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal? meal;
  bool? isFav;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    if (meal == null) {
      meal = ModalRoute.of(context)!.settings.arguments as Meal;
      _checkIfFavorite();
    }
  }

  void _checkIfFavorite() async {
    final favorite = await DBHelper.isFavorite(meal!.id);
    setState(() {
      isFav = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (meal == null || isFav == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Carregando...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Widget createSectionTitle(IconData icon, Widget child) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [Icon(icon), child],
        ),
      );
    }

    Widget createSectionContainer(Widget child) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: 330,
        height: 250,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: child,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(meal!.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(meal!.imageUrl, fit: BoxFit.cover),
            ),
            createSectionTitle(
              Icons.local_grocery_store,
              Text(
                "Ingredientes",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            createSectionContainer(
              ListView.builder(
                itemCount: meal!.ingredients.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      child: Text(
                        "${meal!.ingredients[index]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            createSectionTitle(
              Icons.format_list_numbered,
              Text(
                "Passo a passo",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            createSectionContainer(
              ListView.builder(
                itemCount: meal!.steps.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          meal!.steps[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Divider(color: const Color.fromARGB(255, 244, 242, 242)),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => widget.onSelectMealFavorite(isFav, meal, _checkIfFavorite),
        child: Icon(isFav! ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }
}
