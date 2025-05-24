import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals/helper/database.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/models/settings.dart';
import 'package:meals/screens/category.dart';
import 'package:meals/screens/loading.dart';
import 'package:meals/screens/mealDetail.dart';
import 'package:meals/screens/settings.dart';
import 'package:meals/screens/tabs.dart';
import 'package:meals/utils/api.dart';
import "package:meals/utils/appRoutes.dart";

void main() {
  runApp(Meals());
}

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  List<Meal> listMeals = [];
  List<Meal> listMealsOrigin = [];
  List<Category> listCategories = [];
  Settings settings = Settings();
  List<Meal> favorites = [];
  bool isLoading = true;
  final veganKeywords = ['beef', 'chicken', 'fish', 'egg', 'milk', 'cheese'];
  final nonVegetarianKeywords = [
    'beef',
    'chicken',
    'pork',
    'lamb',
    'bacon',
    'ham',
    'fish',
    'anchovy',
    'shrimp',
    'crab',
    'salmon',
    'tuna',
    'meat',
    'turkey',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadMeals();
  }

  void _loadMeals() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) return;

    final data = await fetchMealsAndCategories();
    final List<Category> categories = data['categories'];
    final List<Meal> meals = data['meals'];

    setState(() {
      listMeals = meals;
      listMealsOrigin = meals;
      listCategories = categories;

      isLoading = false;
    });
  }

  void _loadFavorites() async {
    final loadedFavorites = await DBHelper.getMeals();
    setState(() {
      favorites = loadedFavorites;
      if (listCategories.isEmpty && listMeals.isEmpty) return;

      isLoading = false;
    });
  }

  void onSelectMealFavorite(
    bool? isFav,
    Meal? meal,
    Function() checkIfFavorite,
  ) async {
    if (isFav!) {
      await DBHelper.removeMeal(meal!.id);
      setState(() {
        favorites.removeWhere((m) => m.id == meal.id);
      });
    } else {
      await DBHelper.insertMeal(meal!);
      setState(() {
        favorites.add(meal);
      });
    }
    checkIfFavorite();
  }

  bool containsAny(List<String> ingredients, List<String> keywords) {
    return ingredients.any(
      (ingredient) =>
          keywords.any((keyword) => ingredient.toLowerCase().contains(keyword)),
    );
  }

  Future<Map<String, dynamic>> fetchMealsAndCategories() async {
    final categoriesUrl = Uri.parse(Api.categories);
    final mealsUrl = Uri.parse(Api.meals);

    final categoriesRes = await http.get(categoriesUrl);
    final mealsRes = await http.get(mealsUrl);

    if (categoriesRes.statusCode != 200 || mealsRes.statusCode != 200) {
      throw Exception('Erro ao buscar dados da API');
    }

    final categoriesJson = jsonDecode(categoriesRes.body)['categories'] as List;
    final mealsJson = jsonDecode(mealsRes.body)['meals'] as List;

    final random = Random();
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.amber,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
      Colors.lightGreen,
      Colors.brown,
    ];

    final categories =
        categoriesJson.map((json) {
          return Category(
            id: json['idCategory'],
            title: json['strCategory'],
            color: colors[random.nextInt(colors.length)],
          );
        }).toList();

    final meals =
        mealsJson.map((json) {
          final ingredients = <String>[];
          for (var i = 1; i <= 20; i++) {
            final ingredient = json['strIngredient$i'];
            if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
              ingredients.add(ingredient);
            }
          }
          final isVegan = !containsAny(ingredients, veganKeywords);
          final isVegetarian = !containsAny(ingredients, nonVegetarianKeywords);
          final random = Random();

          return Meal(
            id: json['idMeal'],
            title: json['strMeal'],
            imageUrl: json['strMealThumb'],
            duration: random.nextInt(120) + 1,
            ingredients: ingredients,
            steps: [json['strInstructions'] ?? 'Sem instruções.'],
            categories: [json['strCategory']],
            isGlutenFree: !isVegan,
            isVegan: isVegan,
            isVegetarian: isVegetarian,
            isLactoseFree: !isVegan,
            complexity: Complexity.medium,
            cost: Cost.fair,
          );
        }).toList();

    return {'categories': categories, 'meals': meals};
  }

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;

      listMeals =
          listMealsOrigin.where((meal) {
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
    if (isLoading) {
      return MaterialApp(
        title: 'Carregando',
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
        home: LoadingScreen(),
      );
    }

    return MaterialApp(
      title: 'Meals',
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
      home: TabsScreen(favorites, listCategories),
      routes: {
        AppRoutes.CATEGORIES_MEALS: (ctx) => CategoryScreen(meals: listMeals),
        AppRoutes.MEAL_DETAILS: (ctx) => MealDetailScreen(onSelectMealFavorite),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(settings, _filterMeals),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return TabsScreen(favorites, listCategories);
          },
        );
      },
    );
  }
}
