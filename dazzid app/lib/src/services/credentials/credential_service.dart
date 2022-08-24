import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CredentialService {
  //final User user;
  FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference _documentReference;

  CredentialService() {
    this._documentReference = FirebaseFirestore.instance
        .collection('/credentials')
        .doc(_auth.currentUser.uid);
  }

  CredentialService.CredentialService() {
    this._documentReference = FirebaseFirestore.instance
        .collection('/credentials')
        .doc(_auth.currentUser.uid);

    _documentReference
        .set({'created_at': DateTime.now(), 'active': true},
            SetOptions(merge: true))
        .then((value) => print("'created_at' merged with existing data"))
        .catchError((error) => print("Failed to merge data: $error"));

    getAllUserCredentialsInit(_documentReference, _auth.currentUser.uid);
  }

  get snap => null;

  Future<void> getAllUserCredentialsInit(
      DocumentReference doc, String uid) async {
    try {
      var academic = await _documentReference
          .collection('/academic')
          .doc('data')
          .set({
            'created_at': DateTime.now(),
            'verified': false,
            'type': 'academic'
          }, SetOptions(merge: true))
          .then((value) => print("'created_at' merged with existing data"))
          .catchError((error) => print("Failed to merge data: $error"));

      var personal = await _documentReference
          .collection('/personal')
          .doc('data')
          .set({
            'created_at': DateTime.now(),
            'verified': false,
            'type': 'personal'
          }, SetOptions(merge: true))
          .then((value) => print("'created_at' merged with existing data"))
          .catchError((error) => print("Failed to merge data: $error"));
      var work = await _documentReference
          .collection('/work')
          .doc('data')
          .set(
              {'created_at': DateTime.now(), 'verified': false, 'type': 'work'},
              SetOptions(merge: true))
          .then((value) => print("'created_at' merged with existing data"))
          .catchError((error) => print("Failed to merge data: $error"));
      var skill = await _documentReference
          .collection('/skill')
          .doc('data')
          .set({
            'created_at': DateTime.now(),
            'verified': false,
            'type': 'skill'
          }, SetOptions(merge: true))
          .then((value) => print("'created_at' merged with existing data"))
          .catchError((error) => print("Failed to merge data: $error"));

      var dazz = await _documentReference
          .collection('/dazz')
          .doc('data')
          .set({
            'created_at': DateTime.now(),
            'verified': false,
            'type': 'skill',
            'active': false
          }, SetOptions(merge: true))
          .then((value) => print("'created_at' merged with existing data"))
          .catchError((error) => print("Failed to merge data: $error"));
    } catch (e) {
      throw e;
    }
  }

  Future<List<Credential>> getAllUserCredentials() async {
    try {
      var academic =
          await _documentReference.collection('/academic').doc('data').get();
      var personal =
          await _documentReference.collection('/personal').doc('data').get();
      var work = await _documentReference.collection('/work').doc('data').get();
      var skill =
          await _documentReference.collection('/skill').doc('data').get();

      var dazz = await _documentReference.collection('/dazz').doc('data').get();

      List<Credential> list = [];

      Credential cAcademic = Credential.fromSnapshot(academic);
      Credential cPersonal = Credential.fromSnapshot(personal);
      Credential cWork = Credential.fromSnapshot(work);
      Credential cSkill = Credential.fromSnapshot(skill);
      Credential cDazz = Credential.fromSnapshot(dazz);

      list.add(cAcademic);
      list.add(cSkill);
      list.add(cWork);
      list.add(cPersonal);
      list.add(cDazz);

      return list;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getDocumentsTypesByCredential(
      Credential credential) async {
    try {
      var resp = await FirebaseFirestore.instance
          .collection('credential_documents')
          .doc(credential.type)
          .get();

      return List.from(resp.data()['types']);
    } catch (e) {
      return null;
    }
  }

  Stream<List<String>> getDocumentsCredential(
      Credential credential, UserModel userModel) {
    try {
      var resp;
      if (userModel != null) {
        resp = FirebaseFirestore.instance
            .collection('/credentials')
            .doc(userModel.uID)
            .collection(credential.type)
            .doc('data')
            .snapshots()
            .map((event) {
          return Credential.fromSnapshot(event).documents;
        });
      } else {
        resp = _documentReference
            .collection(credential.type)
            .doc('data')
            .snapshots()
            .map((event) {
          return Credential.fromSnapshot(event).documents;
        });
      }

      return resp;
    } catch (e) {
      return null;
    }
  }

  Future<Credential> getCredential(UserModel user, String type) async {
    try {
      var ref =
          FirebaseFirestore.instance.collection('/credentials').doc(user.uID);

      var resp = await ref.collection('/$type').doc('data').get();

      Credential credential = Credential.fromSnapshot(resp);

      return credential;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> shareCredential(
      UserModel user, String type, String email) async {
    try {
      var data = {"owner": user.uID, "invite": email, "type": type};

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('shareCredential');
      final results = await callable.call(data);
      Map<String, dynamic> resp = results.data;

      return resp;
    } catch (e) {
      return {"code": 400, "text": e.toString()};
    }
  }

  Future<Map<String, dynamic>> shareDocument(UserModel user,
      String documentName, String email, String credentialType) async {
    try {
      var url =
          "$profileImagePath/${user.uID}/documents/$credentialType/$documentName";
      url = await this.getUrlFile(url);
      var data = {
        "owner": user.uID,
        "invite": email,
        "documentName": documentName,
        "url": url
      };

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('shareDocument');
      final results = await callable.call(data);
      Map<String, dynamic> resp = results.data;
      print(data);
      return resp;
    } catch (e) {
      return {"code": 400, "text": e.toString()};
    }
  }

  // uploadFile(Credential credential, PlatformFile platformFile, UserModel user,
  //     String type) async {
  //   File file = File(platformFile.path);
  //   try {
  //     String path =
  //         "$profileImagePath/${user.uID}/documents/${credential.type}/$type.${platformFile.extension}";

  //     await FirebaseStorage.instance.ref(path).putFile(file);
  //     await updateCredential(credential, "$type.${platformFile.extension}");
  //   } on FirebaseException catch (e) {
  //     print(e.message);
  //   }
  // }

  Future<void> updateCredential(Credential credential,
      PlatformFile platformFile, UserModel user, String type) async {
    try {
      List<String> doc = [];
      //String typeExt = type.substring(0, type.indexOf('.'));
      credential.documents.forEach((e) {
        doc.add(e.substring(0, e.indexOf('.')));
      });

      if (credential.documents.isEmpty || !doc.contains(type)) {
        credential.documents.add("$type.${platformFile.extension}");
      } else if (doc.contains(type)) {
        int index = doc.indexOf(type);
        await this.deleteFile(credential, credential.documents[index], user);
        credential.documents[index] = "$type.${platformFile.extension}";
      }

      // el archivo se remplaza aunque exista
      await _documentReference
          .collection(credential.type)
          .doc('data')
          .set({'documents': credential.documents}, SetOptions(merge: true));

      String path =
          "$profileImagePath/${user.uID}/documents/${credential.type}/$type.${platformFile.extension}";

      File file = File(platformFile.path);
      await FirebaseStorage.instance.ref(path).putFile(file);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteFile(
      Credential credential, String type, UserModel user) async {
    try {
      String path =
          "$profileImagePath/${user.uID}/documents/${credential.type}/$type";

      await FirebaseStorage.instance.ref(path).delete();
    } catch (e) {}
  }

  Future<void> deleteDocument(
      Credential credential, String type, UserModel user) async {
    credential.documents.remove(type);

    await _documentReference
        .collection(credential.type)
        .doc('data')
        .set({'documents': credential.documents}, SetOptions(merge: true));
    await deleteFile(credential, type, user);
  }

  Future<String> getUrlFile(String path) async {
    String url = await FirebaseStorage.instance.ref(path).getDownloadURL();
    return url;
  }

  Future<void> deleteShareCredential(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('/shared_credentials')
          .doc(id)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  Future<List> validateCredential(
      Credential credential, UserModel owner, String invite) async {
    try {
      if (credential.validators.isEmpty ||
          !credential.validators.contains(invite)) {
        credential.validators.add(invite);
        await FirebaseFirestore.instance
            .collection('credentials')
            .doc(owner.uID)
            .collection(credential.type)
            .doc('data')
            .set(
                {'validators': credential.validators}, SetOptions(merge: true));
        return [true, 'Se envio tu validación'];
      } else {
        return [false, 'Credencial ya validada'];
      }
    } catch (e) {
      throw [false, e.toString()];
    }
  }

  Future<bool> canUploadFile(Credential credential) async {
    try {
      var resp = await FirebaseFirestore.instance
          .collection('credential_documents')
          .doc(credential.type)
          .get();

      int maxDocuments = resp.data()['max_documents'] as int;

      return credential.documents.length < maxDocuments;
    } catch (e) {
      return null;
    }
  }

  Future<double> getDazzCredentialPrice() async {
    try {
      var resp = await FirebaseFirestore.instance
          .collection('credential_documents')
          .doc(dazzCredential)
          .get();

      return resp.data()['price'] as double;
    } catch (e) {
      return null;
    }
  }

  Future<DocumentReference> createOrder(UserModel userModel) async {
    try {
      var order = {
        "user_id": userModel.uID,
        "name": "Dazz",
        "description": "Credencial Empresas"
      };

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(userModel.uID)
          .set(order);

      return FirebaseFirestore.instance.collection('orders').doc(userModel.uID);
    } catch (e) {
      print(e);
    }
  }
}
