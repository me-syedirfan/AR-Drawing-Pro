import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/apis.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Experience Drawing in a New Dimension',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 40 : 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Draw directly on your surroundings and watch your creations come alive in the real world.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 22 : 14,
            color: Colors.black,
          ),
        ),
        SvgPicture.asset(
          'assets/images/pen.svg',
          width: Api().isSmallPhone() ? 330 : MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
