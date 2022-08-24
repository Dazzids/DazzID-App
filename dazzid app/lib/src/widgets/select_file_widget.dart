import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectFileWidget extends StatefulWidget {
  final Credential credential;
  final UserModel userModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedType;
  String selectedFileName = '';
  CredentialService _credentialService = new CredentialService();
  PlatformFile platformFile;
  bool isLoading = false;
  TextEditingController textEditingController;

  SelectFileWidget(
      {Key key, @required this.credential, @required this.userModel})
      : super(key: key);

  @override
  _SelectFileWidgetState createState() => _SelectFileWidgetState();
}

class _SelectFileWidgetState extends State<SelectFileWidget> {
  @override
  void initState() {
    widget.textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DazzLocalizations localizations = DazzLocalizations.of(context);

    return Scaffold(
      key: widget._scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .1, vertical: size.width * .15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(localizations.t('home.${widget.credential.type}'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .2),
                Text(localizations.t('global.messageSelectFile'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0)),
                SeparatorWidget(height: size.width * .05),
                if (widget.credential.type != skillCredential &&
                    widget.credential.type != dazzCredential)
                  _renderDropDown(size)
                else
                  _renderText(localizations),
                SeparatorWidget(height: size.width * .05),
                Text(widget.selectedFileName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0)),
                SeparatorWidget(height: size.width * .1),
                _renderButtons(localizations, size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderDropDown(Size size) {
    return Container(
      width: size.width * .8,
      child: FutureBuilder<List<String>>(
        future: widget._credentialService
            .getDocumentsTypesByCredential(widget.credential),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.hasData == null ||
              snapshot.data.length == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (widget.selectedType == null)
            widget.selectedType = snapshot.data[0];

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: DropdownButton(
              value: widget.selectedType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              underline: Container(
                height: 2,
                color: dPrimaryColor,
              ),
              isExpanded: true,
              style: TextStyle(color: dPrimaryColor, fontSize: 20),
              items: snapshot.data
                  .map<DropdownMenuItem<String>>(
                    (e) => new DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (String value) {
                setState(() {
                  widget.selectedType = value;
                });
              },
            ),
          );
        },
      ),
    );
  }

  _selectFile() async {
    setState(() {
      widget.isLoading = true;
    });

    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    String fileName = '';

    if (result != null) {
      widget.platformFile = result.files.first;
      fileName = widget.platformFile.name;
    } else {
      _showSnackbar("Favor de seleccionar un archivo.", false);
    }

    setState(() {
      widget.selectedFileName = fileName;
      widget.isLoading = false;
    });
  }

  _uploadFile() async {
    setState(() {
      widget.isLoading = true;
    });

    if (widget.credential.type == skillCredential &&
        !await widget._credentialService.canUploadFile(widget.credential)) {
      _showSnackbar(
          "Se alcanzo el numero maximo de documentos permitidos.", false);
      setState(() {
        widget.isLoading = false;
      });
      return;
    }

    if (widget.selectedFileName != '' && widget.selectedType != null) {
      await widget._credentialService.updateCredential(widget.credential,
          widget.platformFile, widget.userModel, widget.selectedType);

      _showSnackbar("Archivo subido correctamente.", true);
      widget.selectedFileName = '';
      widget.textEditingController.text = '';
    } else {
      _showSnackbar("Favor de seleccionar un archivo.", false);
    }

    setState(() {
      widget.isLoading = false;
    });
  }

  Widget _renderButtons(DazzLocalizations localizations, Size size) {
    if (widget.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          RaisedButton(
              onPressed: () async {
                await _selectFile();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text(
                  localizations.t('global.selectFile'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dPrimaryColor),
                ),
                width: size.width * .8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                    width: 2, style: BorderStyle.solid, color: dPrimaryColor),
              ),
              elevation: 0.0,
              color: dScaffoldColor),
          SeparatorWidget(height: size.width * .05),
          RaisedButton(
              onPressed: () async {
                await _uploadFile();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text(
                  localizations.t('global.uploadFile'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dScaffoldColor),
                ),
                width: size.width * .8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                    width: 2, style: BorderStyle.solid, color: dPrimaryColor),
              ),
              elevation: 0.0,
              color: dPrimaryColor)
        ],
      );
    }
  }

  _renderText(DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .75,
      child: TextFormField(
        controller: widget.textEditingController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
        ],
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: localizations.t('global.selectFile'),
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
        onChanged: (value) {
          widget.selectedType = widget.textEditingController.text;
        },
      ),
    );
  }

  _showSnackbar(String message, bool isSuccess) {
    widget._scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }
}
