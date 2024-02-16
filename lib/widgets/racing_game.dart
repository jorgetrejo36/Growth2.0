import 'dart:math';
import 'package:explore/widgets/racing_themes.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/screens/game_result_screen.dart';
import 'package:flutter/services.dart';

/// Creates instance of mining game given a specified theme and problem generator
class RacingGame extends StatefulWidget {
  final String planet;
  final ProblemGenerator racingProblem;
  const RacingGame(
      {super.key, required this.planet, required this.racingProblem});

  @override
  State<RacingGame> createState() => _RacingGameState();
}

class _RacingGameState extends State<RacingGame>
    with SingleTickerProviderStateMixin {
  // Theme Variables
  late RacingTheme theme = RacingTheme(widget.planet);

  // Problem Variable Initialization
  late GeneratedProblem problem1 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem2 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem3 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem4 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem5 = widget.racingProblem.generateProblem();

  // List of problem objects to reference
  late List<GeneratedProblem> problemList = [
    problem1,
    problem2,
    problem3,
    problem4,
    problem5,
  ];

  late List<MiningRow> miningRowList = [
    MiningRow(theme: this.theme, problem: problem1, update: _updateQuestion)
  ];

  List<bool> problemVisibility = [false, false, false, false, false];
  int currentProblem = 0;

  // Player variables
  int score = 0;
  bool correct = false;

  // Pushes game results screen to user
  // Todo: Send game data to second screen
  void gameFinish() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameResultScreen(),
        ));
  }

  // Displays the problem in the list to the game
  void newQuestion(int problemNum) {
    setState(() {
      miningRowList.add(MiningRow(
          theme: theme,
          problem: problemList[problemNum],
          update: _updateQuestion));
    });
  }

  // Iterates problem list by one, then deicdes to either end game or update the question
  _updateQuestion(int level) {
    if (level == 0) {
      displayIncorrect();
    } else if (level == 1) {
      displayCorrect();
      setState(() {
        currentProblem = currentProblem + level;
        score++;
        //correct = false;
        if (currentProblem < 5) {
          newQuestion(currentProblem);
        } else {
          gameFinish();
        }
      });
    }
  }

  displayCorrect() {
    setState(() {
      correct = true;
    });
    repeatOnce();
  }

  displayIncorrect() {
    setState(() {
      correct = false;
    });
    repeatOnce();
  }

  // Correctness Animations
  double startingOpacity = 0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  @override
  void initState() {
    super.initState();
    //repeatOnce();
  }

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xfff6f6f6),
            size: 35,
          ),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/${theme.racingStart}.png"),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/${theme.background}.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(children: [
                // Game Info
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Equation and Solutions
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.2,
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(239, 248, 248, 248),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    color: Color.fromARGB(239, 248, 248, 248),
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  height: 75,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    color: Color.fromARGB(239, 248, 248, 248),
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  height: 75,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    color: Color.fromARGB(239, 248, 248, 248),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Leaderboard
                      Container(
                        child: Column(children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.black,
                                child: Text(
                                  "1.",
                                  style: TextStyle(
                                      color: Color.fromARGB(239, 248, 248, 248),
                                      fontSize: 48,
                                      fontFamily: 'Fredoka'),
                                ),
                              ),
                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/alien.svg',
                                  height: 50,
                                  semanticsLabel: "bubble",
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Text(
                              "2.",
                              style: TextStyle(
                                  color: Color.fromARGB(239, 248, 248, 248),
                                  fontSize: 48,
                                  fontFamily: 'Fredoka'),
                            ),
                          ),
                          Container(
                            child: Text(
                              "3.",
                              style: TextStyle(
                                  color: Color.fromARGB(238, 241, 166, 166),
                                  fontSize: 48,
                                  fontFamily: 'Fredoka'),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
                // Player Tracks
                Container(
                  child: Column(
                    children: [Container(), Container(), Container()],
                  ),
                )
              ])));
}

/// Builds a clickable row of mining objects with given problem data
class MiningRow extends StatefulWidget {
  final RacingTheme theme;
  final GeneratedProblem problem;
  final ValueChanged<int> update;

  const MiningRow(
      {super.key,
      required this.theme,
      required this.problem,
      required this.update});

  @override
  State<MiningRow> createState() => _MiningRowState();
}

class _MiningRowState extends State<MiningRow> {
  late RowData row = RowData(
    widget.theme,
    widget.problem.answerChoices.getAnswers(),
    widget.problem.answerChoices.getAnswers()[0],
  );

