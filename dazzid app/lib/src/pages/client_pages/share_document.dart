import 'package:dazz/constants.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareDocumentPage extends StatefulWidget {
  final UserModel userModel;
  final String documentName;
  final String credentialType;

  const ShareDocumentPage(
      {Key key,
      @required this.userModel,
      @required this.documentName,
      @required this.credentialType})
      : super(key: key);

  @override
  _ShareDocumentPageState createState() => _ShareDocumentPageState();
}

class _ShareDocumentPageState extends State<ShareDocumentPage> {
  final TextEditingController controller = new TextEditingController();
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DazzLocalizations localizations = DazzLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
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
                Text('Compartir documento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .1),
                Container(
                  height: size.height * .1,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: _renderText(localizations, context),
                ),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  RaisedButton(
                      onPressed: () async {
                        await _shareCredential();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 15.0),
                        child: Text(
                          localizations.t('global.share'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: dScaffoldColor),
                        ),
                        width: size.width * .8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: dPrimaryColor),
                      ),
                      elevation: 0.0,
                      color: dPrimaryColor)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderText(DazzLocalizations localizations, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .85,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email usuario a compartir',
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
        validator: (value) {
          if (value.length == 0)
            return localizations.t('errorMessages.emptyField');
          else
            return null;
        },
        // onChanged: (value) {
        //   widget.selectedType = widget.textEditingController.text;
        // },
      ),
    );
  }

  _shareCredential() async {
    try {
      if (controller.text.isEmpty) {
        _showSnackbar('Email no valido.', false);
        return;
      }

      setState(() {
        isLoading = true;
      });

      CredentialService service = CredentialService();
      var resp = await service.shareDocument(widget.userModel,
          widget.documentName, controller.text.trim(), widget.credentialType);

      if (resp.isEmpty || resp["code"] == 400 || resp["code"] == 404) {
        _showSnackbar(resp["text"], false);
      } else {
        _showSnackbar(resp["text"], true);
      }

      //await Future.delayed(Duration(seconds: 3));re

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showSnackbar("Error inesperado", false);
      setState(() {
        isLoading = false;
      });
    }
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
