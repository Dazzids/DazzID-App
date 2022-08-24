import 'package:dazz/constants.dart';
import 'package:dazz/src/models/request_credentials.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/widgets/swipers/choose_credetial_widget.dart';
import 'package:flutter/material.dart';

class RequestedCredentialWidget extends StatelessWidget {
  final RequestCredential requestCredential;
  final UserModel userModel;
  RequestedCredentialWidget(
      {Key key, @required this.requestCredential, @required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseCredentialWidget(
                          requestCredential: requestCredential,
                          invite: userModel,
                        )));
              },
              leading: Icon(Icons.assignment_ind_outlined, size: 50),
              title: Text(
                requestCredential.ownerName,
                style: TextStyle(color: dPrimaryColor),
              ),
              subtitle: Text(
                  requestCredential.credentialTypes.length.toString() +
                      ' Credencial(es) compartidas.',
                  style: TextStyle(color: dPrimaryColor))),
        ],
      ),
    );
    // return Card(
    //   elevation: 3.0,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   child: Column(
    //     // mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       ListTile(
    //         title: Text(requestCredential.ownerName),
    //         subtitle: Text(requestCredential.credentialTypes.length.toString() +
    //             ' Credeciales compartidas'),
    //       ),
    //       // Row(
    //       //   mainAxisAlignment: MainAxisAlignment.end,
    //       //   children: <Widget>[
    //       //     TextButton(
    //       //       child: const Text('BUY TICKETS'),
    //       //       onPressed: () {/* ... */},
    //       //     ),
    //       //     const SizedBox(width: 8),
    //       //     TextButton(
    //       //       child: const Text('LISTEN'),
    //       //       onPressed: () {/* ... */},
    //       //     ),
    //       //     const SizedBox(width: 8),
    //       //   ],
    //       // ),
    //     ],
    //   ),
    // );
  }
}
