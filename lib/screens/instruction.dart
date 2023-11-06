import 'package:file_hider/constants.dart';
import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/screens/setupPassword.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Instruction extends StatelessWidget {
  const Instruction({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomPopScope(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: 'Hide files under a game.',
                body:
                    'This vault is design to hide your private images and videos under a game.',
                image: buildImage('assets/intro/iconPlayStore.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Password input field',
                body:
                    'This is your password input field. You need to enter your password by tapping on this to unlock your vault. When an unknown person open this app they never know this is a vault and they coudn\'t find the password input field.',
                image: buildImage('assets/intro/passwordField.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Input password',
                body:
                    'It\'s very simple. Just Tap and Double Tap to set your password.\n\n$instruction',
                image: buildImage('assets/intro/touch.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'See your password',
                body:
                    'You can see your password while you enter it. But for others it\'s hard to notice.',
                image: buildImage('assets/intro/showPassword.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Forgot password?',
                body:
                    'Just swipe over your password input field. Input your phone password and reset your password. :)',
                image: buildImage('assets/intro/forgot.png'),
                decoration: getPageDecoration(),
              ),
            ],
            done: const Text('Set password',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.amber)),
            onDone: () => goToHome(context),
            showSkipButton: true,
            skip: const Text(
              'Skip',
              style: TextStyle(color: Colors.amber),
            ),
            onSkip: () => goToHome(context),
            next: const Text(
              "Next",
              style: TextStyle(color: Colors.amber),
            ),
            dotsDecorator: getDotDecoration(),
            globalBackgroundColor: Colors.blueGrey,

            nextFlex: 1,
            // isProgressTap: false,
            // isProgress: false,
            // showNextButton: false,
            // freeze: true,
            // animationDuration: 1000,
          ),
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SetupPassword()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.black,
        activeColor: Colors.amber,
        size: const Size(10, 10),
        activeSize: const Size(16, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
        bodyTextStyle: const TextStyle(fontSize: 20, color: Colors.blueGrey),
        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
