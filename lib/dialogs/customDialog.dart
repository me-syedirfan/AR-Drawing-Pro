import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../helpers/apis.dart';

class CustomDialog extends StatelessWidget {
  final String message, imagePath, title, buttonTitle;
  final VoidCallback voidCallback;
  const CustomDialog({
    super.key,
    required this.message,
    required this.imagePath,
    required this.title,
    required this.buttonTitle,
    required this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Api().isTab()
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width / 1.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath.endsWith('.svg'))
              SvgPicture.asset(
                imagePath,
                height: MediaQuery.of(context).size.height / 4,
              ),
            if (imagePath.endsWith('.json'))
              Lottie.asset(
                imagePath,
                width: 200,
                repeat: true,
                reverse: true,
              ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: voidCallback,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEE712B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
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
