import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/apis.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Draw Anywhere, Anytime',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 40 : 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Augmented reality will help you to draw on paper, wall and anywhere',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: Api().isTab() ? 22 : 14,
          ),
        ),
        SvgPicture.asset(
          'assets/images/palette.svg',
          width: Api().isSmallPhone() ? 330 : MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
