// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/apis.dart';
import 'selected_image.dart';

class AIImageResult extends StatefulWidget {
  final String prompt, style;
  const AIImageResult({super.key, required this.prompt, required this.style});

  @override
  State<AIImageResult> createState() => _AIImageResultState();
}

class _AIImageResultState extends State<AIImageResult> {
  Uint8List? uint8list;
  bool isLoading = true;
  String animation = '';
  @override
  void initState() {
    init();
    final random = Random();

    animation =
        Api().animationsNames[random.nextInt(Api().animationsNames.length)];
    animation = 'assets/animations/$animation.json';
    super.initState();
  }

  init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    String api = remoteConfig.getString('prodiaApi');

    try {
      debugPrint('Trying to create image');
      final response = await http.post(
        Uri.parse('https://api.prodia.com/v1/sdxl/generate'),
        headers: <String, String>{
          "accept": "application/json",
          "content-type": "application/json",
          "X-Prodia-Key": api
        },
        body: jsonEncode(<String, dynamic>{
          "prompt": widget.prompt,
          "negative_prompt": 'badly drawn, ugly, complex',
          'style_preset': widget.style.replaceAll(' ', '-').toLowerCase(),
          "width": 1024,
          "height": 1024
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        var job = responseData['job'];

        debugPrint('Job Created $job');
        bool isImageNotCreated = true;
        while (isImageNotCreated) {
          debugPrint('Check if job completed');
          final response =
              await http.get(Uri.parse('https://images.prodia.xyz/$job.png'));

          if (response.statusCode == 200) {
            isImageNotCreated = false;
            setState(() {
              isLoading = false;
              uint8list = response.bodyBytes;
            });
            final dir = await getApplicationDocumentsDirectory();
            var filename =
                '${dir.path}/${Api().generateRandomString()}-${DateTime.now()}.png';

            File(filename).writeAsBytes(uint8list!);

            await ImageGallerySaver.saveImage(uint8list!);

            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            if (sharedPreferences.getStringList('aiImages') != null) {
              List<String> aiImages =
                  sharedPreferences.getStringList('aiImages')!;
              aiImages.add(filename);
              sharedPreferences.setStringList('aiImages', aiImages);
            } else {
              List<String> aiImages = [];
              aiImages.add(filename);
              sharedPreferences.setStringList('aiImages', aiImages);
            }

            var snackBar = const SnackBar(
              content: Text('Image saved to gallery <3'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            debugPrint('Not created yet');
          }
        }
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    await FirebaseAnalytics.instance
        .logScreenView(screenName: 'AI Image Result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'dazzle',
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: isLoading
                        ? LottieBuilder.asset(
                            animation,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 32,
                          )
                        : Image(
                            image: MemoryImage(uint8list!) as ImageProvider,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 32,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.orangeAccent)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    widget.prompt,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Api().customNavigator(
                        SelectedImage(uint8List: uint8list!), context);
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFDC4712),
                          Color(0xFFEE712B),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC4712).withAlpha(200),
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                          offset: const Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Countinue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFDC4712),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Re-Generate',
                        style: TextStyle(
                          color: Color(0xFFDC4712),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
