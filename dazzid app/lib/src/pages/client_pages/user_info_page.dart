import 'dart:io';

import 'package:dazz/constants.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/states/profile_image_state.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/validators.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:dazz/src/widgets/swipers/image_selector_widget.dart';
import 'package:dazz/src/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/login/login_bloc.dart';
import '../../utils/functions.dart';

import 'package:flash/flash.dart';

class UserInfoPage extends StatefulWidget {
  final UserModel user;
  final bool canReturn;

  const UserInfoPage({Key key, @required this.user, this.canReturn = false})
      : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController _names;
  TextEditingController _lastName;
  TextEditingController _mLastName;
  TextEditingController _curp;
  TextEditingController _rfc;
  TextEditingController _age;
  bool _isLoading = false;
  File profileImage;
  ProfileImage _profileImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DazzLocalizations localizations;

  @override
  void initState() {
    _names = new TextEditingController();
    _lastName = new TextEditingController();
    _mLastName = new TextEditingController();
    _curp = new TextEditingController();
    _rfc = new TextEditingController();
    _age = new TextEditingController();
    //_profileImage = Provider.of<ProfileImage>(context, listen: false);
    //if (_profileImage != null) {
    //igetImage();
    //}

    _fillControls();

    super.initState();
  }

  _fillControls() {
    _profileImage = Provider.of<ProfileImage>(context, listen: false);
    _names.text = widget.user.names;
    _lastName.text = widget.user.lastName;
    _mLastName.text = widget.user.mLastName;
    _curp.text = widget.user.curp;
    _rfc.text = widget.user.rfc;
    _age.text = widget.user.age == null ? '' : widget.user.age.toString();

    if (widget.user.profileImage != null) {
      _profileImage.setHasImage(true);
    }
  }

  @override
  void didChangeDependencies() {
    // _profileImage = Provider.of<ProfileImage>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _names.dispose();
    _lastName.dispose();
    _mLastName.dispose();
    _curp.dispose();
    _rfc.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations = DazzLocalizations.of(context);
    return Scaffold(
      body: _renderForm(),
    );
  }

