import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/func/unlock.dart';
import 'package:flutter/material.dart';

class MyVideoPlayer extends StatefulWidget {
  final String path;
  final String tag;
  const MyVideoPlayer({super.key, required this.path, required this.tag});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool tap = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPopScope(
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: Hero(
                  tag: "video${widget.tag}",
                  child: CustomVideoPlayer(
                      customVideoPlayerController:
                          _customVideoPlayerController),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 80),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: IconButton(
                      onPressed: () {
                        unlockDocument(widget.path).then(
                            (imageList) => Navigator.pop(context, imageList));
                      },
                      icon: const Icon(
                        Icons.lock_open,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
