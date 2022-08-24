import 'package:dazz/constants.dart';
import 'package:dazz/src/models/credential.dart';
import 'package:dazz/src/models/request_credentials.dart';
import 'package:dazz/src/models/request_documents.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/client_pages/credential_docs_page.dart';
import 'package:dazz/src/pages/client_pages/user_info_page.dart';
import 'package:dazz/src/services/credentials/credential_service.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/widgets/credential_widget.dart';
import 'package:dazz/src/widgets/request_credential_widget.dart';
import 'package:dazz/src/widgets/request_document_widget.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:dazz/src/widgets/swipers/credential_swiper_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  List<Credential> cred = [];

  HomePage({Key key, @required this.userModel}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = new TextEditingController();
  CredentialService _credentialService = new CredentialService();
  DazzLocalizations _localizations;

  @override
  void initState() {
    super.initState();
    // fillSharedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _localizations = DazzLocalizations.of(context);

    widget.cred.add(new Credential.credential('academic'));
    widget.cred.add(new Credential.credential('skill'));
    widget.cred.add(new Credential());
    return Scaffold(
        backgroundColor: dScaffoldColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onrefresh,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  _renderSearchBar(size),
                  Container(
                    //margin: EdgeInsets.only(top: size.height * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _createCardArray(),
                        _renderRequestCredentialSection(size),
                        SeparatorWidget(
                          height: size.height * .02,
                        ),
                        //_renderSharedDocuments(size),
                        SeparatorWidget(
                          height: size.height * .1,
                        ),
                        _renderDocumentSection(size),
                        // SeparatorWidget(
                        //   height: size.height * .02,
                        // ),
                        //SignOutWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _renderCredentialSection(List<CredentialWidget> list) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
          child: Text(
            _localizations.t('home.issuedCredentials'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        CredentialSwiperWidget(
          credentials: list,
          height: size.height * .26,
        ),
      ],
    );
  }

  Widget _renderRequestCredentialSection(Size size) {
    return FutureBuilder<List<RequestCredential>>(
      future: fillSharedCredentials(),
      //initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<RequestCredential>> snapshot) {
        Widget child = CircularProgressIndicator();
        if (!snapshot.hasData) {
          child = Center(
            child: Container(
              height: size.height * .18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ),
          );
        } else {
          List<RequestedCredentialWidget> list = [];

          widget.userModel.requestCredentials = snapshot.data;

          for (var i = 0; i < widget.userModel.requestCredentials.length; i++) {
            list.add(new RequestedCredentialWidget(
              requestCredential: widget.userModel.requestCredentials[i],
              userModel: widget.userModel,
            ));
          }

          if (list.length == 0) {
            child = Center(
              child: Container(
                height: size.height * .18,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sin Información',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          } else {
            child = CredentialSwiperWidget(
              credentials: list,
              height: size.height * .1,
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(top: size.height * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _localizations.t('home.requestedCredentials'),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 20.0),
                      //   child: Container(
                      //       //color: Colors.red,
                      //       child: InkWell(
                      //     customBorder: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20)),
                      //     child: Icon(Icons.refresh, size: 20.0),
                      //     onTap: () {
                      //       print('object');
                      //     },
                      //   )),
                      // )
                    ]),
              ),
              child
            ],
          ),
        );
      },
    );
  }

  Widget _renderDocumentSection(Size size) {
    List<Widget> cards = List<Widget>();

    for (var i = 0; i < 3; i++) {
      cards.add(new Container(
        margin: EdgeInsets.all(5.0),
        child: new InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CredentialDocsPage(
                      userModel: widget.userModel,
                      credential: widget.cred[i],
                    )));
          },
          child: Container(
            width: (size.width * 0.5) / 3,
            //height: 100.0,
            child: FittedBox(
                child: Icon(
                  i == 0
                      ? Icons.school
                      : i == 1
                          ? Icons.assignment_outlined
                          : Icons.person,
                  color: dScaffoldColor,
                  size: 36.0,
                ),
                fit: BoxFit.none),
            decoration: BoxDecoration(
                color: i == 0
                    ? cAcademicColor
                    : i == 1
                        ? cSkillColor
                        : cPersonalColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards.map((e) => e).toList(),
    );
  }

  Widget _renderSearchBar(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: dAccentColor, // inkwell color
                child:
                    SizedBox(width: 50, height: 50, child: Icon(Icons.person)),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserInfoPage(
                            user: widget.userModel,
                            canReturn: true,
                          )));
                },
              ),
            ),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 10.0),
        //   child: AnimSearchBar(
        //     helpText: 'Buscar...',
        //     rtl: true,
        //     width: size.width * 0.8,
        //     textController: searchController,
        //     onSuffixTap: () {
        //       setState(() {
        //         searchController.clear();
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }

  _createCardArray() {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<Credential>>(
      future: _credentialService.getAllUserCredentials(),
      builder: (context, AsyncSnapshot<List<Credential>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.isEmpty == true) {
            return Text('Sin informacion');
          }

          List<CredentialWidget> list = [];
          snapshot.data?.forEach((element) {
            list.add(new CredentialWidget(
              userModel: widget.userModel,
              credential: element,
              height: size.height * .26,
            ));

            switch (element.type) {
              case 'academic':
                widget.cred[0] = element;
                break;
              case 'skill':
                widget.cred[1] = element;
                break;
              case 'personal':
                widget.cred[2] = element;
                break;
            }
          });

          return _renderCredentialSection(list);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<RequestCredential>> fillSharedCredentials() async {
    UserService _userService = UserService();
    // widget.userModel.requestCredentials =
    return await _userService.getsharedCredentials(widget.userModel);
  }

  Future<List<RequestDocument>> fillSharedDocuments() async {
    UserService _userService = UserService();
    // widget.userModel.requestCredentials =
    return await _userService.getsharedDocuments(widget.userModel);
  }

  _renderSharedDocuments(Size size) {
    return FutureBuilder<List<RequestDocument>>(
      future: fillSharedDocuments(),
      //initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<RequestDocument>> snapshot) {
        Widget child = CircularProgressIndicator();
        if (!snapshot.hasData) {
          child = Center(
            child: Container(
              height: size.height * .18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ),
          );
        } else {
          List<RequestedDocumentWidget> list = [];

          widget.userModel.requestDocuments = snapshot.data;

          for (var i = 0; i < widget.userModel.requestDocuments.length; i++) {
            list.add(new RequestedDocumentWidget(
              requestDocument: widget.userModel.requestDocuments[i],
              userModel: widget.userModel,
            ));
          }

          if (list.length == 0) {
            child = Center(
              child: Container(
                height: size.height * .18,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sin Información',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          } else {
            child = CredentialSwiperWidget(
              credentials: list,
              height: size.height * .1,
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(top: size.height * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _localizations.t('home.requestedDocuments'),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 20.0),
                    //   child: Container(
                    //       //color: Colors.red,
                    //       child: InkWell(
                    //     customBorder: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     child: Icon(Icons.refresh, size: 20.0),
                    //     onTap: () async {
                    //       await fillSharedDocuments();
                    //       setState(() {});
                    //     },
                    //   )),
                    // )
                  ],
                ),
              ),
              child
            ],
          ),
        );
      },
    );
  }

  Future<void> _onrefresh() async {
    setState(() {});
  }
}
