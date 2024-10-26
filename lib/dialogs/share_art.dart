import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareArt extends StatelessWidget {
  final SharedPreferences prefs;
  final XFile file;
  const ShareArt({super.key, required this.prefs, required this.file});

  @override
  Widget build(BuildContext context) {
    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.osdifa.ardrawing'
        : "https://apps.apple.com/app/idcom.osdifa.ardrawing_pro";
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share it!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Share your art with friends and family.',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(file.path),
                  cacheHeight: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await prefs.setBool('shareDrawing', true);
                  },
                  child: const Text(
                    "Don't show again",
                    style: TextStyle(fontSize: 17, color: Colors.orange),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    ShareExtend.share(file.path, "image",
                        subject: 'Check it out!',
                        extraText:
                            "Hey, check out this cool drawing I made with AR Draw! It's a fun app that lets you create amazing art. You can download it from here $url and join the AR Draw community.");
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 17, color: Colors.orange),
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
