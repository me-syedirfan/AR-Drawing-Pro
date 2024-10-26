import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/apis.dart';

class IntroScreen5 extends StatelessWidget {
  const IntroScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Think Creative',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 40 : 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Ignite your creative potential with innovative tools and inspiration',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 22 : 14,
            color: Colors.black,
          ),
        ),
        SvgPicture.asset(
          'assets/images/bulb.svg',
          width: Api().isSmallPhone() ? 330 : MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
