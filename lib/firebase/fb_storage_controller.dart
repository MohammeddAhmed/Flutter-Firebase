import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vp18_firebase/firebase/fb_helper.dart';
import 'package:vp18_firebase/models/process_response.dart';

class FbStorageController with FbHelper {
  /// * Operations : CRUD
  ///    1) Upload => U
  ///    2) Read   => R
  ///    3) Delete => D

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UploadTask upload(String path) {
    return firebaseStorage
        .ref("images/image_${DateTime.now().microsecondsSinceEpoch}")
        .putFile(File(path));
  }

  Future<List<Reference>> read() async {
    ListResult listResult = await firebaseStorage.ref("images").listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }

  Future<ProcessResponse> delete(String path) async {
    return firebaseStorage
        .ref(path)
        .delete()
        .then((value) => getResponse("Image deleted successfully"))
        .catchError((error) => getResponse("Image delete failed", false));
  }
}
