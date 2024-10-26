import 'package:flutter/material.dart';

import '../helpers/apis.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback voidCallback;
  const AppButton({super.key, required this.title, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        width: Api().isTab()
            ? MediaQuery.of(context).size.width / 1.5
            : MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: Api().isSmallPhone() ? 12 : 16),
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
              blurRadius: 16.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                3.0,
              ),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: Api().isTab()
                  ? 28
                  : Api().isSmallPhone()
                      ? 16
                      : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
