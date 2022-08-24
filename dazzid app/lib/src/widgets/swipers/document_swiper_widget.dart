import 'package:dazz/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:random_color/random_color.dart';

class DocumentSwiperWidget extends StatelessWidget {
  final List<dynamic> credentials;
  final double height;
  final bool randomColors;

  const DocumentSwiperWidget(
      {Key key,
      @required this.credentials,
      @required this.height,
      this.randomColors = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RandomColor _randomColor = RandomColor();

    // return Container(
    //   width: size.width,
    //   height: 200,
    //   child: Swiper(
    //     itemBuilder: (BuildContext context, int index) {
    //       return new Image.network(
    //         "https://via.placeholder.com/288x188",
    //         fit: BoxFit.fill,
    //       );
    //     },
    //     viewportFraction: 0.8,
    //     scale: 0.5,
    //     itemCount: 3,
    //     itemWidth: 400.0,
    //     itemHeight: height * .5,
    //     layout: SwiperLayout.STACK,
    //     scrollDirection: Axis.vertical,
    //   ),
    // );
    return Container(
      width: size.width,
      height: height,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: randomColors ? dYellowColor : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: Text('Titulo'),
                  subtitle: Text(
                      'Este es el subtitulo del card. Aqui podemos colocar descripción de este card.'),
                  leading: Icon(Icons.home),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(onPressed: () => {}, child: Text('Aceptar')),
                    FlatButton(onPressed: () => {}, child: Text('Cancelar'))
                  ],
                )
              ],
            ),
          );
        },
        itemCount: credentials.length,
        //scrollDirection: Axis.vertical,
        scrollDirection: Axis.vertical,
        layout: SwiperLayout.STACK,
        itemWidth: size.width,
        itemHeight: height * 0.8,
        viewportFraction: 0.9,
        scale: 0.5,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
