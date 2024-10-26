import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/widgets/button.dart';
import 'package:ardrawing_pro/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../screens/ai_image_generate.dart';

class AIImageIntro extends StatelessWidget {
  const AIImageIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [
                Color(0xFFDC4712),
                Colors.black,
              ], radius: 1),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height,
                      child: ScrollLoopAutoScroll(
                        reverseScroll: false,
                        duration: const Duration(seconds: 70),
                        scrollDirection: Axis.vertical,
                        enableScrollInput: false,
                        duplicateChild: 2,
                        gap: 0,
                        delay: const Duration(seconds: 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: 275 * 7,
                          child: ListView.builder(
                            itemCount: 7,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: index != 1 || index != 7 ? 20 : 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  ),
                                  child: Image.asset(
                                    Api().examples[index],
                                    height: Api().isTab() ? 450 : 250,
                                    fit: BoxFit.cover,
                                    cacheWidth: 300,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height,
                child: ScrollLoopAutoScroll(
                  reverseScroll: true,
                  duration: const Duration(seconds: 70),
                  scrollDirection: Axis.vertical,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 275 * 7,
                    child: ListView.builder(
                      itemCount: 7,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: index != 1 || index != 7 ? 20 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              Api().examples[index + 7],
                              height: Api().isTab() ? 450 : 250,
                              fit: BoxFit.cover,
                              cacheWidth: 400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height,
                child: ScrollLoopAutoScroll(
                  reverseScroll: false,
                  duration: const Duration(seconds: 70),
                  scrollDirection: Axis.vertical,
                  enableScrollInput: false,
                  duplicateChild: 2,
                  gap: 0,
                  delay: const Duration(seconds: 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 275 * 7,
                    child: ListView.builder(
                      itemCount: 7,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: index != 1 || index != 7 ? 20 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            ),
                            child: Image.asset(
                              Api().examples[index + 14],
                              height: Api().isTab() ? 450 : 250,
                              fit: BoxFit.cover,
                              cacheWidth: 300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: Api().isTab()
                ? MediaQuery.of(context).size.height / 1.8
                : MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(bottom: 22, right: 12, left: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GradientText(
                  'Transform your\nImagination into\nStunning Visuals',
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDC4712),
                      Color(0xFFEE712B),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Api().isTab() ? 44 : 32,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: Api().isTab() ? 32 : 16),
                AppButton(
                  title: 'Get Started',
                  voidCallback: () {
                    Navigator.pop(context);

                    Api().customNavigator(const AIImageGenerate(), context);
                  },
                ),
                SizedBox(height: Api().isTab() ? 32 : 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
