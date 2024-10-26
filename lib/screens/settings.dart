import 'dart:io';

import 'package:ardrawing_pro/widgets/settings_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../helpers/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  late final NotificationService notificationService;
  String appVersion = '';
  bool remainders = false;
  int time = 0;
  int times = 0;

  void init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    appVersion = '$version($buildNumber)';

    await FirebaseAnalytics.instance.logScreenView(screenName: 'Settings');

    if (sharedPreferences.getInt('time') != null) {
      time = sharedPreferences.getInt('time')!;
    }
    if (sharedPreferences.getBool('remainders') != null) {
      remainders = sharedPreferences.getBool('remainders')!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
  }

  Future<void> remainderDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      onConfirm: (date) async {
        await notificationService
            .showScheduledLocalNotification(
          id: 0,
          title: "Ar you there?",
          body: 'It\'s time for your drawing practice',
          time: tz.TZDateTime.from(date, tz.local),
        )
            .then((value) {
          time = date.millisecondsSinceEpoch;
          sharedPreferences.setBool('remainders', true);
          sharedPreferences.setInt('time', date.millisecondsSinceEpoch);
          debugPrint('Successfully set notifiation');
          var snackBar = const SnackBar(
            content: Text('Notification scheduled successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {});
        }).onError((error, stackTrace) {
          debugPrint('Remainder Error $error');
          sharedPreferences.setBool('remainders', false);
          var snackBar = const SnackBar(
            content: Text('Failed to scheduled notification'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
      currentTime: DateTime.now(),
    );
  }

  String getTime() {
    var dt = DateTime.fromMillisecondsSinceEpoch(time);
    var date = DateFormat('hh:mm a').format(dt);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.osdifa.ardrawing'
        : "https://apps.apple.com/app/idcom.osdifa.ardrawing_pro";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Practice Notification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: remainders,
                        activeColor: const Color(0xFFEE712B),
                        onChanged: (val) async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setBool('remainders', val);
                          if (!val) {
                            final FlutterLocalNotificationsPlugin
                                flutterLocalNotificationsPlugin =
                                FlutterLocalNotificationsPlugin();
                            await flutterLocalNotificationsPlugin.cancelAll();

                            var snackBar = const SnackBar(
                              content: Text('Unscheduled all notification'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          setState(() {
                            remainders = val;
                          });
                        },
                      ),
                    ],
                  ),
                  if (remainders) const SizedBox(height: 12),
                  if (remainders)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notification Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            remainderDialog();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Text(
                              getTime(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SettingsButton(
                    iconData: Ionicons.help,
                    title: 'How to use',
                    voidCallback: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          late VideoPlayerController controller;
                          controller = VideoPlayerController.asset(
                              'assets/videos/intro.mp4')
                            ..initialize().then((_) {});
                          controller.play();
                          return Dialog(
                            backgroundColor: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'How to use',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: VideoPlayer(controller)),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SettingsButton(
                    iconData: Ionicons.share_outline,
                    title: 'Share',
                    voidCallback: () {
                      ShareExtend.share(
                          "Hey, check out this cool app! It's a fun app that lets you create amazing art. You can download it from here $url and join the AR Draw community.",
                          "text",
                          subject: "",
                          extraText: "share subject");
                    },
                  ),
                  SettingsButton(
                    iconData: Ionicons.star,
                    title: 'Rate us',
                    voidCallback: () {
                      launchUrl(Uri.parse(Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=com.osdifa.ardrawing'
                          : "https://apps.apple.com/app/idcom.osdifa.ardrawing_pro"));
                    },
                  ),
                  SettingsButton(
                    iconData: Ionicons.bulb,
                    title: 'Feedback',
                    voidCallback: () async {
                      String email =
                          Uri.encodeComponent("osdifaofficial@gmail.com");
                      String subject = Uri.encodeComponent("Feedback");
                      String body = Uri.encodeComponent("");
                      Uri mail = Uri.parse(
                          "mailto:$email?subject=$subject&body=$body");
                      await launchUrl(mail);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse(
                              'https://ardrawing.web.app/privacy_policy.html'))) {
                            throw Exception('Could not launch url');
                          }
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (!await launchUrl(
                              Uri.parse('https://ardrawing.web.app/'))) {
                            throw Exception('Could not launch url');
                          }
                        },
                        child: const Text(
                          'Know More',
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  times++;
                  if (times > 5) {
                    var snackBar = const SnackBar(
                      content: Text('YO <3'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.black,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  appVersion,
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
