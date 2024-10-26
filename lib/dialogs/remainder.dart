import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class RemainderDialog extends StatefulWidget {
  const RemainderDialog({super.key});

  @override
  State<RemainderDialog> createState() => _RemainderDialogState();
}

class _RemainderDialogState extends State<RemainderDialog> {
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
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
          sharedPreferences.setBool('remainders', true);
          sharedPreferences.setInt('time', date.millisecondsSinceEpoch);
          debugPrint('Successfully set notification');
        }).onError((error, stackTrace) {
          debugPrint('Remainder Error $error');
          sharedPreferences.setBool('remainders', false);
        });
      },
      currentTime: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: Api().isTab() ? 550 : 400,
        width: Api().isTab() ? 600 : MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Api().isTab() ? 26 : 16,
            vertical: Api().isTab() ? 16 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Practice makes Perfect!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Api().isTab() ? 32 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Set a remainder to practice your drawing skills.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Api().isTab() ? 27 : 17,
              ),
            ),
            SizedBox(height: Api().isTab() ? 18 : 8),
            SizedBox(
              height: Api().isTab() ? 300 : 240,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SvgPicture.asset(
                    'assets/images/practie.svg',
                    fit: BoxFit.contain,
                  )),
            ),
            SizedBox(height: Api().isTab() ? 18 : 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await FirebaseAnalytics.instance.logEvent(
                      name: "habit_dialog",
                      parameters: {
                        "action": "No Thanks",
                      },
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No Thanks",
                    style: TextStyle(
                        fontSize: Api().isTab() ? 27 : 17,
                        color: Colors.orange),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    remainderDialog();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        fontSize: Api().isTab() ? 27 : 17,
                        color: Colors.orange),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
