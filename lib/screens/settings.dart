import 'package:flutter/material.dart';
import 'package:meals/components/sidebar.dart';
import 'package:meals/models/settings.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Settings) onChangedSettings;
  final Settings settings;

  const SettingsScreen(this.settings, this.onChangedSettings, {super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Settings settings;

  @override
  void initState() {
    super.initState();
    settings = widget.settings;
  }

  Widget createSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
      ),
      value: value,
      onChanged: (value) {
        onChanged(value);
        widget.onChangedSettings(settings);
      },
      activeColor: Colors.blue,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.black12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      drawer: Sidebar(),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                createSwitch(
                  "Sem Glúten",
                  "Ocultar refeições com glúten.",
                  settings.isGlutenFree,
                  (value) {
                    setState(() {
                      settings.isGlutenFree = value;
                    });
                  },
                ),
                createSwitch(
                  "Sem Lactose",
                  "Ocultar refeições com lactose.",
                  settings.isLactoseFree,
                  (value) {
                    setState(() {
                      settings.isLactoseFree = value;
                    });
                  },
                ),
                createSwitch(
                  "Refeições Veganas",
                  "Mostrar somente refeições veganas.",
                  settings.isVegan,
                  (value) {
                    setState(() {
                      settings.isVegan = value;
                    });
                  },
                ),
                createSwitch(
                  "Refeições Vegetarianas",
                  "Mostrar somente refeições vegetarianas.",
                  settings.isVegetarian,
                  (value) {
                    setState(() {
                      settings.isVegetarian = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
