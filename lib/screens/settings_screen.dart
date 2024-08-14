import 'package:flutter/material.dart';
import 'package:mastermind/screens/game_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isSinglePlayer;
  const SettingsScreen({super.key, required this.isSinglePlayer});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  double difficultyPreset = 3;
  double rowSize = 5;
  double colors = 7;
  double trys = 12;
  bool uniqueColors = true;
  bool countTogether = false;
  List<Map<String, dynamic>> presets = [
    {
      "rowSize": 3,
      "colors": 4,
      "trys": 20,
      "uniqueColors": true,
    },
    {
      "rowSize": 4,
      "colors": 5,
      "trys": 15,
      "uniqueColors": true,
    },
    {
      "rowSize": 5,
      "colors": 7,
      "trys": 12,
      "uniqueColors": true,
    },
    {
      "rowSize": 6,
      "colors": 10,
      "trys": 12,
      "uniqueColors": true,
    },
    {
      "rowSize": 6,
      "colors": 10,
      "trys": 12,
      "uniqueColors": false,
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadPreset(2);
  }

  void _loadPreset(int presetId) {
    setState(() {
      Map preset = presets[presetId];
      rowSize = (preset["rowSize"] as int).toDouble();
      colors = (preset["colors"] as int).toDouble();
      trys = (preset["trys"] as int).toDouble();
      uniqueColors = preset["uniqueColors"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MastermindGame(
                      trys: trys.toInt(),
                      rowSize: rowSize.toInt(),
                      colorCount: colors.toInt(),
                      countTogether: countTogether,
                      uniqueColors: uniqueColors,
                      isSinglePlayer: widget.isSinglePlayer)),
            );
          },
          label: const Text(
            "Start",
          ),
          icon: const Icon(
            Icons.check,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SettingsOption(
                  title: "Difficulty Presets",
                  widget: SettingsSlider(
                      value: difficultyPreset,
                      min: 1,
                      max: presets.length,
                      onChanged: (value) {
                        setState(() {
                          difficultyPreset = value;
                        });
                        _loadPreset(value.toInt() - 1);
                      })),
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
