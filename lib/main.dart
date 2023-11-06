// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_hider/constants.dart';
import 'package:file_hider/func/notify.dart';
import 'package:file_hider/func/permission.dart';
import 'package:file_hider/screens/error.dart';
import 'package:file_hider/screens/fakeHome.dart';
import 'package:file_hider/screens/instruction.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

late String hiddenFolder;
late Directory hidden;

AppOpenAd? ad;

Future<void> loadAd() async {
  await AppOpenAd.load(
      adUnitId: appOpenAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        ad.show();
      }, onAdFailedToLoad: (error) {
        print("Failed to load ad. $error");
      }),
      orientation: AppOpenAd.orientationPortrait);
}

createCustomFolders() async {
  String document = (await getExternalStorageDirectory())!.path;
  hiddenFolder = path.join(document, "Documents");
  hidden = Directory(hiddenFolder);

  if (!hidden.existsSync()) {
    await hidden.create(recursive: true);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await MobileAds.instance.initialize();

  bool isSupported = await LocalAuthentication().canCheckBiometrics;
  late bool isFakePage;
  PhotoManager.clearFileCache();

  if (!(await requestPermission())) {
    exit(0);
  }

  await createCustomFolders();

  if (prefs.getString(passwd) != null) {
    isFakePage = true;
    await loadAd();
  } else {
    isFakePage = false;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GameValue()),
    ],
    child: MyApp(isSupport: isSupported, isFakePage: isFakePage),
  ));
}

class MyApp extends StatelessWidget {
  final bool isSupport;
  final bool isFakePage;
  const MyApp({super.key, required this.isSupport, required this.isFakePage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Instruction(),
      home: isSupport
          ? isFakePage
              ? const FakeHome()
              : const Instruction()
          : const NotSupport(),
    );
  }
}
