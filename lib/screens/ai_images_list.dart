import 'dart:io';
import 'dart:typed_data';

import 'package:ardrawing_pro/widgets/category_image_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIImagesList extends StatefulWidget {
  const AIImagesList({super.key});

  @override
  State<AIImagesList> createState() => _AIImagesListState();
}

class _AIImagesListState extends State<AIImagesList> {
  List<Uint8List> images = [];

  init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> list = sharedPreferences.getStringList('aiImages')!;
    for (var element in list) {
      if (await File(element).exists()) {
        File file = File(element);
        Uint8List uint8list = file.readAsBytesSync();
        images.add(uint8list);
        setState(() {});
      }
    }

    await FirebaseAnalytics.instance
        .logScreenView(screenName: 'User Generated AI Images');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Generated Images',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: images.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const CategoryImageCard(
                imageUrl: 'images[index]',
                category: 'AI Examples',
              );
            },
          ),
        ),
      ),
    );
  }
}
