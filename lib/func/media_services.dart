import 'package:file_hider/main.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  Future<List<AssetPathEntity>> loadAlbum(RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if (permission.isAuth == true) {
      albumList = await PhotoManager.getAssetPathList(
        type: requestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future<List<AssetPathEntity>> loadAlbumFromLocation() async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if (permission.isAuth == true) {
      albumList = await PhotoManager.getAssetPathList(
          type: RequestType.common,
          filterOption: CustomFilter.sql(where: hiddenFolder));
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future<List<AssetEntity>> loadAsset(AssetPathEntity selectedAlbum) async {
    return await selectedAlbum.getAssetListRange(
        start: 0, end: await selectedAlbum.assetCountAsync);
  }
}
