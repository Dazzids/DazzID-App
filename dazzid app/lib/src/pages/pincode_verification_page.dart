import 'dart:async';

import 'package:dazz/constants.dart';
import 'package:dazz/src/blocs/signup/signup_bloc.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String userEmail;
  final String userPass;

  PinCodeVerificationScreen(this.userEmail, this.userPass);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;
  DazzLocalizations localizations;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations = DazzLocalizations.of(context);
    return Scaffold(
      backgroundColor: dScaffoldColor,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: FlareActor(
                  dVerificationAnimation,
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  localizations.t('verification.header'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: localizations.t('verification.subHeader') + " ",
                      children: [
                        TextSpan(
                            text: widget.userEmail,
                            style: TextStyle(
                                color: dPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: dPrimaryColor, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: dAccentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        bool isNumeric = int.tryParse(v) != null;

                        if (!isNumeric || v.length == 0) {
                          hasError = true;
                          return "I'm from validator";
                        } else {
                          hasError = false;
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        activeColor: dAccentColor,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        selectedColor: dPrimaryColor,
                        fieldWidth: 50,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      enableActiveFill: false,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: dScaffoldColor,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? localizations.t('verification.errorFill') : "",
                  style: TextStyle(
                      color: dRedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: localizations.t('verification.resendCodeQ'),
                    style: TextStyle(fontSize: 15, color: dPrimaryColor),
                    children: [
                      TextSpan(
                          text:
                              " " + localizations.t('verification.resendCode'),
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: dAccentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: _renderVerfyButton()),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  _renderVerfyButton() {
    final size = MediaQuery.of(context).size;
    final button = ButtonTheme(
      height: 50,
      child: FlatButton(
        onPressed: () {
          formKey.currentState.validate();
          // conditions for validating
          if (currentText.length != 6 || hasError) {
            errorController.add(
                ErrorAnimationType.shake); // Triggering error shake animation
            setState(() {
              hasError = true;
            });
          } else {
            setState(() {
              hasError = false;
              _sendVerificationCode();
            });
          }
        },
        color: dPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              width: 2, style: BorderStyle.solid, color: dPrimaryColor),
        ),
        child: Center(
            child: Text(
          localizations.t('verification.verify'),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );

    return BlocListener<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          showSession(context);
        }
      },
      child: BlocBuilder<SignupBloc, SignUpState>(builder: (context, state) {
        if (state is DoVerificationState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is SignUpErrorState) {
          return Column(children: [
            button,
            Container(
              height: size.height * .02,
            ),
            Text(
              state.message,
              style: TextStyle(color: dRedColor, fontWeight: FontWeight.bold),
            )
          ]);
        } else {
          return button;
        }
      }),
    );
  }

  _sendVerificationCode() {
    BlocProvider.of<SignupBloc>(context).add(DoVerificationEvent(
        verificationCode: currentText,
        email: widget.userEmail,
        password: widget.userPass));
  }
}
