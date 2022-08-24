import 'package:dazz/constants.dart';
import 'package:dazz/src/models/request_documents.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/widgets/choose_document_widget.dart';
import 'package:flutter/material.dart';

class RequestedDocumentWidget extends StatelessWidget {
  final RequestDocument requestDocument;
  final UserModel userModel;
  RequestedDocumentWidget(
      {Key key, @required this.requestDocument, @required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseDocumentWidget(
                          requestDocument: requestDocument,
                          invite: userModel,
                        )));
              },
              leading: Icon(Icons.assignment_ind_outlined, size: 50),
              title: Text(
                requestDocument.ownerName,
                style: TextStyle(color: dPrimaryColor),
              ),
              subtitle: Text(
                  requestDocument.documents.length.toString() +
                      ' Documento(s) compartido(s).',
                  style: TextStyle(color: dPrimaryColor))),
        ],
      ),
    );
  }
}
