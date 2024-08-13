import 'dart:math';

import 'package:flutter/material.dart';

import '../components/color_option.dart';

class MastermindGame extends StatefulWidget {
  final int trys;
  final int rowSize;
  final int colorCount;
  const MastermindGame(
      {super.key,
      required this.trys,
      required this.rowSize,
      required this.colorCount});

  @override
  MastermindGameState createState() => MastermindGameState();
}

class MastermindGameState extends State<MastermindGame> {
  late int trys;
  late int rowSize;
  List<Color> initialColors = [
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.blueGrey,
    Colors.brown,
  ];

  List<Color> solution = [];
  List<Color> colors = [];
  List<List<Color>> guesses = [];
  List<List<int>> guessed = [];
  int currentGuess = 0;
  bool finished = false;
  bool isWin = false;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    trys = widget.trys;
    rowSize = widget.rowSize;

    guesses = List.generate(
        trys, (index) => List<Color>.filled(rowSize, Colors.transparent));
    guessed = List.generate(trys, (index) => [0, 0]);
    generateSolution();
    guesses[currentGuess] = List<Color>.filled(rowSize, Colors.grey);
  }

  void generateSolution() {
    setState(() {
      colors = [...initialColors];
      List<Color> tempColors = [...colors];

      tempColors.shuffle();
      tempColors = tempColors.sublist(0, tempColors.length - widget.colorCount);
      colors.removeWhere((color) => tempColors.contains(color));

      print(colors);

      solution = [...colors];
      solution.shuffle();
      solution = solution.sublist(0, rowSize);
    });
  }

  void checkGuess() {
    int correctColorAndPosition = 0;
    int correctColorOnly = 0;

    for (int i = 0; i < rowSize; i++) {
      if (guesses[currentGuess][i] == solution[i]) {
        correctColorAndPosition++;
      } else if (solution.contains(guesses[currentGuess][i])) {
        correctColorOnly++;
      }
    }
    if (correctColorAndPosition == rowSize) {
      isWin = true;
      showSolutionDialog(true);
    } else if (currentGuess == trys - 1) {
      isWin = false;
      showSolutionDialog(false);
    }
    setState(() {
      guessed[currentGuess] = ([correctColorAndPosition, correctColorOnly]);
      currentGuess++;
      if (!finished) {
        guesses[currentGuess] = List<Color>.filled(rowSize, Colors.grey);
      }
    });
  }

  void showSolutionDialog(bool isWin) {
    setState(() {
      finished = true;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isWin ? 'Congratulations!' : 'Game Over!'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Correct Solution:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (Color color in solution)
                  Icon(
                    Icons.circle,
                    size: 40,
                    color: color,
                  ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Future<bool> showContinueDialog(BuildContext context) async {
    if (currentGuess == 0 &&
        guesses[0].every((color) => color == Colors.grey)) {
      return true;
    }
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restart Game'),
          content: const Text(
              'Do you want to restart the game with new colors and tries?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Widget buildTexts(int row, bool type) {
    return Text(
      "${guessed[row][type ? 0 : 1]}",
      style: TextStyle(
          fontSize: 22,
          color: currentGuess - 1 >= row
              ? type
                  ? Colors.red
                  : Colors.white
              : Colors.transparent),
    );
  }

  Widget buildColorButton(int row, int column) {
    bool draggable = false;
    if (guesses[row][column] != Colors.grey && row == currentGuess) {
      draggable = true;
    }
    return DragTarget<Color>(
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          child: Draggable<Color>(
            maxSimultaneousDrags: draggable ? null : 0,
            data: guesses[row][column],
            feedback: ColorOption(
              selected: false,
              color: guesses[row][column],
              onTap: () {},
            ),
            childWhenDragging: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: guesses[row][column],
                shape: BoxShape.circle,
              ),
            ),
            ignoringFeedbackSemantics: true,
            ignoringFeedbackPointer: true,
          ),
          onTap: () async {
            setState(() {
              if (_selectedColor != null) {
                if (row == currentGuess) {
                  if (guesses[row].contains(_selectedColor)) {
                    int idx = guesses[row].indexOf(_selectedColor!);
                    guesses[row][idx] = Colors.grey;
                  }

                  guesses[row][column] = _selectedColor!;
                }
                _selectedColor = null;
              } else {
                if (row == currentGuess) {
                  guesses[row][column] = Colors.grey;
                }
              }
            });
          },
        );
      },
      onAcceptWithDetails: (details) {
        setState(() {
          if (row == currentGuess) {
            if (guesses[row].contains(details.data)) {
              int idx = guesses[row].indexOf(details.data);
              guesses[row][idx] = Colors.grey;
            }

            guesses[row][column] = details.data;
          }
        });
      },
    );
  }

  Widget buildRow(int row) {
    List<Widget> widgets = [];
    widgets.add(buildTexts(row, false));
    for (int i = 0; i < rowSize; i++) {
      widgets.add(buildColorButton(row, i));
    }
    widgets.add(buildTexts(row, true));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  void resetGame() {
    setState(() {
      currentGuess = 0;
      finished = false;
      isWin = false;
      _selectedColor = null;
      generateSolution();
      guesses = List.generate(
          trys, (index) => List<Color>.filled(rowSize, Colors.transparent));
      guesses[currentGuess] = List<Color>.filled(rowSize, Colors.grey);
    });
  }

  Widget _buildDraggableColorOption(Color color) {
    return Draggable<Color>(
      data: color,
      feedback: ColorOption(
        selected: false,
        color: color,
        onTap: () {},
      ),
      childWhenDragging: ColorOption(
        color: Colors.grey,
        selected: false,
        onTap: () {},
      ),
      child: ColorOption(
        color: color,
        selected: _selectedColor == color,
        onTap: () {
          setState(() {
            if (_selectedColor != color) {
              _selectedColor = color;
            } else {
              _selectedColor = null;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mastermind'),
        actions: [
          IconButton(
              tooltip: "Clear Row",
              onPressed: () {
                setState(() {
                  for (int i = 0; i <= 4; i++) {
                    guesses[currentGuess][i] = Colors.grey;
                  }
                });
              },
              icon: const Icon(
                Icons.clear,
                size: 30,
              )),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              tooltip: "Restart Game",
              onPressed: () async {
                if (await showContinueDialog(context)) {
                  resetGame();
                }
              },
              icon: const Icon(
                Icons.replay_outlined,
                size: 30,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount:
                          finished ? max(currentGuess, 1) : currentGuess + 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return buildRow(index);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      !finished
                          ? "Try ${currentGuess + 1}/$trys"
                          : isWin
                              ? "Congratulations!"
                              : "Almost There!",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!finished)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                List<Color> randomColors = [...colors];
                                randomColors.shuffle();
                                guesses[currentGuess] =
                                    randomColors.sublist(0, rowSize);
                              });
                            },
                            label: const Text("Random Colors"),
                            icon: const Icon(Icons.shuffle),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (guesses[currentGuess].contains(Colors.grey)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 600),
                                    content: Text(
                                        'Please select a color for each dot.'),
                                  ),
                                );
                              } else {
                                checkGuess();
                              }
                            },
                            label: const Text(
                              "Check Guess",
                              style: TextStyle(color: Colors.green),
                            ),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (Color color in colors)
                        _buildDraggableColorOption(color),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
