import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SharedCredential sharedCredenitalFromJson(String str) =>
    SharedCredential.fromJson(json.decode(str));

String sharedCredenitalToJson(SharedCredential data) =>
    json.encode(data.toJson());

class SharedCredential {
  SharedCredential({
    this.invite,
    this.owner,
    this.sharedAt,
    this.type,
  });

  String invite;
  String owner;
  DateTime sharedAt;
  String type;
  bool active;
  String ownerName;

  factory SharedCredential.fromJson(Map<String, dynamic> json) =>
      SharedCredential(
        invite: json["invite"],
        owner: json["owner"],
        sharedAt: json["shared_at"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "invite": invite,
        "owner": owner,
        "shared_at": sharedAt,
        "type": type,
      };

  SharedCredential.fromSnapshot(DocumentSnapshot snap)
      : invite = (snap.data() as Map)["invite"],
        type = (snap.data() as Map)["type"],
        owner = (snap.data() as Map)["owner"],
        active = (snap.data() as Map)["active"],
        ownerName = (snap.data() as Map)["owner_name"],
        sharedAt = ((snap.data() as Map)["shared_at"] as Timestamp).toDate();
}
