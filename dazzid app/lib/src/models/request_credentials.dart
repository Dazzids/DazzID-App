import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/credential.dart';

RequestCredential sharedCredenitalFromJson(String str) =>
    RequestCredential.fromJson(json.decode(str));

String sharedCredenitalToJson(RequestCredential data) =>
    json.encode(data.toJson());

class RequestCredential {
  RequestCredential({this.invite, this.owner, this.ownerName});

  String invite;
  String owner;
  String ownerName;
  List<String> credentialTypes = [];
  List<Credential> credentials = [];

  factory RequestCredential.fromJson(Map<String, dynamic> json) =>
      RequestCredential(
        invite: json["invite"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "invite": invite,
        "owner": owner,
      };

  RequestCredential.fromSnapshot(DocumentSnapshot snap)
      : invite = (snap.data() as Map)["invite"],
        owner = (snap.data() as Map)["owner"];
}
