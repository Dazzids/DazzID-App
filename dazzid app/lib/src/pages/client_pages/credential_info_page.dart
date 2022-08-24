import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/list_invites_credentials.dart';
import 'package:dazz/src/pages/client_pages/share_credential_page.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CredentialInfoPage extends StatelessWidget {
  final Credential credential;
  final UserModel userModel;
  final bool invite;

  CredentialInfoPage(
      {Key key, @required this.credential, this.userModel, this.invite = false})
      : super(key: key);

  get index => null;

  @override
  Widget build(BuildContext context) {
    Widget w = Scaffold(
      body: Stack(
        children: [_renderBackground(context), _renderQR(context)],
      ),
      floatingActionButton: new FloatingActionButton(
          heroTag: "btn$index",
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShareCredentialPage(
                      type: credential.type,
                      userModel: userModel,
                    )));
          },
          child: const Icon(Icons.share),
          backgroundColor: dPrimaryColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

    if (invite) {
      w = Scaffold(
          body: Stack(
        children: [_renderBackground(context), _renderQR(context)],
      ));
    }

    return w;
  }

  _renderBackground(BuildContext context) {
    DazzLocalizations _localizations = DazzLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * .25,
        ),
        Hero(
          tag: 'credential-${credential.backColor.value}',
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: credential.backColor,
              height: size.height * .01,
            ),
          ),
        ),
        Container(
          color: dScaffoldColor,
          height: size.height * .49,
        ),
        Container(
          color: credential.backColor,
          height: size.height * .20,
          width: double.infinity,
          child: Center(
            child: Container(
              child: Text(
                _localizations.t('home.${credential.type}'),
                style: TextStyle(
                  color: dScaffoldColor,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _renderQR(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double radio = size.width * .15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: size.height * .075),
            child: CircleAvatar(
              radius: radio,
              backgroundColor: credential.backColor,
              child: CircleAvatar(
                  radius: radio * .9,
                  backgroundColor: Colors.transparent,
                  child: getImage()),
            ),
          ),
        ),
        _renderCredentialData(context)
      ],
    );
  }

  getImage() {
    return userModel.profileImage != null
        ? AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: dAvatarPlaceHolder,
                  image: userModel.profileImage),
            ),
          )
        : Image(
            image: AssetImage(dAvatarPlaceHolder),
          );
  }

  _renderCredentialData(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateFormat formatter = DateFormat('MMM, dd, yyyy');
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: size.height * .1, horizontal: size.width * .05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userModel.fullName,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            SeparatorWidget(height: size.height * .01),
            Text('CURP: ' + userModel.curp,
                style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
            SeparatorWidget(height: size.height * .01),
            Text('Email: ' + userModel.email != null ? userModel.email : '',
                style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
            SeparatorWidget(height: size.height * .01),
            Text('Expedición: ' + formatter.format(credential.createdAt),
                style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
            SeparatorWidget(height: size.height * .03),
            if (!invite) _renderInviteNames(context)
          ],
        ),
      ),
    );
  }

  _renderInviteNames(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Text('Credencial compartida con:',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
          SeparatorWidget(
            height: size.height * 0.03,
          ),
          RaisedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListInviteCredentialsPage(
                          userModel: userModel,
                        )));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                child: Text(
                  'Detalle',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dScaffoldColor),
                ),
                width: size.width * 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                    width: 2, style: BorderStyle.solid, color: dPrimaryColor),
              ),
              elevation: 0.0,
              color: dPrimaryColor),
        ],
      ),
    );
  }
}
