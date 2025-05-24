import 'package:flutter/material.dart';
import 'package:meals/utils/appRoutes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Widget _linkRow(IconData icon, String label, Function() onTap) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black45),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black45,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: 120,
            child: Text(
              "Vamos cozinhar?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(height: 16),
          _linkRow(
            Icons.restaurant,
            "Categorias",
            () => Navigator.of(context).pushReplacementNamed(AppRoutes.HOME),
          ),
          _linkRow(
            Icons.filter_list,
            "Filtros",
            () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.SETTINGS),
          ),
        ],
      ),
    );
  }
}
