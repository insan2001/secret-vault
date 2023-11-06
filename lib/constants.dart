import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Color> myColorCollection = [
  Colors.tealAccent,
  Colors.white,
  Colors.grey,
  Colors.lightGreenAccent,
  Colors.yellowAccent,
  Colors.pink,
  Colors.redAccent,
  Colors.blueAccent,
];

TextStyle myStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const String isFirst = "isFirstTime";
const String passwd = "password";
late final SharedPreferences prefs;
const String doubleTap = "+";
const String singleTap = "*";
String instruction =
    "Tap: $singleTap\nDoubleTap: $doubleTap\nLongPress: Reset password";
String? userPassword = prefs.getString(passwd);

const List<List<bool>> ticTacToeBorder = [
  // l,t,r,b
  [false, false, true, true],
  [true, false, true, true],
  [true, false, false, true],
  [false, true, true, true],
  [true, true, true, true],
  [true, true, false, true],
  [false, true, true, false],
  [true, true, true, false],
  [true, true, false, false],
];

const imageExtList = [
  ".bmp",
  ".gif",
  ".jpg",
  ".jpeg",
  ".png",
  ".webp",
  ".heic",
  ".heif",
  ".avif"
];

String interstitialTest = "ca-app-pub-3940256099942544/1033173712";
String myInterstitialAd = "ca-app-pub-9320493450035769/6742194287";
String interstitialAd = myInterstitialAd;

String appOpenTest = "ca-app-pub-3940256099942544/3419835294";
String myAppOpenAd = "ca-app-pub-9320493450035769/7936728596";
String appOpenAd = myAppOpenAd;
