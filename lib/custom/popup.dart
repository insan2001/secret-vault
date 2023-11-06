import 'package:file_hider/constants.dart';
import 'package:file_hider/screens/fakeHome.dart';
import 'package:flutter/material.dart';

Future<void> showMyDialog(BuildContext context, String pattern) async {
  bool hasPattern = pattern != "" && pattern.length > 3;
  late String title;
  late String body;
  if (hasPattern) {
    title = 'Setup pattern';
    body = 'Do you like to set this as your pattern?';
  } else {
    title = "Invalid password";
    body = "Your password should have atleast 4 taps";
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: hasPattern && pattern.length >= 4
            ? <Widget>[
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    prefs.setString(passwd, pattern).then((_) {
                      userPassword = pattern;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const FakeHome()));
                    });
                  },
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]
            : <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
      );
    },
  );
}
