import 'dart:io';

import 'package:dazz/constants.dart';
import 'package:dazz/src/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageFirebaseProvider {
  Future<String> getImageURL(String path) async {
    return await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    // final StorageReference _reference = FirebaseStorage().ref().child(path);
    // return await _reference.getDownloadURL();
  }

  Future<String> uploadImages(File image, UserModel user) async {
    String path = "$profileImagePath/${user.uID}/profile.jpg";

    try {
      await firebase_storage.FirebaseStorage.instance.ref(path).putFile(image);
      return path;
    } on firebase_storage.FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }
}
