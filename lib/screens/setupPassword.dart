// ignore_for_file: file_names

import 'dart:math';

import 'package:file_hider/constants.dart';
import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/custom/popup.dart';
import 'package:flutter/material.dart';

class SetupPassword extends StatefulWidget {
  const SetupPassword({super.key});

  @override
  State<SetupPassword> createState() => _SetupPasswordState();
}

class _SetupPasswordState extends State<SetupPassword> {
  String pattern = "$instruction\n\nTouch to create your pattern";
  bool isFirstTap = true;
  Color color = myColorCollection[2];

  void createPattern(String value) {
    if (isFirstTap) {
      pattern = "";
      isFirstTap = false;
    }

    setState(() {
      pattern += value;
      color = myColorCollection[Random().nextInt(myColorCollection.length)];
    });
  }

  void resetPattern() {
    setState(() {
      pattern = "$instruction\n\nPattern has been reset";
      isFirstTap = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => createPattern(singleTap),
              onDoubleTap: () => createPattern(doubleTap),
              onLongPress: resetPattern,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: color,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      pattern,
                      style: myStyle,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: InkWell(
                    onTap: () {
                      showMyDialog(context, isFirstTap ? "" : pattern);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text("Set Password"),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
