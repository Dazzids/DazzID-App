import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ListInviteCredentialsPage extends StatelessWidget {
  final UserModel userModel;

  const ListInviteCredentialsPage({Key key, @required this.userModel})
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
                Text('Credenciales compartidas con: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.0)),
                SeparatorWidget(height: size.width * .1),
                _renderInviteNames(context),
                // Container(
                //   height: size.height * .5,
                //   margin: EdgeInsets.symmetric(vertical: 20.0),
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) => Divider(
                //       color: Colors.black,
                //     ),
                //     itemCount: widget.requestCredential.credentialTypes.length,
                //     itemBuilder: (context, index) => ListTile(
                //       onTap: () async {
                //         await Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => CredentialDetailPage(
                //                   credential: widget
                //                       .requestCredential.credentials[index],
                //                   userModel: widget.userModel,
                //                   invite: true,
                //                 )));
                //       },
                //       leading: Icon(Icons.assignment_ind_outlined),
                //       trailing: Icon(Icons.keyboard_arrow_right),
                //       title: Text(
                //           widget.requestCredential.credentialTypes[index],
                //           style: TextStyle(fontSize: 22),
                //           textAlign: TextAlign.left),
                //     ),
                //   ),
                // )
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

    return StreamBuilder<QuerySnapshot>(
      stream: service.getUsersSharedCredential(userModel.uID),
      // initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al obtener la información.'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.isEmpty) {
          return Container(
            height: size.height * .05,
            child: Text(
              localizations.t('home.noInfo'),
              style: TextStyle(fontSize: 20.0, color: dPrimaryColor),
            ),
          );
        }

        // List<Widget> items = [];

        // for (var item in snapshot.data.docs) {
        //   items.add(Text('- ' + item.data()["invite_name"],
        //       style: TextStyle(fontSize: 22, color: Colors.black),
        //       textAlign: TextAlign.left));
        // }

        // return Container(
        //   child: Column(
        //     children: items,
        //   ),
        // );

        return Container(
          height: size.height * .5,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: dPrimaryColor,
            ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) => Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              key: Key(snapshot.data.docs[index].id),
              onDismissed: (direction) async {
                await credentialService
                    .deleteShareCredential(snapshot.data.docs[index].id);
              },
              child: ListTile(
                leading: Icon(Icons.assignment_ind_outlined),
                title: Text(
                    (snapshot.data.docs[index].data() as Map)["invite_name"],
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left),
                subtitle: Text(
                    (snapshot.data.docs[index].data() as Map)["invite_email"] ??
                        "",
                    style: TextStyle(color: dPrimaryColor)),
              ),
            ),
          ),
        );
      },
    );
  }
}
