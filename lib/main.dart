import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palestine_first_run/palestine_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';
import 'intro screens/intro.dart';
import 'screens/root.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  int? appOpenTime = sharedPreferences.getInt('appOpenTime');
  if (appOpenTime == null) {
    sharedPreferences.setInt('appOpenTime', 1);
  } else {
    appOpenTime = appOpenTime + 1;
    sharedPreferences.setInt('appOpenTime', appOpenTime);
  }

  bool isFirstRun = await PalFirstRun.isFirstRun();
  if (isFirstRun) {
    sharedPreferences.setInt('totalDrawings', 0);
    sharedPreferences.setInt('timeSpent', 0);
  }

  try {
    if (sharedPreferences.getBool('isCodeUsed')!) {
      debugPrint('Super user');
      sharedPreferences.setBool('isPremium', true);
    }
  } catch (e) {
    debugPrint('Normal user');
  }

  runApp(MyApp(isFirstRun: isFirstRun));

  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission();
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint(apnsToken);
  }
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults({
    "intervalBetweenAds": 60000,
    "intervalBetweenRewardedAds": 900000,
    "adNetwork": Platform.isAndroid ? 'Unity' : 'AdMob',
  });

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 2),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
  }
  await remoteConfig.fetchAndActivate();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  const MyApp({super.key, this.isFirstRun = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Drawing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'urbanist',
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF0F0F0)),
        primarySwatch: Colors.orange,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFFEE712B)),
          ),
        ),
      ),
      home: isFirstRun ? const Intro() : const Root(),
      // home: widget.isFirstRun ? const Intro() : const Root(),
    );
  }
}
