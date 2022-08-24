import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ListCredentialValidators extends StatelessWidget {
  final UserModel userModel;
  final Credential credential;

  const ListCredentialValidators(
      {Key key, @required this.userModel, @required this.credential})
      : super(key: key);

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
                Text('Credencial validada por: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .1),
                _renderInviteNames(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderInviteNames(BuildContext context) {
    final size = MediaQuery.of(context).size;

    DazzLocalizations localizations = DazzLocalizations.of(context);

    UserService service = new UserService();
    CredentialService credentialService = CredentialService();

    return FutureBuilder<List<UserModel>>(
      future: service.getCredentialValidators(credential, userModel.uID),
      // initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al obtener la información.'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.isEmpty) {
          return Container(
            height: size.height * .05,
            child: Text(
              localizations.t('home.noInfo'),
              style: TextStyle(fontSize: 20.0, color: dPrimaryColor),
            ),
          );
        }

        return Container(
          height: size.height * .5,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: dPrimaryColor,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => Dismissible(
              background: Container(
                color: dRedColor,
              ),
              key: Key(snapshot.data[index].uID),
              onDismissed: (direction) async {
                return;
              },
              child: ListTile(
                leading: Icon(Icons.assignment_ind_outlined),
                title: Text(snapshot.data[index].displayName,
                    style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
                subtitle: Text(
                  snapshot.data[index].email,
                  style: TextStyle(color: dPrimaryColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