  _renderForm() {
    final size = MediaQuery.of(context).size;
    final separation = size.height * .05;
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * .1),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SeparatorWidget(height: separation * 2),
                Text(
                  localizations.t('userInfo.header'),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0),
                ),
                SeparatorWidget(height: separation),
                ImageSelectorWidget(
                  title: localizations.t('userInfo.profile'),
                  profileImage: widget.user.profileImage,
                ),
                SeparatorWidget(height: separation),
                _createNamesField(context),
                SeparatorWidget(height: separation),
                _createLastNameField(context),
                SeparatorWidget(height: separation),
                _createMLastNameField(context),
                SeparatorWidget(height: separation),
                _createCURPField(context),
                SeparatorWidget(height: separation),
                _createRFCField(context),
                SeparatorWidget(height: separation),
                _createAgeField(context),
                SeparatorWidget(height: separation * 2),
                if (!_isLoading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.canReturn) _createReturnButton(),
                      Spacer(),
                      _createSaveButton()
                    ],
                  )
                else
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                SeparatorWidget(height: separation),
                TextButton(
                    onPressed: () async {
                      await _launchURL(true);
                    },
                    child: Text(localizations.t('updateInfo.downloadAviso'),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: dPrimaryColor,
                            decoration: TextDecoration.underline))),
                TextButton(
                    onPressed: () async {
                      await _launchURL(false);
                    },
                    child: Text(localizations.t('updateInfo.downloadTerminos'),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: dPrimaryColor,
                            decoration: TextDecoration.underline))),
                SeparatorWidget(height: separation),
                _renderLogOut(context),
                SeparatorWidget(
                  height: separation,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderLogOut(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogOutSuccessState) {
          Navigator.pop(context);
          showLogin(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        if (state is DoLogOutState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text(
                'Salir',
                textAlign: TextAlign.center,
              ),
              width: size.width * .2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                  width: 2, style: BorderStyle.solid, color: dPrimaryColor),
            ),
            elevation: 0.0,
            color: dScaffoldColor,
            onPressed: () async {
              BlocProvider.of<LoginBloc>(context).add(LogOutEvent());
            },
          );
        }
      }),
    );
  }

  _createNamesField(BuildContext context) {
    return CustomTextFormField(
      controller: _names,
      validator: _inputRequired,
      hintText: localizations.t('global.names'),
    );
  }

  _createLastNameField(BuildContext context) {
    return CustomTextFormField(
      controller: _lastName,
      hintText: localizations.t('global.lastName'),
      validator: _inputRequired,
    );
  }

  _createMLastNameField(BuildContext context) {
    return CustomTextFormField(
      controller: _mLastName,
      hintText: localizations.t('global.mLastName'),
      validator: _inputRequired,
    );
  }

  _createCURPField(BuildContext context) {
    return CustomTextFormField(
      controller: _curp,
      hintText: localizations.t('global.curp'),
      isCapitalize: true,
      //validator: _inputRequired,
      maxLength: 18,
    );
  }

  _createRFCField(BuildContext context) {
    return CustomTextFormField(
      controller: _rfc,
      hintText: localizations.t('global.rfc'),
      isCapitalize: true,
      //validator: _inputRequired,
      maxLength: 13,
    );
  }

  _createAgeField(BuildContext context) {
    return CustomTextFormField(
      controller: _age,
      hintText: localizations.t('global.age'),
      keyboardType: TextInputType.number,
      validator: _inputRequired,
      maxLength: 2,
    );
  }

  void _showTopFlash({FlashBehavior style = FlashBehavior.fixed}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text('Dazz ID'),
            content: Text('Los datos personales se han actualizado!'),
            primaryAction: TextButton(
              onPressed: () {},
              child: Text('ENTERADO!', style: TextStyle(color: Colors.blue)),
            ),
          ),
        );
      },
    );
  }

  _createSaveButton() {
    final size = MediaQuery.of(context).size;
    return RaisedButton(
        onPressed: () {
          updateUserProfile();
          Future.delayed(Duration(milliseconds: 300), () {
            Navigator.pop(context);
            _showTopFlash();
            print("Actualizado");
            // Do something
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Text(
            localizations.t('global.buttonUpdate'),
            textAlign: TextAlign.center,
            style: TextStyle(color: dScaffoldColor),
          ),
          width: size.width * .3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              width: 2, style: BorderStyle.solid, color: dPrimaryColor),
        ),
        elevation: 0.0,
        color: dPrimaryColor);
  }

  _createReturnButton() {
    final size = MediaQuery.of(context).size;
    return RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Text(
            localizations.t('global.buttonReturn'),
            textAlign: TextAlign.center,
            style: TextStyle(color: dPrimaryColor),
          ),
          width: size.width * .3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              width: 2, style: BorderStyle.solid, color: dPrimaryColor),
        ),
        elevation: 0.0,
        color: dScaffoldColor);
  }

  String _inputRequired(String value) {
    return !inputRequired(value)
        ? localizations.t('global.inputRequired')
        : null;
  }

  updateUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    bool res = _validateForm();
    if (res) {
      await _mapFormToFolioAndSave();
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _validateForm() {
    if (_profileImage.profileImage == null &&
        (_profileImage.hasImage == null || !_profileImage.hasImage)) {
      return false;
    }

    if (_formKey.currentState.validate()) {
      return true;
    }

    return false;
  }

  _mapFormToFolioAndSave() async {
    UserModel userModel = widget.user;
    userModel.names = _names.text.trim();
    userModel.lastName = _lastName.text.trim();
    userModel.mLastName = _mLastName.text.trim();
    userModel.curp = _curp.text.trim();
    userModel.rfc = _rfc.text.trim();
    userModel.age = int.parse(_age.text.trim());
    userModel.basicInfoCompleted = true;

    UserService userService = UserService();
    await userService.serUserInfo(userModel, _profileImage.profileImage);
  }

  _launchURL(bool legal) async {
    var _url = (legal ? acuerdoPath : terminosPath);

    final Uri uri = Uri(
      scheme: 'https',
      path: 'web.dazzid.mx' + _url,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $_url');
    }
  }
}
