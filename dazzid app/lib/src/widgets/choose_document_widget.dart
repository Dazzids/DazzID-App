import 'package:dazz/src/models/request_documents.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseDocumentWidget extends StatefulWidget {
  final RequestDocument requestDocument;
  UserModel userModelOwner;
    final CredentialService _credentialService = new CredentialService();
  final UserModel invite;

  ChooseDocumentWidget(
      {Key key, @required this.requestDocument, @required this.invite})
      : super(key: key);

  @override
  _ChooseDocumentWidgetState createState() => _ChooseDocumentWidgetState();
}

class _ChooseDocumentWidgetState extends State<ChooseDocumentWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DazzLocalizations localizations = DazzLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .05, vertical: size.width * .15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Documentos de: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                Text(widget.requestDocument.ownerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .1),
                Container(
                  height: size.height * .5,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: widget.requestDocument.documents.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () async {
                        _launchURL(widget.requestDocument.sharedDocuments[index].url);
                      },
                      leading: Icon(Icons.assignment_ind_outlined),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text(
                          widget.requestDocument.documents[index],
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.left),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
    void _launchURL(String _url) async {
      //_url = await widget._credentialService.getUrlFile(_url);
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  // void _fillCredentials() async {
  //   UserService userService = new UserService();

  //   widget.userModelOwner =
  //       await userService.getOwnerInfo(widget.requestDocument.owner);

  //   CredentialService service = new CredentialService();
  //   for (var type in widget.requestDocument.credentialTypes) {
  //     Credential c = await service.getCredential(widget.userModelOwner, type);
  //     widget.requestDocument.credentials.add(c);
  //   }
  // }
}
