import 'package:flutter/material.dart';

import '../helpers/apis.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback voidCallback;
  const SettingsButton(
      {super.key,
      required this.iconData,
      required this.title,
      required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Api().isTab() ? 90 : 70,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEE712B),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: Api().isTab() ? 34 : 24,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Api().isTab() ? 24 : 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
