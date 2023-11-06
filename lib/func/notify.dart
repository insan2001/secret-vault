import 'package:flutter/material.dart';

class GameValue extends ChangeNotifier {
  int wins = 0;

  void hasWon() {
    wins += 1;
    notifyListeners();
  }
}
