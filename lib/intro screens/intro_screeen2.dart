import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/apis.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '500+ Arts to choose from',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 40 : 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Find the perfect art style from our extensive library of 500+ options',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: Api().isTab() ? 22 : 14,
          ),
        ),
        SvgPicture.asset(
          'assets/images/arts.svg',
          width: Api().isSmallPhone() ? 330 : MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
