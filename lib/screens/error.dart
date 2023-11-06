import 'package:file_hider/custom/popScope.dart';
import 'package:flutter/material.dart';

class NotSupport extends StatelessWidget {
  const NotSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPopScope(
      child:
          Scaffold(body: Center(child: Text("Your device is not supported"))),
    );
  }
}