  void selectAnswer(int rowNumber) {
    setState(() {
      row.showNumber[rowNumber] = false;
      row.selected[rowNumber] = true;

      if (row.rowChoices[rowNumber] == row.solution) {
        //row.rowImages[rowNumber] = row.currentTheme.miningCurrency;
        row.rowRotation[rowNumber] = 0;

        row.showNumber[0] = false;
        row.showNumber[1] = false;
        row.showNumber[2] = false;

        widget.update(1);
      } else {
        widget.update(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.127,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (row.showNumber[0] == true) {
                selectAnswer(0);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: AnimatedCrossFade(
                firstChild: Stack(
                  children: [
                    Transform.rotate(
                      angle: row.rowRotation[0],
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/${row.rowImages[0]}.svg',
                            height: 80,
                            width: 25,
                            semanticsLabel: "bubble",
                          ),
                        ),
                      ),
                    ),
                    if (row.showNumber[0])
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.height * 0.1,
                        //decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: StrokeText(
                            text: " ${row.rowChoices[0]} ",
                            textStyle: TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Fredoka',
                                fontSize: 42),
                            strokeColor: AppColors.darkGrey,
                            strokeWidth: 6.5,
                          ),
                        ),
                      )
                  ],
                ),
                secondChild: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.currentTheme.enemyVehicle}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
                crossFadeState:
                    !(row.selected[0] && (row.rowChoices[0] == row.solution))
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (row.showNumber[1] == true) {
                selectAnswer(1);
              }
            },
            child: AnimatedCrossFade(
              firstChild: Stack(
                children: [
                  Transform.rotate(
                    angle: row.rowRotation[1],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: SvgPicture.asset(
                        'assets/images/${row.rowImages[0]}.svg',
                        height: 80,
                        width: 25,
                        semanticsLabel: "bubble",
                      ),
                    ),
                  ),
                  if (row.showNumber[1])
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.height * 0.1,
                      //decoration: BoxDecoration(color: Colors.red),
                      child: Center(
                        child: StrokeText(
                          text: " ${row.rowChoices[1]} ",
                          textStyle: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Fredoka',
                              fontSize: 42),
                          strokeColor: AppColors.darkGrey,
                          strokeWidth: 6.5,
                        ),
                      ),
                    )
                ],
              ),
              secondChild: Container(
                width: MediaQuery.of(context).size.width * 0.33,
                child: SvgPicture.asset(
                  'assets/images/${row.currentTheme.enemyVehicle}.svg',
                  height: 80,
                  width: 25,
                  semanticsLabel: "bubble",
                ),
              ),
              crossFadeState:
                  !(row.selected[1] && (row.rowChoices[1] == row.solution))
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 500),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (row.showNumber[2] == true) {
                selectAnswer(2);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 25),
              child: AnimatedCrossFade(
                firstChild: Stack(
                  children: [
                    Transform.rotate(
                      angle: row.rowRotation[2],
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: SvgPicture.asset(
                          'assets/images/${row.rowImages[2]}.svg',
                          height: 78,
                          width: 25,
                          semanticsLabel: "bubble",
                        ),
                      ),
                    ),
                    if (row.showNumber[2])
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.height * 0.1,
                        //decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: StrokeText(
                            text: " ${row.rowChoices[2]} ",
                            textStyle: TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Fredoka',
                                fontSize: 42),
                            strokeColor: AppColors.darkGrey,
                            strokeWidth: 6.5,
                          ),
                        ),
                      )
                  ],
                ),
                secondChild: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.currentTheme.enemyVehicle}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
                crossFadeState:
                    !(row.selected[2] && (row.rowChoices[2] == row.solution))
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Manages data in a given row. Includes theme, visibility, and problem data
class RowData {
  static double randomSeed = Random().nextDouble() * 360;
  List<double> rowRotation = [
    270 + randomSeed,
    90 + randomSeed,
    180 + randomSeed
  ];

  List<bool> showNumber = [true, true, true];
  List<bool> selected = [false, false, false];
  late String reward;
  late int solution;
  late List<String> rowImages;
  late List<int> rowChoices;
  late RacingTheme currentTheme;

  RowData(theme, choices, answer) {
    currentTheme = theme;
    rowImages = [
      "${currentTheme.enemyVehicle}",
      "${currentTheme.enemyVehicle}",
      "${currentTheme.enemyVehicle}"
    ];
    rowChoices = choices;
    reward = "${currentTheme.enemyVehicle}";
    solution = answer;

    rowChoices.shuffle();
  }
}
