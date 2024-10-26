import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/screens/my_creations.dart';
import 'package:ardrawing_pro/screens/settings.dart';
import 'package:ardrawing_pro/widgets/creations_info_card.dart';
import 'package:ardrawing_pro/widgets/settings_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Creations extends StatefulWidget {
  const Creations({super.key});

  @override
  State<Creations> createState() => _CreationsState();
}

class _CreationsState extends State<Creations> {
  int time = 0;
  int drawings = 0;
  int appOpenTime = 0;

  List<String> pictures = [];
  List<Uint8List> videos = [];
  List<String> videosPaths = [];

  Timer? timer;

  bool customAd = false;
  String customAdImageUrl = '';
  String customAdUrl = '';

  @override
  void initState() {
    Api().getAppOpenTime().then((value) => appOpenTime = value);
    init();
    loadCustomAd();
    super.initState();
  }

  Future<void> init() async {
    pictures = [];
    videos = [];
    videosPaths = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    time = sharedPreferences.getInt('timeSpent')!;
    drawings = sharedPreferences.getInt('totalDrawings')!;
    setState(() {});

    List<String>? pics = sharedPreferences.getStringList('photos');
    List<String>? vids = sharedPreferences.getStringList('videos');

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

    await FirebaseAnalytics.instance.logScreenView(screenName: 'Creations');
  }

  void loadCustomAd() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    customAd = remoteConfig.getBool('customAd');
    if (customAd) {
      customAdImageUrl = remoteConfig.getString('customAdImageUrl');
      customAdUrl = remoteConfig.getString('customAdUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xFFEE712B),
        onRefresh: () => init(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Creations',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'dazzle',
                    fontWeight: FontWeight.bold,
                    fontSize: Api().isTab() ? 32 : 26,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CreationsInfoCard(
                        title: 'Total time spent\npracticing', info: '$time'),
                    const SizedBox(width: 12),
                    CreationsInfoCard(
                        title: 'Total drawings\nfinished', info: '$drawings'),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Library 🌠',
                      style: TextStyle(
                        fontSize: Api().isTab() ? 32 : 20,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Api().customNavigator(
                            const MyCreations(type: 'Library'), context);
                      },
                      child: Text(
                        'View more',
                        style: TextStyle(
                          fontSize: Api().isTab() ? 24 : 18,
                        ),
                      ),
                    ),
                  ],
                ),
                pictures.isEmpty
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/hotAirBaloonFloating.json',
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text(
                            'No Images Found',
                            style: TextStyle(
                              fontSize: Api().isTab() ? 22 : 18,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: MediaQuery.of(context).size.width / 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.builder(
                          itemCount: pictures.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(pictures[index]),
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                  cacheWidth: 250,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Videos 📼',
                      style: TextStyle(
                        fontSize: Api().isTab() ? 32 : 20,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Api().customNavigator(
                            const MyCreations(type: 'Videos'), context);
                      },
                      child: Text(
                        'View more',
                        style: TextStyle(
                          fontSize: Api().isTab() ? 24 : 18,
                        ),
                      ),
                    ),
                  ],
                ),
                videos.isEmpty
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/leavesFloating.json',
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text(
                            'No Videos Found',
                            style: TextStyle(
                              fontSize: Api().isTab() ? 24 : 18,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: MediaQuery.of(context).size.width / 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.builder(
                          itemCount: videos.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  videos[index],
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                  cacheWidth: 250,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                const SizedBox(height: 12),
                SettingsButton(
                  iconData: Ionicons.settings_outline,
                  title: 'Settings',
                  voidCallback: () {
                    Api().customNavigator(const AppSettings(), context);
                  },
                ),
                if (customAd)
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(customAdUrl))) {
                          throw Exception('Could not launch url');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 14),
                        width: 352.5,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: customAdImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (appOpenTime <= 10)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('swipe down to refresh'),
                    ),
                  ),
                Center(
                    child: Text(
                  'Made with ❤️ by Osdifa',
                  style: TextStyle(
                    fontFamily: 'v',
                    color: Colors.black87,
                    fontSize: Api().isTab() ? 24 : 16,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
