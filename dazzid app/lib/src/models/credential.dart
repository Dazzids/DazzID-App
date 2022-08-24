import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/constants.dart';
import 'package:flutter/material.dart';

Credential credentialFromJson(String str) =>
    Credential.fromJson(json.decode(str));

String credentialToJson(Credential data) => json.encode(data.toJson());

class Credential {
  Credential({
    this.createdAt,
    this.type,
    this.verified,
    this.validity,
    this.photo,
  });

  Credential.credential(String type) {
    this.createdAt = DateTime.now();
    this.type = type;
    this.verified = false;
  }

  DateTime createdAt;
  String type;
  bool verified;
  String validity;
  String photo;
  Color backColor;
  List<String> documents;
  List<String> validators;
  bool active;

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
        createdAt: json["created_at"],
        type: json["type"],
        verified: json["verified"],
        validity: json["validity"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "type": type,
        "verified": verified,
        "validity": validity,
        "photo": photo,
      };

  Credential.fromSnapshot(DocumentSnapshot snap)
      : createdAt = ((snap.data() as Map)["created_at"] as Timestamp).toDate(),
        type = (snap.data() as Map)["type"],
        verified = (snap.data() as Map)["verified"],
        validity = (snap.data() as Map)["validity"] ?? null,
        photo = (snap.data() as Map)["photo"] ?? null,
        backColor = _chooseBackColor(
          (snap.data() as Map)['type'],
        ),
        active = (snap.data() as Map)["active"] ?? false,
        documents = (snap.data() as Map)['documents'] != null
            ? List.from((snap.data() as Map)['documents'])
            : [],
        validators = (snap.data() as Map)['validators'] != null
            ? List.from((snap.data() as Map)['validators'])
            : [];

  static Color _chooseBackColor(String type) {
    Color color;
    switch (type) {
      case academicCredential:
        color = cAcademicColor;
        break;
      case skillCredential:
        color = cSkillColor;
        break;
      case workCredential:
        color = cWorkColor;
        break;
      case personalCredential:
        color = cPersonalColor;
        break;
      case dazzCredential:
        color = cDazzColor;
        break;
      default:
        color = cAcademicColor;
    }

    return color;
  }
}
