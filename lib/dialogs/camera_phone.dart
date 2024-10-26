import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/apis.dart';
import '../screens/camera.dart';
import '../screens/phone.dart';

class CameraOrPhoneDialog extends StatelessWidget {
  final String text;
  const CameraOrPhoneDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await FirebaseAnalytics.instance.logSelectContent(
                    contentType: "drawingMethod",
                    itemId: 'Camera',
                  );
                  Api().customNavigator(
                      Camera(
                        text: text,
                      ),
                      context);
                },
                child: Container(
                  height: 115,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFDC4712),
                          Color(0xFFEE712B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 9,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.camera,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height / 16,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Trace with camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await FirebaseAnalytics.instance.logSelectContent(
                    contentType: "drawingMethod",
                    itemId: 'Trace',
                  );
                  Navigator.pop(context);

                  Api().customNavigator(Phone(text: text), context);
                },
                child: Container(
                  height: 115,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFDC4712),
                          Color(0xFFEE712B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 9,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.pen,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height / 16,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Trace on the device',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
