// ignore_for_file: file_names

import 'package:file_hider/custom/popScope.dart';
import 'package:file_hider/func/media_services.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPicker extends StatefulWidget {
  final RequestType requestType;
  const MediaPicker({super.key, required this.requestType});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];

  @override
  void initState() {
    MediaServices().loadAlbum(widget.requestType).then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAsset(selectedAlbum!).then((value) {
        if (!mounted) return;
        setState(() {
          assetList = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton<AssetPathEntity>(
                  value: selectedAlbum,
                  elevation: 10,
                  dropdownColor: Colors.orangeAccent,
                  onChanged: (AssetPathEntity? value) {
                    setState(() {
                      selectedAlbum = value;
                    });
                    MediaServices().loadAsset(selectedAlbum!).then((value) {
                      setState(() {
                        assetList = value;
                      });
                    });
                  },
                  items: albumList.map<DropdownMenuItem<AssetPathEntity>>(
                      (AssetPathEntity album) {
                    return DropdownMenuItem<AssetPathEntity>(
                      value: album,
                      child: Text(album.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, selectedAssetList);
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                    )),
              )
            ],
          ),
          body: assetList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  itemCount: assetList.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    AssetEntity assetEntity = assetList[index];
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: assetWidget(assetEntity),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity) => Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(
                  selectedAssetList.contains(assetEntity) ? 15 : 0),
              child: AssetEntityImage(
                assetEntity,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(250),
                fit: BoxFit.cover,
                errorBuilder: (_, w, e) => const Center(
                    child: Icon(
                  Icons.error,
                  color: Colors.red,
                )),
              ),
            ),
          ),
          if (assetEntity.type == AssetType.video)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.videocam,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                selectAsset(assetEntity);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedAssetList.contains(assetEntity)
                        ? Colors.blue
                        : Colors.black12,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "${selectedAssetList.indexOf(assetEntity) + 1}",
                      style: TextStyle(
                        color: selectedAssetList.contains(assetEntity)
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ))
        ],
      );

  void selectAsset(AssetEntity assetEntity) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else {
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }
}
