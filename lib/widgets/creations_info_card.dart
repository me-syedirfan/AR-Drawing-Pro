import 'package:flutter/material.dart';

import '../helpers/apis.dart';

class CreationsInfoCard extends StatelessWidget {
  final String title, info;
  const CreationsInfoCard({super.key, required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    String getMinsInHours(int i) {
      if (i >= 60) {
        double d = i / 60;
        return d.toStringAsPrecision(2);
      } else {
        return '$i';
      }
    }

    String getTimeSuffix(int i) {
      if (i >= 60) {
        return ' hrs';
      } else {
        return ' mins';
      }
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEA874E), 
              Color(0xFFEE712B), 
              // Color.fromARGB(255, 237, 147, 114), 
              // Color.fromARGB(255, 231, 138, 85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Api().isTab() ? 28 : 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title.contains('time')
                      ? getMinsInHours(int.parse(info))
                      : info,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'dazzle',
                    fontWeight: FontWeight.bold,
                    fontSize: Api().isTab() ? 40 : 26,
                  ),
                ),
                if (title.contains('time'))
                  Text(
                    getTimeSuffix(int.parse(info)),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Api().isTab() ? 34 : 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
