import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/request_credentials.dart';
import 'package:dazz/src/models/request_documents.dart';
import 'package:dazz/src/models/shared_credential.dart';
import 'package:dazz/src/models/shared_document.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/profile_image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference _documentReference;
  CredentialService _credentialService;

  UserService() {
    this._documentReference = FirebaseFirestore.instance
        .collection('/users')
        .doc(_auth.currentUser.uid);
  }

  // ignore: non_constant_identifier_names
  UserService.UserService() {
    this._documentReference = FirebaseFirestore.instance
        .collection('/users')
        .doc(_auth.currentUser.uid);

    _documentReference
        .set({'created_at': DateTime.now()}, SetOptions(merge: true))
        .then((value) => print("'created_at' merged with existing data"))
        .catchError((error) => print("Failed to merge data: $error"));

    _credentialService = new CredentialService.CredentialService();
  }

  Future<void> updateDisplayNameAndType(
      String displayName, String type, String email) async {
    if (displayName == null || type == null) {
      return null;
    }

    return await this._documentReference.update(
        {"display_name": displayName, "account_type": type, "email": email});
  }

  Stream<DocumentSnapshot> getUserInfo() {
    try {
      return this._documentReference.snapshots();
    } catch (e) {
      throw e;
    }
    //return UserModel.fromSnapshot(snap.); // await this._documentReference.get();
  }

  Future<void> serUserInfo(UserModel user, [File profileImage]) async {
    String profileImagePath = user.profileImage;
    if (profileImage != null) {
      ImageFirebaseProvider _imageProvider = ImageFirebaseProvider();
      profileImagePath = await _imageProvider.uploadImages(profileImage, user);
      profileImagePath = await _imageProvider.getImageURL(profileImagePath);
    }

    var data = {
      "names": user.names,
      "last_name": user.lastName,
      "m_last_name": user.mLastName,
      "curp": user.curp,
      "rfc": user.rfc,
      "age": user.age,
      "birth": user.birth,
      "photo_url": profileImagePath,
      "basic_info_completed": user.basicInfoCompleted
    };

    return await this._documentReference.update(data);
  }

  Future<List<RequestCredential>> getsharedCredentials(
      UserModel userModel) async {
    try {
      List<String> owners = [];
      List<SharedCredential> sharedCredentials = [];
      List<RequestCredential> request = [];

      var a = await FirebaseFirestore.instance
          .collection('shared_credentials')
          .where('invite', isEqualTo: userModel.uID)
          .get();

      a.docs.forEach((element) {
        SharedCredential s = new SharedCredential();
        s.active = element.data()["active"];
        s.invite = element.data()["invite"];
        s.type = element.data()["type"];
        s.owner = element.data()["owner"];
        s.sharedAt = (element.data()["shared_at"] as Timestamp).toDate();
        s.ownerName = element.data()["owner_name"];

        sharedCredentials.add(s);
        userModel.sharedCredentials.add(s);
      });

      owners = sharedCredentials.map((e) => e.owner).toSet().toList();

      //await Future.delayed(Duration(seconds: 3));

      sharedCredentials.forEach((element) {
        int size = request.length;
        RequestCredential rq;

        if (size > 0) {
          rq = request.firstWhere((f) => f.owner == element.owner,
              orElse: () => null);
        }

        if (size == 0 || rq == null) {
          RequestCredential r = RequestCredential(
              invite: element.invite,
              owner: element.owner,
              ownerName: element.ownerName);
          r.credentialTypes.add(element.type);

          request.add(r);
        } else if (rq != null) {
          rq.credentialTypes.add(element.type);
          //int index = userModel.requestCredentials.indexOf(rq);
          // userModel.requestCredentials[index].credentialTypes.add(element.type);
        }
      });

      return request;
    } catch (e) {
      return null;
    }
  }

  Future<List<RequestDocument>> getsharedDocuments(UserModel userModel) async {
    try {
      List<String> owners = [];
      List<SharedDocument> sharedDocuments = [];
      List<RequestDocument> request = [];

      var a = await FirebaseFirestore.instance
          .collection('shared_documents')
          .where('invite', isEqualTo: userModel.uID)
          .get();

      a.docs.forEach((element) {
        SharedDocument s = new SharedDocument();
        s.active = element.data()["active"];
        s.invite = element.data()["invite"];
        s.documentName = element.data()["document_name"];
        s.owner = element.data()["owner"];
        s.sharedAt = (element.data()["shared_at"] as Timestamp).toDate();
        s.ownerName = element.data()["owner_name"];
        s.url = element.data()["url"];

        sharedDocuments.add(s);
        userModel.sharedDocuments.add(s);
      });

      owners = sharedDocuments.map((e) => e.owner).toSet().toList();

      //await Future.delayed(Duration(seconds: 3));

      sharedDocuments.forEach((element) {
        int size = request.length;
        RequestDocument rq;

        if (size > 0) {
          rq = request.firstWhere((f) => f.owner == element.owner,
              orElse: () => null);
        }

        if (size == 0 || rq == null) {
          RequestDocument r = RequestDocument(
              invite: element.invite,
              owner: element.owner,
              ownerName: element.ownerName);
          r.documents.add(element.documentName);
          r.sharedDocuments.add(element);

          request.add(r);
        } else if (rq != null) {
          rq.documents.add(element.documentName);
          rq.sharedDocuments.add(element);
          //int index = userModel.requestCredentials.indexOf(rq);
          // userModel.requestCredentials[index].credentialTypes.add(element.type);
        }
      });

      return request;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getOwnerInfo(String uid) async {
    var user =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();
    return UserModel.fromSnapshot(user);
  }

  Stream<QuerySnapshot> getUsersSharedCredential(String uid) {
    List<String> inviteName = [];

    var result = FirebaseFirestore.instance
        .collection('shared_credentials')
        .where('owner', isEqualTo: uid)
        .snapshots();

    // result.docs.forEach((element) {
    //   inviteName.add(element.data()["invite_name"]);
    // });

    return result;
  }

  Future<List<UserModel>> getCredentialValidators(
      Credential credencial, String owner) async {
    List<UserModel> users = [];

    var result = await FirebaseFirestore.instance
        .collection('credentials')
        .doc(owner)
        .collection(credencial.type)
        .doc('data')
        .get();

    var validators = result.data()["validators"] != null
        ? List.from(result.data()["validators"])
        : [];

    for (var item in validators) {
      var i =
          await FirebaseFirestore.instance.collection('users').doc(item).get();
      var u = UserModel.fromSnapshot(i);
      users.add(u);
    }

    return users;
  }

  Future<String> getPublicKeyMP() async {
    var doc = await FirebaseFirestore.instance
        .collection('configurations')
        .doc('constants')
        .get();
    var publicKey = (doc.data() as Map)["public_key_mp"];

    return publicKey;
  }
}
