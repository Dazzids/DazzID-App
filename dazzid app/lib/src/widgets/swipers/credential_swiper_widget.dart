import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CredentialSwiperWidget extends StatelessWidget {
  final List<Widget> credentials;
  final double height;

  const CredentialSwiperWidget(
      {Key key, @required this.credentials, @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: height,
      child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return credentials[index];
          },
          itemCount: credentials.length,
          viewportFraction: .8,
          scale: .9),
    );
  }
}
