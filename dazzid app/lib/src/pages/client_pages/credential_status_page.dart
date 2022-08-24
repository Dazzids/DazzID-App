import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/list_credential_validator.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class CredentialStatusPage extends StatelessWidget {
  final Credential credential;
  final UserModel userModel;
  final bool invite;
  final UserModel userModelInvite;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CredentialStatusPage(
      {Key key,
      @required this.credential,
      @required this.userModel,
      this.invite = false,
      this.userModelInvite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DazzLocalizations _localizations = DazzLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _renderBackground(context, _localizations),
            _renderQR(context, _localizations)
          ],
        ),
      ),
    );
  }

  _renderBackground(BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          color: credential.verified ? Colors.green : dRedColor,
          height: size.height * .25,
        ),
        Container(
          color: dScaffoldColor,
          height: size.height * .50,
        ),
      ],
    );
  }

  _renderQR(BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 90),
          width: size.width,
          child: Container(
            height: size.height * .1,
            child: Center(
              child: Text(
                credential.verified ? 'Verificado' : 'No Verificado',
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
        ),
        _renderCredentialData(context, localizations)
      ],
    );
  }

  _renderCredentialData(
      BuildContext context, DazzLocalizations _localizations) {
    CredentialService service = new CredentialService();
    final size = MediaQuery.of(context).size;
    DateFormat formatter = DateFormat('MMM, dd, yyyy');
    return Container(
      width: size.width * .8,
      margin: EdgeInsets.symmetric(vertical: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userModel.fullName,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
          SeparatorWidget(height: size.height * .03),
          Text(_localizations.t('home.emision'),
              style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
          Text(
            formatter.format(credential.createdAt),
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SeparatorWidget(height: size.height * .03),
          Text('Documentos',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
          _renderDocuments(_localizations, context, service),
          SeparatorWidget(height: size.height * .05),
          _renderValidatorsButton(context),
          SeparatorWidget(height: size.height * .03),
          //_renderVerifyButton(),
          _renderValidateCredential(context, service)
        ],
      ),
    );
  }

  _renderValidatorsButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListCredentialValidators(
                      credential: credential,
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
            width: 200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                width: 2, style: BorderStyle.solid, color: dScaffoldColor),
          ),
          elevation: 0.0,
          color: dPrimaryColor),
    );
  }

  _renderVerifyButton() {
    if (invite) {
      return Container();
    }

    return Center(
      child: RaisedButton(
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
            child: Text(
              'Verificar',
              textAlign: TextAlign.center,
            ),
            width: 200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                width: 2, style: BorderStyle.solid, color: dPrimaryColor),
          ),
          elevation: 0.0,
          color: dScaffoldColor),
    );
  }

  _renderValidateCredential(BuildContext context, CredentialService service) {
    if (!invite) {
      return Container();
    }

    return Center(
      child: RaisedButton(
          onPressed: () async {
            if (await confirm(
              context,
              title: Text('Validar credencial'),
              content: Text('Deseas validar la credencial?'),
              textOK: Text('Si'),
              textCancel: Text('No'),
            )) {
              var resp = await service.validateCredential(
                  credential, userModel, userModelInvite.uID);

              _showSnackbar(resp[1], resp[0]);
            }
            return print('pressedCancel');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
            child: Text(
              'Validar',
              textAlign: TextAlign.center,
            ),
            width: 200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                width: 2, style: BorderStyle.solid, color: dPrimaryColor),
          ),
          elevation: 0.0,
          color: dScaffoldColor),
    );
  }

  _renderDocuments(DazzLocalizations dazzLocalizations, BuildContext context,
      CredentialService service) {
    final size = MediaQuery.of(context).size;
    List<Widget> list = [];

    return StreamBuilder<List<String>>(
        stream: service.getDocumentsCredential(credential, userModel),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
              //height: size.height * .5,
              child: Center(
                child: Text(
                  dazzLocalizations.t('home.noInfo'),
                  style: TextStyle(fontSize: 36.0, color: dPrimaryColor),
                ),
              ),
            );
          }

          List<Widget> doc = [];

          for (int i = 0; i < snapshot.data.length; i++) {
            doc.add(Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text('- ' + snapshot.data[i],
                  style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
            ));
          }

          return Container(
              margin: EdgeInsets.only(top: 10.0),
              // height: size.height * .5,
              width: size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: doc));
        });
  }

  _showSnackbar(String message, bool isSuccess) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }
}
