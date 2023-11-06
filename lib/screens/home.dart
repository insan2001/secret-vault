import 'dart:io';

import 'package:file_hider/constants.dart';
import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/screens/setupPassword.dart';
import 'package:file_hider/func/unlock.dart';
import 'package:file_hider/main.dart';
import 'package:file_hider/screens/fakeHome.dart';
import 'package:file_hider/screens/showImage.dart';
import 'package:file_hider/screens/mediaPicker.dart';
import 'package:file_hider/screens/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';

class Home extends StatefulWidget {
  final bool hasPasswd;
  final List<FileSystemEntity> imageList;
  const Home({super.key, required this.hasPasswd, required this.imageList});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<FileSystemEntity> imageList;
  List<FileSystemEntity> selectedImages = [];
  bool unlock = false;

  InterstitialAd? ad;

  void pickImage() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MediaPicker(requestType: RequestType.common);
      })).then((result) async {
        if (result.isNotEmpty) {
          List<FileSystemEntity> newImageList = [];
          for (int i = 0; i < result.length; i++) {
            // original details
            File? myfile = await result[i].originFile;
            String? fileName = result[i].title;
            // alter to move
            String newPath = path.join(hiddenFolder, fileName);

            // move
            await myfile?.copy(newPath);

            // delete original
            myfile!.deleteSync();

            newImageList.add(File(newPath));
          }

          showAd();
          setState(() {
            imageList = [...imageList, ...newImageList];
          });
        }
      });

  Future<String?> getThumbnail(String path) async {
    return VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );
  }

  cancel() {
    if (imageList.isEmpty) {
      setState(() {
        unlock = false;
      });
    }
  }

  unlockImages() async {
    if (selectedImages != []) {
      for (int i = 0; i < selectedImages.length; i++) {
        unlockDocument(selectedImages[i].path);
        setState(() {
          imageList.remove(selectedImages[i]);
          selectedImages.remove(selectedImages[i]);
        });
      }
      cancel();
    }
  }

  InterstitialAd? createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ads) {
          ad = ads;
        }, onAdFailedToLoad: (LoadAdError error) {
          ad = null;
        }));
    return ad;
  }

  showAd() {
    InterstitialAd? myAd = createInterstitialAd();
    if (myAd != null) {
      myAd.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        myAd!.dispose();
        myAd = createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        myAd!.dispose();
        myAd = createInterstitialAd();
      });
      myAd!.show();
      myAd = null;
    }
  }

  @override
  void initState() {
    setState(() {
      imageList = widget.imageList;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: const Text("Secreat vault"),
            leading: IconButton(
                onPressed: () {
                  showAd();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FakeHome()));
                },
                icon: const Icon(Icons.arrow_back)),
            actions: [
              unlock
                  ? IconButton(
                      onPressed: () => setState(() {
                            unlock = !unlock;
                            selectedImages = [];
                          }),
                      icon: const Icon(Icons.cancel_outlined))
                  : IconButton(
                      onPressed: () => setState(() {
                            unlock = !unlock;
                          }),
                      icon: const Icon(Icons.lock_open))
            ],
          ),
          body: widget.hasPasswd
              ? Center(
                  child: Container(
                    child: imageList.isEmpty
                        ? const Text(
                            "Currently you don't have any files to show.",
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: imageList.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                bool isImage = imageExtList.contains(
                                    path.extension(imageList[index].path));

                                return Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              10,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              10,
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              child: isImage
                                                  ? InkWell(
                                                      onTap: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ShowImage(
                                                            path:
                                                                imageList[index]
                                                                    .path,
                                                            tag: index
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        if (value == null) {
                                                          return;
                                                        }
                                                        showAd();
                                                        setState(() {
                                                          imageList = value;
                                                          selectedImages = [];
                                                          unlock = false;
                                                        });
                                                        cancel();
                                                      }),
                                                      child: Hero(
                                                        tag: index.toString(),
                                                        child: Image.file(
                                                          File(imageList[index]
                                                              .path),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : FutureBuilder(
                                                      future: getThumbnail(
                                                          imageList[index]
                                                              .path),
                                                      builder: (context, snap) {
                                                        if (snap.connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator
                                                                    .adaptive(),
                                                          );
                                                        } else if (snap
                                                            .hasData) {
                                                          return Stack(
                                                            children: [
                                                              Positioned.fill(
                                                                child: InkWell(
                                                                  onTap: () =>
                                                                      Navigator
                                                                          .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MyVideoPlayer(
                                                                        path: imageList[index]
                                                                            .path,
                                                                        tag: index
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                  ).then((value) {
                                                                    if (value ==
                                                                        null) {
                                                                      return;
                                                                    }
                                                                    showAd();
                                                                    if (value !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        imageList =
                                                                            value;
                                                                        selectedImages =
                                                                            [];
                                                                        unlock =
                                                                            false;
                                                                      });
                                                                      cancel();
                                                                    }
                                                                  }),
                                                                  child: Center(
                                                                    child: Hero(
                                                                      tag:
                                                                          "video${index.toString()}",
                                                                      child: Image
                                                                          .file(
                                                                        File(snap
                                                                            .data!),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child: Icon(
                                                                    Icons
                                                                        .videocam,
                                                                    color: Colors
                                                                        .blueAccent,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return const Icon(
                                                            Icons.videocam,
                                                            color: Colors.blue,
                                                          );
                                                        }
                                                      })),
                                        ),
                                      ),
                                      unlock
                                          ? Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (selectedImages
                                                          .contains(imageList[
                                                              index])) {
                                                        selectedImages.remove(
                                                            imageList[index]);
                                                      } else {
                                                        selectedImages.add(
                                                            imageList[index]);
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 7),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: selectedImages
                                                                .contains(
                                                                    imageList[
                                                                        index])
                                                            ? Colors.blue
                                                            : Colors.black12,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${selectedImages.indexOf(imageList[index]) + 1}",
                                                          style: TextStyle(
                                                            color: selectedImages
                                                                    .contains(
                                                                        imageList[
                                                                            index])
                                                                ? Colors.white
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                )
              : const SetupPassword(),
          floatingActionButton: unlock
              ? Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: IconButton(
                    onPressed: unlockImages,
                    icon: const Icon(Icons.lock_open),
                    color: Colors.blue,
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: IconButton(
                    onPressed: pickImage,
                    icon: const Icon(Icons.add),
                    color: Colors.blue,
                  ),
                ),
        ),
      ),
    );
  }
}
