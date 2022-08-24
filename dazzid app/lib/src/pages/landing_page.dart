import 'package:dazz/constants.dart';
import 'package:dazz/src/blocs/login/login_bloc.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dRedColor,
      body: SafeArea(
        child: Center(
          child: _renderbutton(context),
        ),
      ),
    );
  }

  _renderbutton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogOutSuccessState) {
          showLogin(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        if (state is DoLogOutState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            width: size.width * .8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text('Ocurrio un error al iniciar la app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: dScaffoldColor, fontSize: 40.0)),
                ),
                SeparatorWidget(
                  height: size.height * .2,
                ),
                RaisedButton(
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(LogOutEvent());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 15.0),
                      child: Text(
                        'Salir',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: dScaffoldColor),
                      ),
                      width: size.width * .4,
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
          );
        }
      }),
    );
  }
}
