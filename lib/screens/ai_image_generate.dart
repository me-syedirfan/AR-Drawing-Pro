// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:ardrawing_pro/dialogs/customDialog.dart';
import 'package:ardrawing_pro/screens/ai_examples.dart';
import 'package:ardrawing_pro/screens/ai_image_result.dart';
import 'package:ardrawing_pro/widgets/button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../helpers/apis.dart';

class AIImageGenerate extends StatefulWidget {
  const AIImageGenerate({super.key});

  @override
  State<AIImageGenerate> createState() => _AIImageGenerateState();
}

class _AIImageGenerateState extends State<AIImageGenerate> {
  TextEditingController controller = TextEditingController();
  String selectedStyle = 'Anime';
  bool isLoading = true;

  List examples = [];

  List<String> styles = [
    'Anime',
    'Line Art',
    'Comic Book',
    'Art',
    'Photorealism',
  ];

  init() async {
    await FirebaseAnalytics.instance
        .logScreenView(screenName: 'AI Image Generator');
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/examples.json');
    final data = await json.decode(response);
    examples = data['examples'];
    examples.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    init();
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'AI Generator',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'dazzle',
                              fontWeight: FontWeight.bold,
                              fontSize: Api().isTab() ? 32 : 26,
                            ),
                          ),
                          const SizedBox(width: 6),
                          SvgPicture.asset(
                            'assets/images/stars.svg',
                            // ignore: deprecated_member_use
                            color: Colors.black,
                            width: Api().isTab() ? 42 : 30,
                          )
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.orangeAccent)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        height: MediaQuery.of(context).size.height / 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Enter prompt',
                              style: TextStyle(
                                fontSize: Api().isTab() ? 28 : 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height / 5 - 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      maxLines: null,
                                      maxLength: 2000,
                                      keyboardType: TextInputType.multiline,
                                      controller: controller,
                                      style: TextStyle(
                                        fontSize: Api().isTab() ? 22 : 16,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter your prompt or tap the dice icon to get random prompt',
                                        hintMaxLines: 6,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Ionicons.dice_outline),
                                    onPressed: () {
                                      final random = Random();
                                      setState(() {
                                        controller.text = Api().randomPrompts[
                                            random.nextInt(
                                                Api().randomPrompts.length)];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.orangeAccent)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Style',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 127,
                              margin: const EdgeInsets.only(top: 6),
                              child: ListView.builder(
                                itemCount: styles.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      selectedStyle = styles[index];
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedStyle == styles[index]
                                              ? const Color(0xFFDC4712)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.asset(
                                              'assets/images/Styles/${styles[index]}.webp',
                                              width: 90,
                                              height: 90,
                                              cacheWidth: 280,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            styles[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: AppButton(
                            title: 'Generate',
                            voidCallback: () async {
                              if (controller.text.isNotEmpty) {
                                if (await Api().checkInternetStatus(context)) {
                                  // if (true) {
                                  final remoteConfig =
                                      FirebaseRemoteConfig.instance;
                                  bool isInReview =
                                      remoteConfig.getBool('isInReview');

                                  final filter = ProfanityFilter();
                                  List<String> wordsFound =
                                      filter.getAllProfanity(controller.text);

                                  if (isInReview) {
                                    DatabaseReference ref =
                                        FirebaseDatabase.instance.ref(
                                            "ai-prompts/${DateTime.now().millisecondsSinceEpoch}");

                                    await ref.set({
                                      "prompt": controller.text,
                                      "styles": selectedStyle,
                                      "allowed": filter.hasProfanity(
                                                  controller.text) ||
                                              Api().containsBadWords(
                                                  controller.text)
                                          ? false
                                          : true
                                    });
                                  }

                                  if (filter.hasProfanity(controller.text) ||
                                      Api().containsBadWords(controller.text)) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        imagePath: 'assets/images/error.svg',
                                        title: 'Unable to Proceed',
                                        message:
                                            'Your prompt contains Profanity. Correct your prompt and try again ${wordsFound.isNotEmpty ? '\nwords found $wordsFound' : ''}',
                                        buttonTitle: 'Ok',
                                        voidCallback: () =>
                                            Navigator.pop(context),
                                      ),
                                    );
                                  } else {
                                    Api().customNavigator(
                                        AIImageResult(
                                          prompt: controller.text,
                                          style: selectedStyle,
                                        ),
                                        context);
                                  }
                                }
                              }
                            }),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Try Examples',
                        style: TextStyle(
                          fontSize: Api().isTab() ? 32 : 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        itemCount: Api().isTab() ? 12 : 10,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Api().isTab() ? 3 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await FirebaseAnalytics.instance
                                  .logScreenView(screenName: 'AI Example');
                              Api().customNavigator(
                                  AIExamples(item: examples[index]), context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: const Color(0xFFEE712B)),
                                  borderRadius: BorderRadius.circular(12)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  examples[index]['path'],
                                  fit: BoxFit.cover,
                                  cacheWidth: 500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
