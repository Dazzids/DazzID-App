import 'package:cloud_firestore/cloud_firestore.dart';

// SharedDocument sharedCredenitalFromJson(String str) =>
//     SharedDocument.fromJson(json.decode(str));

// String sharedCredenitalToJson(SharedDocument data) =>
//     json.encode(data.toJson());

class SharedDocument {
  SharedDocument({
    this.invite,
    this.owner,
    this.sharedAt,
    this.documentName,
    this.url
  });

  String invite;
  String owner;
  DateTime sharedAt;
  String documentName;
  bool active;
  String ownerName;
  String url;

  factory SharedDocument.fromJson(Map<String, dynamic> json) =>
      SharedDocument(
        invite: json["invite"],
        owner: json["owner"],
        sharedAt: json["shared_at"],
        documentName: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "invite": invite,
        "owner": owner,
        "shared_at": sharedAt,
        "type": documentName,
      };

  SharedDocument.fromSnapshot(DocumentSnapshot snap)
      : invite = (snap.data() as Map)["invite"],
        documentName = (snap.data() as Map)["document_name"],
        owner = (snap.data() as Map)["owner"],
        active = (snap.data() as Map)["active"],
        ownerName = (snap.data() as Map)["owner_name"],
        url = (snap.data() as Map)["url"],
        sharedAt = ((snap.data() as Map)["shared_at"] as Timestamp).toDate();
}
