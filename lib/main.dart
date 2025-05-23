import 'package:flutter/material.dart';
import 'package:meals/screens/Category.dart';
import 'package:meals/screens/mealDetail.dart';
import 'package:meals/screens/settings.dart';
import 'package:meals/screens/tabs.dart';
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
        AppRoutes.CATEGORIES_MEALS: (ctx) => CategoryScreen(),
        AppRoutes.MEAL_DETAILS: (ctx) => MealDetailScreen(),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(),
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
