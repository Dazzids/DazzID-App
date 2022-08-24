import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/credential_docs_page.dart';
import 'package:dazz/src/pages/client_pages/credential_info_page.dart';
import 'package:dazz/src/pages/client_pages/credential_status_page.dart';
import 'package:dazz/src/widgets/swipers/pay_dazz_credential.dart';
import 'package:flutter/material.dart';

class CredentialDetailPage extends StatelessWidget {
  final PageController _controller = PageController(
    initialPage: 0,
  );
  final Credential credential;
  final UserModel userModel;
  final bool invite;
  final UserModel userModelInvite;

  CredentialDetailPage(
      {@required Key key,
       this.credential,
       this.userModel,
       this.invite = false,
       this.userModelInvite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (credential.type == dazzCredential && !credential.active) {
      return BuyDazzCredentialWidget(
        userModel: userModel,
        credential: credential,
      );
    }

    return PageView(
      controller: _controller,
      children: [
        CredentialInfoPage(
          credential: credential,
          userModel: userModel,
          invite: invite,
        ),
        CredentialDocsPage(
          credential: credential,
          userModel: userModel,
          invite: invite, key:null
        ),
        CredentialStatusPage(
          credential: credential,
          userModel: userModel,
          invite: invite,
          userModelInvite: userModelInvite,
        )
      ],
    );
  }
}
