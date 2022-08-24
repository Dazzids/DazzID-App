import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/home_page.dart';
import 'package:dazz/src/pages/client_pages/user_info_page.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:flutter/material.dart';

class PreCredentialDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserService _userService = UserService();

    return StreamBuilder<DocumentSnapshot>(
      stream: _userService.getUserInfo(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errpr'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        UserModel user = UserModel.fromSnapshot(snapshot.data);

        if (snapshot.hasData && user.basicInfoCompleted) {
          return HomePage(
            userModel: user,
          );
        }

        if (snapshot.hasData && !user.basicInfoCompleted) {
          return UserInfoPage(
            user: user,
          );
        }

        return Center(
          child: Text('aa'),
        );
      },
    );
  }
}
