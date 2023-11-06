// ignore_for_file: curly_braces_in_flow_control_structures, file_names

import 'dart:io';

import 'package:file_hider/constants.dart';
import 'package:file_hider/custom/game.dart';
import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/func/imageList.dart';
import 'package:file_hider/func/notify.dart';
import 'package:file_hider/screens/home.dart';
import 'package:file_hider/screens/setupPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class FakeHome extends StatefulWidget {
  const FakeHome({super.key});

  @override
  State<FakeHome> createState() => _FakeHomeState();
}

class _FakeHomeState extends State<FakeHome> {
  late LocalAuthentication auth;
  late List<FileSystemEntity> myImages;
  final myKey = GlobalKey<GameState>();

  bool isOwner = false;
  bool login = false;
  String userEnter = "";

  void authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Unlock your vault",
        options: const AuthenticationOptions(stickyAuth: true),
      );
      if (authenticated)
        setState(() {
          isOwner = true;
        });
    } on PlatformException catch (_) {}
  }

  void match(String char) async {
    userEnter += char;
    if (userEnter == userPassword) {
      myImages = await myImageList();
      setState(() {
        login = true;
      });
    } else
      setState(() {
        userEnter;
      });
  }

  void reset() {
    setState(() {
      userEnter = "";
    });
  }

  void change() async {
    match(singleTap);
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return isOwner
        ? const SetupPassword()
        : login
            ? Home(hasPasswd: true, imageList: myImages)
            : SafeArea(
                child: CustomPopScope(
                  child: Scaffold(
                    body: Container(
                      color: Colors.grey,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 80, left: 20),
                              child: IconButton(
                                iconSize: 48,
                                onPressed: () => setState(() {
                                  myKey.currentState!.reset();
                                }),
                                icon: const Icon(Icons.restart_alt),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Text(userEnter)),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, top: 80),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              child: Game(key: myKey),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(top: 80, right: 20),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onLongPress: reset, // reset the input
                                onHorizontalDragEnd: (_) =>
                                    authenticate(), // for authenticate
                                onTap: change,
                                // onTap: () async => myImageList(),
                                onDoubleTap: () => match(doubleTap),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blueGrey,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      const Spacer(),
                                      Text(
                                        "Win",
                                        style: myStyle,
                                      ),
                                      Text(
                                        context
                                            .watch<GameValue>()
                                            .wins
                                            .toString(),
                                        style: myStyle,
                                      ),
                                      const Spacer(),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
