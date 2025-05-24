import 'package:flutter/material.dart';
import 'package:meals/components/sidebar.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/favorites.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favorites;
  final List<Category> listCategories;
  const TabsScreen(this.favorites, this.listCategories, {super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int tabSelected = 0;
  late List<Map<String, Object>> listTabsScreen;

  @override
  void initState() {
    super.initState();
    listTabsScreen = [
      {
        "title": "Todas as categorias",
        "screen": CategoriesScreen(widget.listCategories),
      },
      {
        "title": "Comidas favoritas",
        "screen": FavoritesScreen(widget.favorites),
      },
    ];
  }

  void _onSelectTab(int count) {
    setState(() {
      tabSelected = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = listTabsScreen[tabSelected]["title"] as String;
    Widget body = listTabsScreen[tabSelected]["screen"] as Widget;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      drawer: Sidebar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabSelected,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onSelectTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categorias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
        ],
      ),
    );
  }
}
