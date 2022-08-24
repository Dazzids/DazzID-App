import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/share_document.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/select_file_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class CredentialDocsPage extends StatelessWidget {
  final Credential credential;
  final UserModel userModel;
  final bool invite;
  final CredentialService _credentialService = new CredentialService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CredentialDocsPage(
      {@required Key key, this.credential, this.userModel, this.invite = false})
      : super(key: key);

  get index => null;

  @override
  Widget build(BuildContext context) {
    DazzLocalizations _localizations = DazzLocalizations.of(context);
    Widget w = Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          _renderBackground(context, _localizations),
          _renderQR(context, _localizations)
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        heroTag: "btn$index",
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => SelectFileWidget(
                        credential: credential,
                        userModel: userModel,
                      )))
              .whenComplete(() => _renderBackground(context, _localizations));
          print('click');
        },
        child: const Icon(Icons.add),
        backgroundColor: dPrimaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: new BottomAppBar(
      //   color: Colors.white,
      //   child: new Container(),
      // ),
    );

    if (invite) {
      w = Scaffold(
        body: Stack(
          children: [
            _renderBackground(context, _localizations),
            _renderQR(context, _localizations)
          ],
        ),
      );
    }

    return w;
  }

  _renderBackground(BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * .25,
        ),
        // Hero(
        //   tag: 'credential-${credential.backColor.value}',
        //   child: Material(
        //     type: MaterialType.transparency,
        //     child: Container(
        //       color: credential.backColor,
        //       height: size.height * .01,
        //     ),
        //   ),
        // ),
        Container(
          color: dScaffoldColor,
          height: size.height * .50,
        ),
        Container(
          color: credential.backColor,
          height: size.height * .20,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    localizations.t('home.${credential.type}'),
                    style: TextStyle(
                      color: dScaffoldColor,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Documentos',
                    style: TextStyle(
                      color: dScaffoldColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          child: SvgPicture.asset(
            dLogo,
            width: size.width * .3,
          ),
        ),
        _renderCredentialData(context, localizations)
      ],
    );
  }

  _renderCredentialData(BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;
    DateFormat formatter = DateFormat('MMM, dd, yyyy');

    return StreamBuilder<List<String>>(
        stream:
            _credentialService.getDocumentsCredential(credential, userModel),
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
              height: size.height * .5,
              child: Center(
                child: Text(
                  localizations.t('home.noInfo'),
                  style: TextStyle(fontSize: 36.0, color: dPrimaryColor),
                ),
              ),
            );
          }

          Widget item = Container(
              height: size.height * .5,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () async {
                    _launchURL(snapshot.data[index]);
                  },
                  leading: Icon(Icons.file_copy),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // subtitle: Text(
                  //   '15 marzo 2021',
                  //   style: TextStyle(color: dPrimaryColor),
                  // ),
                  title: Text(snapshot.data[index],
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.left),
                ),
              ));
          if (invite) {
            return item;
          } else {
            return Container(
              height: size.height * .5,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    //color: Colors.white,
                    child: ListTile(
                      onTap: () async {
                        _launchURL(snapshot.data[index]);
                      },
                      leading: Icon(Icons.file_copy),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      // subtitle: Text(
                      //   '15 marzo 2021',
                      //   style: TextStyle(color: dPrimaryColor),
                      // ),
                      title: Text(snapshot.data[index],
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                        caption: 'Compartir',
                        color: dPrimaryLightColor,
                        icon: Icons.share,
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareDocumentPage(
                                    userModel: userModel,
                                    documentName: snapshot.data[index],
                                    credentialType: credential.type,
                                  )));
                          //_showSnackbar('Share', true);
                        }),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Eliminar',
                      color: dRedColor,
                      icon: Icons.delete,
                      onTap: () async {
                        await _credentialService.deleteDocument(
                            credential, snapshot.data[index], userModel);
                        _showSnackbar('Documento eliminado', true);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // return Container(
          //   height: size.height * .5,
          //   margin: EdgeInsets.symmetric(vertical: 20.0),
          //   child: ListView.separated(
          //     separatorBuilder: (context, index) => Divider(
          //       color: Colors.black,
          //     ),
          //     itemCount: snapshot.data.length,
          //     itemBuilder: (context, index) => Dismissible(
          //       direction: DismissDirection.horizontal,
          //       secondaryBackground: Container(
          //         alignment: AlignmentDirectional.centerEnd,
          //         color: dRedColor,
          //         child: Padding(
          //           padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          //           child: Icon(
          //             Icons.delete,
          //             color: dScaffoldColor,
          //           ),
          //         ),
          //       ),
          //       background: Container(
          //         alignment: Alignment.centerLeft,
          //         padding: EdgeInsets.only(left: 20.0),
          //         color: dGreen,
          //         child: Padding(
          //           padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          //           child: Icon(
          //             Icons.share,
          //             color: dScaffoldColor,
          //           ),
          //         ),
          //       ),
          //       key: Key(snapshot.data[index]),
          //       onDismissed: (direction) async {
          //         if (direction == DismissDirection.startToEnd) {
          //         } else {
          //           await _credentialService.deleteDocument(
          //               credential, snapshot.data[index], userModel);
          //         }
          //       },
          //       child: ListTile(
          //         onTap: () async {
          //           _launchURL(snapshot.data[index]);
          //         },
          //         leading: Icon(Icons.file_copy),
          //         trailing: Icon(Icons.keyboard_arrow_right),
          //         // subtitle: Text(
          //         //   '15 marzo 2021',
          //         //   style: TextStyle(color: dPrimaryColor),
          //         // ),
          //         title: Text(snapshot.data[index],
          //             style: TextStyle(fontSize: 22),
          //             textAlign: TextAlign.left),
          //       ),
          //     ),
          //   ),
          // );

          // return Container(
          //   height: size.height * .5,
          //   margin: EdgeInsets.symmetric(vertical: 20.0),
          //   child: ListView.separated(
          //     separatorBuilder: (context, index) => Divider(
          //       color: Colors.black,
          //     ),
          //     itemCount: snapshot.data.length,
          //     itemBuilder: (context, index) => ListTile(
          //       onTap: () async {
          //         _launchURL(snapshot.data[index]);
          //       },
          //       leading: Icon(Icons.file_copy),
          //       trailing: Icon(Icons.keyboard_arrow_right),
          //       // subtitle: Text(
          //       //   '15 marzo 2021',
          //       //   style: TextStyle(color: dPrimaryColor),
          //       // ),
          //       title: Text(snapshot.data[index],
          //           style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
          //     ),
          //   ),
          // );
        });
  }

  void _launchURL(String _url) async {
    _url = await _credentialService.getUrlFile(
        "$profileImagePath/${userModel.uID}/documents/${credential.type}/$_url");
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
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
