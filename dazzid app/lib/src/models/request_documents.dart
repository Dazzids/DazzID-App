import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/shared_document.dart';

// RequestDocument sharedCredenitalFromJson(String str) =>
//     RequestDocument.fromJson(json.decode(str));

// String sharedCredenitalToJson(RequestDocument data) =>
//     json.encode(data.toJson());

class RequestDocument {
  RequestDocument({this.invite, this.owner, this.ownerName});

  String invite;
  String owner;
  String ownerName;
  List<String> documents = [];
  List<SharedDocument> sharedDocuments = [];

  factory RequestDocument.fromJson(Map<String, dynamic> json) =>
      RequestDocument(
        invite: json["invite"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "invite": invite,
        "owner": owner,
      };

  RequestDocument.fromSnapshot(DocumentSnapshot snap)
      : invite = (snap.data() as Map)["invite"],
        owner = (snap.data() as Map)["owner"];
}
