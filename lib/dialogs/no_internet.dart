import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NoInternet extends StatelessWidget {
  final String message;
  const NoInternet({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    late VideoPlayerController controller;
    controller = VideoPlayerController.asset('assets/animations/noInternet.mp4')
      ..initialize().then((_) {});
    controller.play();
    controller.setLooping(true);
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.width / 1.05,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: VideoPlayer(controller)),
            ),
            const Text(
              'No Internet',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.black87,
                  ),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
