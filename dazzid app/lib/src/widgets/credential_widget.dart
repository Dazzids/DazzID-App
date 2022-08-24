import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/credential_detail_page.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class CredentialWidget extends StatelessWidget {
  final Credential credential;
  final UserModel userModel;
  final double height;

  const CredentialWidget(
      {Key key,
      @required this.credential,
      @required this.height,
      @required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DazzLocalizations _localizations = DazzLocalizations.of(context);
    final double headerHeight = height * .30;
    //AuthUserState authUserState = Provider.of<AuthUserState>(context);

    return Hero(
      tag: 'credential-${credential.backColor.value}',
      child: Card(
          //color: credential.backColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CredentialDetailPage(
                        credential: credential,
                        userModel: userModel,
                        key: null,
                      )));
            },
            child: Stack(
              children: [
                _renderBackground(headerHeight),
                _renderCredentialBody(headerHeight, _localizations)
              ],
            ),
          )),
    );
  }

  Widget _renderBackground(double headerHeight) {
    return Column(
      children: [
        Container(
          decoration: new BoxDecoration(
              color: credential.backColor,
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          height: headerHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderCredentialBody(
      double headerHeight, DazzLocalizations _localizations) {
    final double radio = height * .2;
    DateFormat formatter = DateFormat('MMM, dd, yyyy');
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: headerHeight - radio),
        child: Column(
          children: [
            CircleAvatar(
              radius: radio,
              backgroundColor: credential.backColor,
              child: CircleAvatar(
                  radius: radio * .9,
                  backgroundColor: Colors.transparent,
                  child: getImage()),
            ),
            Spacer(),
            Text(
              userModel.fullName ?? _localizations.t('home.noInfo'),
              style: TextStyle(
                  fontSize: 16.0,
                  color: dPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              _localizations.t('home.${credential.type}'),
              style: TextStyle(fontSize: 14.0, color: dPrimaryColor),
              textAlign: TextAlign.left,
            ),
            Text(
              _localizations.t('home.emision') +
                  formatter.format(credential.createdAt),
              style: TextStyle(fontSize: 14.0, color: dPrimaryColor),
              textAlign: TextAlign.left,
            ),
            SeparatorWidget(
              height: 10,
            )
          ],
        ),
      ),
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
        // ? ClipRRect(
        //     //borderRadius: BorderRadius.circular(25.0),
        //     child: FadeInImage(
        //         fit: BoxFit.cover,
        //         image: NetworkImage(userModel.profileImage),
        //         placeholder: AssetImage(dAvatarPlaceHolder)),
        //   )
        : Image(
            image: AssetImage(dAvatarPlaceHolder),
          );
  }
}
