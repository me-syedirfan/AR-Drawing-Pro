// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:ardrawing_pro/dialogs/camera_phone.dart';
import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/widgets/button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextArt extends StatefulWidget {
  const TextArt({super.key});

  @override
  State<TextArt> createState() => _TextArtState();
}

class _TextArtState extends State<TextArt> {
  String selected = 's';
  String text = 'Enter your text here';
  TextEditingController controller = TextEditingController();

  Future<void> init() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: 'Text Art');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Art',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'dazzle',
              fontWeight: FontWeight.bold,
              fontSize: Api().isTab() ? 32 : 26,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              style: TextStyle(
                fontSize: Api().isTab() ? 42 : 32,
                fontFamily: selected,
                color: Colors.black,
              ),
              maxLines: null,
              expands: true,
              cursorColor: const Color(0xFFDC4712),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hoverColor: const Color(0xFFDC4712),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFDC4712), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFDC4712),
                    width: 2.0,
                  ),
                ),
                hintText: 'Enter your text here',
              ),
              onChanged: (value) {
                setState(() {
                  if (value == '') {
                    text = 'Enter your text here';
                  } else {
                    text = value;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 74),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Api().isTab() ? 3 : 2,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.8,
                      crossAxisSpacing: 10),
                  itemCount: 24,
                  itemBuilder: (BuildContext contet, int index) {
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          selected = Api().fontsFamilies[index];
                        });
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            'selectedFont', Api().fontsFamilies[index]);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: selected == Api().fontsFamilies[index]
                                  ? Border.all(
                                      width: 2,
                                      color: const Color(0xFFDC4712),
                                    )
                                  : Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                            ),
                            child: Center(
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: Api().isTab() ? 32 : 24,
                                  fontFamily: Api().fontsFamilies[index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  margin:
                      const EdgeInsets.only(bottom: 12, right: 22, left: 22),
                  child: AppButton(
                      title: 'Next',
                      voidCallback: () async {
                        await FirebaseAnalytics.instance.logSelectContent(
                          contentType: "textArt",
                          itemId: selected,
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CameraOrPhoneDialog(
                                text: text,
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
