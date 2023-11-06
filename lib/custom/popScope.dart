// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomPopScope extends StatelessWidget {
  final Widget child;
  const CustomPopScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: child, onWillPop: () async => false);
  }
}
