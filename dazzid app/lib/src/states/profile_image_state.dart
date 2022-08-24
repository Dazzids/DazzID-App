import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImage with ChangeNotifier {
  File _profileImage;
  bool _hasImage = false;

  ProfileImage();

  File get profileImage => _profileImage;
  bool get hasImage => _hasImage;

  void setProfileImage(File img) {
    _profileImage = img;
    notifyListeners();
  }

  void setHasImage(bool hasImage) => _hasImage = hasImage;
}
