import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/intro%20screens/intro_screeen1.dart';
import 'package:ardrawing_pro/intro%20screens/intro_screeen2.dart';
import 'package:ardrawing_pro/screens/root.dart';
import 'package:ardrawing_pro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../dialogs/remainder.dart';
import 'intro_screeen3.dart';
import 'intro_screeen4.dart';
import 'intro_screeen5.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List screens = [
    const IntroScreen1(),
    const IntroScreen2(),
    const IntroScreen3(),
    const IntroScreen4(),
    const IntroScreen5()
  ];

  int currentScreen = 0;
  double value = 0.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Api().isTab() ? 32 : 16),
                child: SimpleAnimationProgressBar(
                  height: 25,
                  width: MediaQuery.of(context).size.width / 1.5,
                  backgroundColor: Colors.grey.shade300,
                  foregrondColor: Colors.orange,
                  ratio: value,
                  direction: Axis.horizontal,
                  gradientColor: const LinearGradient(colors: [
                    Color(0xFFDC4712),
                    Color(0xFFEE712B),
                  ]),
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(seconds: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: const Interval(0.5, 1.0),
                          ),
                        ),
                        child: child,
                      );
                    },
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                    child: screens[currentScreen],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Api().isTab() ? 38 : 18,
                  horizontal: 16,
                ),
                child: AppButton(
                  title: value == 1 ? 'Get Started' : 'Continue',
                  voidCallback: () {
                    if (value == 0.8) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const RemainderDialog();
                          });
                    }
                    if (value == 1) {
                      Navigator.pop(context);
                      Navigator.push(context, Api().getRoute(const Root()));
                    } else {
                      value = value + 0.2;
                      currentScreen++;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
