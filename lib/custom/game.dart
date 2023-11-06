import 'dart:math';

import 'package:file_hider/constants.dart';
import 'package:file_hider/custom/tictactoe.dart';
import 'package:file_hider/custom/win.dart';
import 'package:file_hider/func/notify.dart';
import 'package:file_hider/func/win_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double borderWidth = 1.5;
const Color borderColor = Colors.black;
const Color containerBgColor = Color.fromARGB(255, 37, 39, 41);
const Color onTapColor = Colors.black;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {
  List<String> value = List.generate(9, (index) => "");
  String player = "O";
  String bot = "X";

  reset() => setState(() {
        value = List.generate(9, (_) => "");
      });

  winText(String text) => gameWonDialog(context, text).then((_) => reset());

  void botTurn() {
    int num = Random().nextInt(9);
    while (value[num] != "") {
      num = Random().nextInt(9);
    }
    setState(() {
      value[num] = bot;
    });
    bool win = winChecker(value);
    if (win) {
      winText("Bot has");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            if (value[index] == "") {
              setState(() {
                value[index] = player;
              });
            } else {
              return;
            }

            bool win = winChecker(value);

            if (!value.contains("") && !win) {
              winText("Nobody has");
              return;
            }

            if (!win) {
              botTurn();
            } else {
              winText("You have");
              Provider.of<GameValue>(context, listen: false).hasWon();
            }
          },
          child: TicTacToe(
            bgColor: Colors.transparent,
            borderColor: Colors.black,
            borderWidth: borderWidth,
            borderBool: ticTacToeBorder[index],
            child: Center(
              child: Opacity(
                opacity: 1,
                child: Text(
                  value[index],
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: value[index] == bot ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
