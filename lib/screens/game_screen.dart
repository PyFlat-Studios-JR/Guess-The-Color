import 'dart:math';

import 'package:flutter/material.dart';

import '../components/color_option.dart';

class MastermindGame extends StatefulWidget {
  final int trys;
  final int rowSize;
  final int colorCount;
  final bool countTogether;
  final bool uniqueColors;
  final bool isSinglePlayer;
  const MastermindGame(
      {super.key,
      required this.trys,
      required this.rowSize,
      required this.colorCount,
      required this.countTogether,
      required this.uniqueColors,
      required this.isSinglePlayer});

  @override
  MastermindGameState createState() => MastermindGameState();
}

class MastermindGameState extends State<MastermindGame> {
  late int trys;
  late int rowSize;
  List<Color> initialColors = [
    Colors.yellow, //0xffffeb3b
    Colors.amber, //0xffffc107
    Colors.orange, //0xffff9800
    Colors.orangeAccent, //0xffffab40
    Colors.deepOrange, //0xffff5722
    Colors.red, //0xfff44336
    Colors.pink, //0xffe91e63
    Colors.purple, //0xff9c27b0
    Colors.deepPurple, //0xff673ab7
    Colors.indigo, //0xff3f51b5
    Colors.blue, //0xff2196f3
    Colors.cyan, //0xff00bcd4
    Colors.teal, //0xff009688
    Colors.green, //0xff4caf50
    Colors.lightGreen, //0xff8bc34a
    Colors.lime, //0xffcddc39
    Colors.blueGrey, //0xff607d8b
    Colors.brown, //0xff795548
  ];

  List<Color> solution = [];
  List<Color> colors = [];
  List<List<Color>> guesses = [];
  List<List<int>> guessed = [];
  int currentGuess = 0;
  bool multiplayerSelectionDone = true;
  bool finished = false;
  bool isWin = false;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    trys = widget.trys;
    rowSize = widget.rowSize;

