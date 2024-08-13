import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class GameModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSinglePlayer;

  const GameModeButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.isSinglePlayer});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SettingsScreen(isSinglePlayer: isSinglePlayer)),
        );
      },
      icon: Icon(
        icon,
        size: 30,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
      ),
    );
  }
}
