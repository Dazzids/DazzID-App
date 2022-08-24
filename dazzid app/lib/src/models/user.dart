// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/request_credentials.dart';
import 'package:dazz/src/models/request_documents.dart';
import 'package:dazz/src/models/shared_credential.dart';
import 'package:dazz/src/models/shared_document.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
     this.createdAt,
     this.active,
     this.displayName,
     this.email,
     this.names,
     this.lastName,
     this.mLastName,
     this.curp,
     this.rfc,
     this.age,
     this.birth,
  });

  DateTime createdAt;
  bool active;
  String displayName;
  String email;
  String names;
  String lastName;
  String mLastName;
  String curp;
  String rfc;
  int age;
  DateTime birth;
  bool infoCompleted;
  String uID;
  String profileImage;
  bool basicInfoCompleted;
  String accountType;
  List<SharedCredential> sharedCredentials = [];
  List<RequestCredential> requestCredentials = [];
  List<SharedDocument> sharedDocuments = [];
  List<RequestDocument> requestDocuments = [];

  String get fullName => names + " " + lastName + " " + mLastName;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        createdAt: json["created_at"],
        active: json["active"],
        displayName: json["display_name"],
        email: json["email"],
        names: json["names"],
        lastName: json["last_name"],
        mLastName: json["m_last_name"],
        curp: json["curp"],
        rfc: json["rfc"],
        age: json["age"],
        birth: json["birth"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "active": active,
        "display_name": displayName,
        "email": email,
        "names": names,
        "last_name": lastName,
        "m_last_name": mLastName,
        "curp": curp,
        "rfc": rfc,
        "age": age,
        "birth": birth,
      };

  UserModel.fromSnapshot(DocumentSnapshot snap)
      : createdAt = ((snap.data() as Map)["created_at"] as Timestamp).toDate(),
        uID = snap.id,
        profileImage = (snap.data() as Map)["photo_url"] ?? null,
        active = (snap.data() as Map)["active"] ?? null,
        displayName = (snap.data() as Map)["display_name"] ?? null,
        email = (snap.data() as Map)["email"] ?? null,
        names = (snap.data() as Map)["names"] ?? null,
        lastName = (snap.data() as Map)["last_name"] ?? null,
        mLastName = (snap.data() as Map)["m_last_name"] ?? null,
        curp = (snap.data() as Map)["curp"] ?? null,
        rfc = (snap.data() as Map)["rfc"] ?? null,
        age = (snap.data() as Map)["age"] ?? null,
        accountType = (snap.data() as Map)['account_type'] ?? null,
        infoCompleted = (snap.data() as Map)["info_completed"] as bool ?? false,
        basicInfoCompleted =
            (snap.data() as Map)["basic_info_completed"] as bool ?? false,
        sharedCredentials = [],
        requestCredentials = [],
        sharedDocuments = [],
        requestDocuments = [],
        birth = (snap.data() as Map)["birth"] == null
            ? null
            : ((snap.data() as Map)["birth"] as Timestamp).toDate();
}
