import 'package:flutter/material.dart';
import 'package:mastermind/screens/game_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isSinglePlayer;
  const SettingsScreen({super.key, required this.isSinglePlayer});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  double rowSize = 5;
  double colors = 7;
  double trys = 12;
  bool uniqueColors = true;
  bool countTogether = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SettingsOption(
                title: 'Row Size',
                widget: SettingsSlider(
                  value: rowSize,
                  min: 2,
                  max: 6,
                  onChanged: (value) {
                    setState(() {
                      rowSize = value;
                      if (rowSize > colors) {
                        colors = rowSize;
                      }
                    });
                  },
                ),
              ),
              SettingsOption(
                title: 'Colors',
                widget: SettingsSlider(
                  value: colors,
                  min: rowSize.toInt(),
                  max: 18,
                  onChanged: (value) {
                    setState(() {
                      colors = value;
                    });
                  },
                ),
              ),
              SettingsOption(
                  title: "Trys",
                  widget: SettingsSlider(
                      value: trys,
                      min: 1,
                      max: 30,
                      onChanged: (value) {
                        setState(() {
                          trys = value;
                        });
                      })),
              SettingsOption(
                title: 'Unique Colors Only',
                widget: SwitchListTile(
                  value: uniqueColors,
                  subtitle: const Text(
                    'Restrict each row to have unique colors without any duplicates.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      uniqueColors = value;
                    });
                  },
                ),
              ),
              SettingsOption(
                title: 'Count Correct Colors Together',
                widget: SwitchListTile(
                  value: countTogether,
                  subtitle: const Text(
                    'When enabled, correctly positioned colors are counted as part of the correct colors.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      countTogether = value;
                    });
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.isSinglePlayer
                            ? MastermindGame(
                                trys: trys.toInt(),
                                rowSize: rowSize.toInt(),
                                colorCount: colors.toInt(),
                                countTogether: countTogether,
                              )
                            : MultiplayerScreen(),
                      ),
                    );
                  },
                  child: const Text('Start Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String title;
  final Widget widget;

  const SettingsOption({
    Key? key,
    required this.title,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        widget,
        const SizedBox(height: 20),
      ],
    );
  }
}

class SettingsSlider extends StatelessWidget {
  final double value;
  final int min;
  final int max;
  final ValueChanged<double> onChanged;

  const SettingsSlider({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            label: value.toInt().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class MultiplayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplayer Mode'),
      ),
      body: const Center(
        child: Text(
          'Multiplayer Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
