import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/apis.dart';

class IntroScreen4 extends StatelessWidget {
  const IntroScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Stay on track, set daily remainders',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 40 : 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Turn on notification and set a daily remainder to a',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Api().isTab() ? 22 : 14,
            color: Colors.black,
          ),
        ),
        SvgPicture.asset(
          'assets/images/notifications.svg',
          width: Api().isSmallPhone() ? 330 : MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
