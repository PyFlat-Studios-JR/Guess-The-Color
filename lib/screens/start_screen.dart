import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/game_mode_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Mastermind!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Select game mode',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                GameModeButton(
                  icon: Icons.person,
                  label: 'Random Color',
                  isSinglePlayer: true,
                ),
                SizedBox(height: 20),
                GameModeButton(
                  icon: Icons.group,
                  label: 'Custom Color',
                  isSinglePlayer: false,
                ),
              ],
            ),
          ),
          Spacer(),
          if (kIsWeb) Text("© 2024 PyFlat - v1.0.0"),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
