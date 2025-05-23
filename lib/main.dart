import 'package:flutter/material.dart';
import 'package:meals/screens/CategoryScreen.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/mealDetailScreen.dart';
import 'package:meals/utils/appRoutes.dart';

void main() => runApp(Meals());

class Meals extends StatelessWidget {
  const Meals({super.key});

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
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        fontFamily: "Raleway",
        colorScheme: ColorScheme(
          primary: Colors.blue,
          brightness: Brightness.light,
          onPrimary: Colors.blue,
          secondary: Colors.green,
          onSecondary: Colors.green,
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
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      routes: {
        AppRoutes.HOME: (ctx) => CategoriesScreen(),
        AppRoutes.CATEGORIES_MEALS: (ctx) => CategoryScreen(),
        AppRoutes.MEAL_DETAILS: (ctx) => MealDetailScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return CategoriesScreen();
          },
        );
      },
    );
  }
}
