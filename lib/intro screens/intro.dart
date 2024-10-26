import 'package:ardrawing_pro/intro%20screens/intro_screen.dart';
import 'package:ardrawing_pro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../helpers/apis.dart';
import '../screens/root.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                ScrollLoopAutoScroll(
                  reverseScroll: true,
                  duration: const Duration(seconds: 40),
                  scrollDirection: Axis.horizontal,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: Api().isTab() ? 250 * 5.3 : 150 * 5.4,
                    height: Api().isTab() ? 250 : 150,
                    child: ListView.builder(
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: index != 1 || index != 7 ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                             Api().examples[index],
                              height: 250,
                              fit: BoxFit.cover,
                              cacheWidth: 250,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ScrollLoopAutoScroll(
                  reverseScroll: false,
                  duration: const Duration(seconds: 40),
                  scrollDirection: Axis.horizontal,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: Api().isTab() ? 250 * 5.3 : 150 * 5.4,
                    height: Api().isTab() ? 250 : 150,
                    child: ListView.builder(
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: index != 1 || index != 7 ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              Api().examples[index + 5],
                              height: 250,
                              fit: BoxFit.cover,
                              cacheWidth: 250,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ScrollLoopAutoScroll(
                  reverseScroll: true,
                  duration: const Duration(seconds: 40),
                  scrollDirection: Axis.horizontal,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: Api().isTab() ? 250 * 5.3 : 150 * 5.4,
                    height: Api().isTab() ? 250 : 150,
                    child: ListView.builder(
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: index != 1 || index != 7 ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              Api().examples[index + 10],
                              height: 250,
                              fit: BoxFit.cover,
                              cacheWidth: 250,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ScrollLoopAutoScroll(
                  reverseScroll: false,
                  duration: const Duration(seconds: 40),
                  scrollDirection: Axis.horizontal,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: Api().isTab() ? 250 * 5.3 : 150 * 5.4,
                    height: Api().isTab() ? 250 : 150,
                    child: ListView.builder(
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: index != 1 || index != 7 ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              Api().examples[index + 15],
                              height: 250,
                              fit: BoxFit.cover,
                              cacheWidth: 250,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: Api().isTab()
                  ? MediaQuery.of(context).size.height / 1.7
                  : MediaQuery.of(context).size.height / 1.5,
              padding: const EdgeInsets.only(bottom: 22, right: 12, left: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Color(0x71FFFFFF),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AR Drawing',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Api().isTab()
                                  ? 52
                                  : Api().isSmallPhone()
                                      ? 32
                                      : 38,
                              height: 1.2,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                              width: Api().isTab()
                                  ? 12
                                  : Api().isSmallPhone()
                                      ? 3
                                      : 6),
                          SvgPicture.asset('assets/images/miniLogo.svg',
                              height: Api().isTab()
                                  ? 52
                                  : Api().isSmallPhone()
                                      ? 28
                                      : 36),
                        ],
                      ),
                      Text(
                        'You\'re able to draw anything you want',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Api().isTab()
                              ? 32
                              : Api().isSmallPhone()
                                  ? 18
                                  : 24,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4.2+ ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Api().isTab()
                                          ? 28
                                          : Api().isSmallPhone()
                                              ? 16
                                              : 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'rating',
                                    style: TextStyle(
                                      fontSize: Api().isTab()
                                          ? 28
                                          : Api().isSmallPhone()
                                              ? 16
                                              : 18,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      AppButton(
                          title: 'Get Started',
                          voidCallback: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context, Api().getRoute(const IntroScreen()));
                          }),
                      SizedBox(height: Api().isTab() ? 8 : 2),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, Api().getRoute(const Root()));
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Api().isTab()
                                ? 28
                                : Api().isSmallPhone()
                                    ? 16
                                    : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: Api().isTab() ? 20 : 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
