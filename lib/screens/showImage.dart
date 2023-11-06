import 'dart:io';

import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/func/unlock.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatefulWidget {
  final String path;
  final String tag;
  const ShowImage({super.key, required this.path, required this.tag});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  bool change = true;
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPopScope(
        child: Scaffold(
          backgroundColor: change ? Colors.white : Colors.black,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  change = !change;
                }),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, bottom: 60),
                  child: Center(
                    child: Hero(
                      tag: widget.tag,
                      child: PhotoView(
                        backgroundDecoration: BoxDecoration(
                            color: change ? Colors.white : Colors.black),
                        imageProvider: Image.file(
                          File(widget.path),
                          fit: BoxFit.cover,
                        ).image,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        initialScale: PhotoViewComputedScale.contained,
                      ),
                    ),
                  ),
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