    if (!widget.isSinglePlayer) {
      multiplayerSelectionDone = false;
    }
    guessed = List.generate(trys, (index) => [0, 0]);
    guesses = List.generate(
        trys, (index) => List<Color>.filled(rowSize, Colors.transparent));
    guesses[currentGuess] = List<Color>.filled(rowSize, Colors.grey);
    generateSolution();
  }

  void generateSolution() {
    setState(() {
      colors = [...initialColors];
      List<Color> tempColors = [...colors];

      tempColors.shuffle();
      tempColors = tempColors.sublist(0, tempColors.length - widget.colorCount);
      colors.removeWhere((color) => tempColors.contains(color));

      if (widget.isSinglePlayer) {
        if (widget.uniqueColors) {
          solution = [...colors];
          solution.shuffle();
          solution = solution.sublist(0, rowSize);
        } else {
          solution = [];
          Random rng = Random();
          for (int i = 0; i < rowSize; i++) {
            solution.add(colors[rng.nextInt(colors.length)]);
          }
        }
      }
    });
  }

  void checkGuess() {
    List<Color> currentGuessList = guesses[currentGuess];
    int correctColorAndPosition = 0;
    int correctColorOnly = 0;

    var solutionColorCount = <Color, int>{};
    var guessColorCount = <Color, int>{};

    for (int i = 0; i < rowSize; i++) {
      if (currentGuessList[i] == solution[i]) {
        correctColorAndPosition++;
      } else {
        solutionColorCount[solution[i]] =
            (solutionColorCount[solution[i]] ?? 0) + 1;
        guessColorCount[currentGuessList[i]] =
            (guessColorCount[currentGuessList[i]] ?? 0) + 1;
      }
    }

    for (var color in guessColorCount.keys) {
      if (solutionColorCount.containsKey(color)) {
        correctColorOnly +=
            min(guessColorCount[color]!, solutionColorCount[color]!);
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
            const Text(
              "Correct Solution:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
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
                const SizedBox(
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
    int number;
    if (widget.countTogether && !type) {
      number = guessed[row][1] + guessed[row][0];
    } else {
      number = type ? guessed[row][0] : guessed[row][1];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "$number",
        style: TextStyle(
            fontSize: 22,
            color: currentGuess - 1 >= row
                ? type
                    ? Colors.red
                    : Colors.white
                : Colors.transparent),
      ),
    );
  }

  Widget buildColorButton(int row, int column) {
    bool draggable = false;
    if (guesses[row][column] != Colors.grey && row == currentGuess) {
      draggable = true;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: DragTarget<Map>(
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            child: Draggable<Map>(
              maxSimultaneousDrags: draggable ? null : 0,
              data: {
                "color": guesses[row][column],
                "row": row,
                "column": column
              },
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
                  color:
                      widget.uniqueColors ? Colors.grey : guesses[row][column],
                  shape: BoxShape.circle,
                ),
              ),
              ignoringFeedbackSemantics: true,
              ignoringFeedbackPointer: true,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: guesses[row][column],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            onTap: () async {
              setState(() {
                if (_selectedColor != null) {
                  if (row == currentGuess) {
                    if (widget.uniqueColors &&
                        guesses[row].contains(_selectedColor)) {
                      int idx = guesses[row].indexOf(_selectedColor!);
                      guesses[row][idx] = Colors.grey;
                    }

                    guesses[row][column] = _selectedColor!;
                  }
                  if (widget.uniqueColors) {
                    _selectedColor = null;
                  }
                } else {
                  if (row == currentGuess) {
                    guesses[row][column] = Colors.grey;
                  }
                }
              });
            },
            onLongPress: () {
              if (row == currentGuess) {
                setState(() {
                  _selectedColor = guesses[row][column];
                });
              }
            },
          );
        },
        onAcceptWithDetails: (details) {
          setState(() {
            if (row == currentGuess) {
              if (details.data["row"] != null) {
                Color oldColor = guesses[row][column];
                if (oldColor != Colors.grey) {
                  guesses[details.data["row"]][details.data["column"]] =
                      oldColor;
                }
              }
              if (widget.uniqueColors &&
                  guesses[row].contains(details.data["color"])) {
                int idx = guesses[row].indexOf(details.data["color"]);
                guesses[row][idx] = Colors.grey;
              }

              guesses[row][column] = details.data["color"];
            }
          });
        },
      ),
    );
  }

  Widget buildRow(int row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTexts(row, false),
        for (int i = 0; i < rowSize; i++) buildColorButton(row, i),
        buildTexts(row, true)
      ],
    );
  }

  void resetGame() {
    setState(() {
      currentGuess = 0;
      if (!widget.isSinglePlayer) {
        multiplayerSelectionDone = false;
      }
      finished = false;
      isWin = false;
      _selectedColor = null;
      guesses = List.generate(
          trys, (index) => List<Color>.filled(rowSize, Colors.transparent));
      guesses[currentGuess] = List<Color>.filled(rowSize, Colors.grey);
      generateSolution();
    });
  }

  Widget _buildDraggableColorOption(Color color) {
    return Draggable<Map>(
      data: {"color": color},
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
                      widget.isSinglePlayer || multiplayerSelectionDone
                          ? !finished
                              ? "Guess ${currentGuess + 1} of $trys"
                              : isWin
                                  ? "Congratulations! You won!"
                                  : "Good try! Keep going!"
                          : "Choose a combination of colors",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!finished && multiplayerSelectionDone)
                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                if (widget.uniqueColors) {
                                  List<Color> randomColors = [...colors];
                                  randomColors.shuffle();
                                  guesses[currentGuess] =
                                      randomColors.sublist(0, rowSize);
                                } else {
                                  List<Color> randomColors = [];
                                  Random rng = Random();
                                  for (int i = 0; i < rowSize; i++) {
                                    randomColors.add(
                                        colors[rng.nextInt(colors.length)]);
                                  }
                                  guesses[currentGuess] = randomColors;
                                }
                              });
                            },
                            label: const Text("Random Colors"),
                            icon: const Icon(Icons.shuffle),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (currentGuess >= 1) {
                                setState(() {
                                  guesses[currentGuess] =
                                      List.from(guesses[currentGuess - 1]);
                                });
                              }
                            },
                            label: const Text(
                              "Copy Last Row",
                            ),
                            icon: const Icon(
                              Icons.copy_rounded,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < rowSize; i++) {
                                  guesses[currentGuess][i] = Colors.grey;
                                }
                              });
                            },
                            label: const Text(
                              "Clear Row",
                              style: TextStyle(color: Colors.red),
                            ),
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
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
                    else if (!multiplayerSelectionDone)
                      ElevatedButton.icon(
                        onPressed: () {
                          if (guesses[0].contains(Colors.grey)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 600),
                                content:
                                    Text('Please select a color for each dot.'),
                              ),
                            );
                          } else {
                            setState(() {
                              solution = guesses[0];
                              guesses[0] =
                                  List<Color>.filled(rowSize, Colors.grey);
                              multiplayerSelectionDone = true;
                            });
                          }
                        },
                        label: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.green),
                        ),
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
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
