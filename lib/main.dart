import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/models/settings.dart';
import 'package:meals/screens/Category.dart';
import 'package:meals/screens/mealDetail.dart';
import 'package:meals/screens/settings.dart';
import 'package:meals/screens/tabs.dart';
import 'package:meals/utils/appRoutes.dart';

void main() => runApp(Meals());

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  List<Meal> listMeals = dummyMeals;
  Settings settings = Settings();

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;
      listMeals =
          dummyMeals.where((meal) {
            final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
            final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
            final filterVegan = settings.isVegan && !meal.isVegan;
            final filterVegetarian =
                settings.isVegetarian && !meal.isVegetarian;

            return !filterGluten &&
                !filterLactose &&
                !filterVegan &&
                !filterVegetarian;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: "Raleway",
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        primaryColor: Colors.blue,
        fontFamily: "Raleway",
        colorScheme: ColorScheme(
          primary: Colors.white,
          brightness: Brightness.light,
          onPrimary: Colors.blue,
          secondary: Color.fromRGBO(34, 242, 187, 1),
          onSecondary: Color.fromRGBO(34, 242, 187, 1),
          error: Colors.red,
          onError: Colors.red,
          surface: Color.fromRGBO(255, 254, 229, 1),
          onSurface: Color.fromRGBO(255, 254, 229, 1),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          titleMedium: TextStyle(
            fontSize: 20,
            fontFamily: "Raleway",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontFamily: "RobotoCondensed",
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
      routes: {
        AppRoutes.HOME: (ctx) => TabsScreen(),
        AppRoutes.CATEGORIES_MEALS: (ctx) => CategoryScreen(meals: listMeals),
        AppRoutes.MEAL_DETAILS: (ctx) => MealDetailScreen(),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(settings, _filterMeals),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return TabsScreen();
          },
        );
      },
    );
  }
}
