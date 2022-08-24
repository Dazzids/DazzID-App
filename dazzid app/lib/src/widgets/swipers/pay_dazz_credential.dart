import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:flutter/material.dart';

// import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

import '../separator_widget.dart';

class BuyDazzCredentialWidget extends StatefulWidget {
  final UserModel userModel;
  final Credential credential;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  bool _paying = false;
  String _message = "";
  DazzLocalizations localizations;

  BuyDazzCredentialWidget(
      {Key key, @required this.userModel, @required this.credential})
      : super(key: key);

  @override
  _BuyDazzCredentialWidgetState createState() =>
      _BuyDazzCredentialWidgetState();
}

class _BuyDazzCredentialWidgetState extends State<BuyDazzCredentialWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    widget.localizations = DazzLocalizations.of(context);
    CredentialService credentialService = new CredentialService();

    return Scaffold(
      key: widget._scaffoldKey,
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
                Text('Credencial Dazz ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .1),
                Text(widget.localizations.t('buyDazz.message'),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: dPrimaryColor, fontSize: 26.0)),
                Container(height: size.height * .1),
                FutureBuilder<double>(
                  future: credentialService.getDazzCredentialPrice(),
                  initialData: 0.0,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error al obtener el precio.'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: SingleChildScrollView(),
                      );
                    }

                    return Text('\$' + snapshot.data.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: dPrimaryColor, fontSize: 45.0));
                  },
                ),
                SeparatorWidget(height: size.width * .1),
                if (widget._loading)
                  Center(child: CircularProgressIndicator())
                else
                  RaisedButton(
                      onPressed: () async {
                        await _buyCredential();
                      },
                      child: Container(
                        width: size.width * .6,
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 15.0),
                        child: Text(widget.localizations.t('buyDazz.buy'),
                            textAlign: TextAlign.center),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: dPrimaryColor),
                      ),
                      elevation: 0.0,
                      color: dScaffoldColor,
                      textColor: dPrimaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buyCredential() async {
    try {
      setState(() {
        widget._loading = true;
      });

      CredentialService credentialService = new CredentialService();
      var ref = await credentialService.createOrder(widget.userModel);
      ref.snapshots().listen(listenBuy);
    } catch (e) {
      widget._message = e.toString();
    }
  }

  void listenBuy(DocumentSnapshot event) async {
    var data = (event.data() as Map);
    var preferenceId = data["preference_id"] ?? null;

    if (data["status"] != null) {
      setState(() {
        widget._loading = false;
        //widget._message = data["message"];
      });
    } else if (widget._paying == false) {
      // setState(() {
      //   widget._loading = true;
      // });
      if (data["preference_id"] != null) {
        // setState(() {
        //   widget._loading = true;
        // });
        UserService userService = new UserService();
        String publicKey = await userService.getPublicKeyMP();

        if (publicKey == null) {
          _showSnackbar('Error al obtener la llave', false);
          return;
        }

        //  var result = await MercadoPagoMobileCheckout.startCheckout(
        //      publicKey, preferenceId);

        var result = null;

        print(result);

        if (result.status == "approved") {
          await event.reference.set({
            "status": paid,
            "message": widget.localizations.t(
              'buyDazz.paidMessage',
            ),
            "payment": result.toJson()
          }, SetOptions(merge: true));
          widget.credential.active = true;
        } else if (result.status == "pending") {
          await event.reference.set({
            "status": pending,
            "message": widget.localizations.t(
              'buyDazz.pendingMessage',
            ),
            "payment": result.toJson()
          }, SetOptions(merge: true));
        } else if (result.result == 'canceled') {
          await event.reference.delete();
          _showSnackbar('Cancelado por el usuario', false);
        } else {
          await event.reference.delete();
          _showSnackbar('Pago rechazado', false);
          widget._message = widget.localizations.t(
            'buyDazz.unknownMessage',
          );
        }

        setState(() {
          widget._loading = false;
        });
      } else {
        print(data);
      }

      // setState(() {
      //   widget._loading = false;
      // });

      if (widget.credential.active == true) {
        setState(() {
          widget._loading = true;
        });
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pop();
      }
    }

    // print(event.data());
    // var preferenceId = (event.data() as Map)["preference_id"];

    // if (preferenceId != null) {
    //   PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
    //       mercadoPagoPublicKey, preferenceId);

    //   print(result);
    //   if (result.result == 'canceled') {
    //     _showSnackbar('Cancelado por el usuario', false);
    //   }
    // }
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
