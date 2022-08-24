import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/request_credentials.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/credential_detail_page.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';

class ChooseCredentialWidget extends StatefulWidget {
  final RequestCredential requestCredential;
  UserModel userModelOwner;
  final UserModel invite;

  ChooseCredentialWidget(
      {Key key, @required this.requestCredential, @required this.invite})
      : super(key: key);

  @override
  _ChooseCredentialWidgetState createState() => _ChooseCredentialWidgetState();
}

class _ChooseCredentialWidgetState extends State<ChooseCredentialWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.userModel = new UserModel();
    // widget.userModel.uID = widget.requestCredential.invite;
    _fillCredentials();
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
                Text('Credenciales de: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                Text(widget.requestCredential.ownerName,
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
                    itemCount: widget.requestCredential.credentialTypes.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CredentialDetailPage(
                                  credential: widget
                                      .requestCredential.credentials[index],
                                  userModel: widget.userModelOwner,
                                  invite: true,
                                  userModelInvite: widget.invite,
                                )));
                      },
                      leading: Icon(Icons.assignment_ind_outlined),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text(
                          localizations.t(
                              'home.${widget.requestCredential.credentialTypes[index]}'),
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

  void _fillCredentials() async {
    UserService userService = new UserService();

    widget.userModelOwner =
        await userService.getOwnerInfo(widget.requestCredential.owner);

    CredentialService service = new CredentialService();
    for (var type in widget.requestCredential.credentialTypes) {
      Credential c = await service.getCredential(widget.userModelOwner, type);
      widget.requestCredential.credentials.add(c);
    }

    // _url = await _credentialService.getUrlFile(
    //     "$profileImagePath/${userModel.uID}/documents/${credential.type}/$_url");
    // await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}
