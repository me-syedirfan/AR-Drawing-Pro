import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MyCreations extends StatefulWidget {
  final String type;
  const MyCreations({super.key, required this.type});

  @override
  State<MyCreations> createState() => _MyCreationsState();
}

class _MyCreationsState extends State<MyCreations> {
  bool isPhototSelected = true;

  String url = Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=com.osdifa.ardrawing'
      : "https://apps.apple.com/app/idcom.osdifa.ardrawing_pro";

  List<String> pictures = [];
  List<Uint8List> videos = [];
  List<String> videosPaths = [];

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pics = prefs.getStringList('photos');
    List<String>? vids = prefs.getStringList('videos');

    if (pics != null) {
      pics.forEach((element) async {
        if (await File(element).exists()) {
          pictures.add(element);
          setState(() {});
        }
      });
    }
    if (vids != null) {
      vids.forEach((element) async {
        if (await File(element).exists()) {
          final uint8list = await VideoThumbnail.thumbnailData(
            video: element,
            quality: 25,
          );
          videos.add(uint8list!);
          videosPaths.add(element);
          setState(() {});
        }
      });
    }
    
    await FirebaseAnalytics.instance.logScreenView(screenName: 'My Creations');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.type == 'Library'
                  ? Expanded(
                      child: pictures.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemCount: pictures.length,
                        physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                  onTap: () {
                                    OpenFilex.open(pictures[index]);
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  File(pictures[index]))),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                            onPressed: () {
                                              ShareExtend.share(
                                                  pictures[index], "image",
                                                  subject: 'Check it out!',
                                                  extraText:
                                                      "Hey, check out this cool drawing I made with AR Draw! It's a fun app that lets you create amazing art. You can download it from here $url and join the AR Draw community.");
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.share,
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Lottie.asset(
                                    'assets/animations/panda.json',
                                    height: 200,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Text(
                                  'No Pictures Found',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    )
                  : Expanded(
                      child: videos.isNotEmpty
                          ? GridView.builder(
                        physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemCount: videos.length,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 18),
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                  onTap: () {
                                    OpenFilex.open(videosPaths[index]);
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  MemoryImage(videos[index])),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                            onPressed: () {
                                              ShareExtend.share(
                                                  videosPaths[index], "video",
                                                  subject: 'Check it out!',
                                                  extraText:
                                                      "Hey, check out this cool drawing I made with AR Draw! It's a fun app that lets you create amazing art. You can download it from here $url and join the AR Draw community.");
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.share,
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Lottie.asset(
                                    'assets/animations/panda.json',
                                    height: 200,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Text(
                                  'No Videos Found',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
