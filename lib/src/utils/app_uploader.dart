import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:internal_core/internal_core.dart';

class AppUploaderFireStorage {
  static Future<String> uploadFile({
    required File data,
    required String path,
    required String userId,
    SettableMetadata? meta,
    Function(TaskSnapshot)? onUploading,
  }) async {
    appDebugPrint("AppUploader started");
    // File name
    String assetName =
        '${userId}_${DateTime.now().millisecondsSinceEpoch.toString()}';

    appDebugPrint("AppUploader Upload file");
    // Upload file
    final UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('$path/$assetName')
        .putFile(data, meta);
    if (onUploading != null) {
      uploadTask.snapshotEvents.listen(onUploading);
    }
    final TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    appDebugPrint("AppUploader Upload file done url=$url");
    return url;
  }

  static Future<String> uploadFileData({
    required Uint8List data,
    String? path,
    String? fileName,
    Reference? ref,
    bool isNeedCompress = false,
    SettableMetadata? meta,
    Function(TaskSnapshot)? onUploading,
  }) async {
    appDebugPrint("AppUploader started");
    // File name
    String assetName =
        '${fileName ?? ""}_${DateTime.now().millisecondsSinceEpoch.toString()}';

    String refPath = "";
    if (path != null) {
      refPath = path;
    }
    refPath += "/$assetName";

    if (isNeedCompress &&
        (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
      appDebugPrint("AppUploader Compressing");
      data = await FlutterImageCompress.compressWithList(data,
          minWidth: 600, minHeight: 600);
      appDebugPrint("AppUploader Compressed");
    }

    appDebugPrint("AppUploader Upload file");
    // Upload file
    final UploadTask uploadTask = (ref ?? FirebaseStorage.instance.ref())
        .child(refPath)
        .putData(data, meta);
    if (onUploading != null) {
      uploadTask.snapshotEvents.listen(onUploading);
    }
    final TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    appDebugPrint("AppUploader Upload file done url=$url");
    return url;
  }
}
