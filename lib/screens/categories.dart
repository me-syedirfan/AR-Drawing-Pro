import 'dart:math';
import 'dart:typed_data';

import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/screens/ai_image_generate.dart';
import 'package:ardrawing_pro/screens/ai_images_list.dart';
import 'package:ardrawing_pro/screens/category_images.dart';
import 'package:ardrawing_pro/screens/selected_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int num = 0;
  int exampleImageNumber = 0;
  bool aiImages = false;

  init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getStringList('aiImages') != null) {
      aiImages = true;
    } else {
      debugPrint('No AI images found');
    }

    Random random = Random();
    exampleImageNumber = random.nextInt(20);
    setState(() {});

    await FirebaseAnalytics.instance.logScreenView(screenName: 'Categories');
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'dazzle',
                    fontWeight: FontWeight.bold,
                    fontSize: Api().isTab() ? 32 : 26,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      final Uint8List bytes = await image.readAsBytes();
                      Api().customNavigator(
                          SelectedImage(uint8List: bytes), context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Api().isTab() ? 18 : 12,
                      horizontal: Api().isTab() ? 26 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE712B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Api().isTab() ? 38 : 28,
                          backgroundColor: const Color(0xFFF1E9E3),
                          child: Icon(
                            CupertinoIcons.photo_on_rectangle,
                            color: const Color(0xFFEE712B),
                            size: Api().isTab() ? 42 : 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select from gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Api().isTab() ? 26 : 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getBool('browser_tutorial') != null) {
                      final Uri url = Uri.parse(
                          'https://www.google.com/search?q=simple+line+drawing&sca_esv=590380016&tbm=isch&source=lnms&sa=X&ved=2ahUKEwiXyd2rsIyDAxViT2wGHUX1AXUQ_AUoAXoECAEQAw&biw=1358&bih=646&dpr=1');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                height: 370,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Steps to Download',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Step 1 - Select the picture and save it to photos',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/step1.webp',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Step 2 - Close browser and click select from gallery',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/step2.webp',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setBool(
                                                'browser_tutorial', true);
                                            final Uri url = Uri.parse(
                                                'https://www.google.com/search?q=simple+line+drawing&sca_esv=590380016&tbm=isch&source=lnms&sa=X&ved=2ahUKEwiXyd2rsIyDAxViT2wGHUX1AXUQ_AUoAXoECAEQAw&biw=1358&bih=646&dpr=1');
                                            if (!await launchUrl(url)) {
                                              throw Exception(
                                                  'Could not launch $url');
                                            }
                                          },
                                          child: const Text(
                                            "Don't show again",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orange),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final Uri url = Uri.parse(
                                                'https://www.google.com/search?q=simple+line+drawing&sca_esv=590380016&tbm=isch&source=lnms&sa=X&ved=2ahUKEwiXyd2rsIyDAxViT2wGHUX1AXUQ_AUoAXoECAEQAw&biw=1358&bih=646&dpr=1');
                                            if (!await launchUrl(url)) {
                                              throw Exception(
                                                  'Could not launch $url');
                                            }
                                          },
                                          child: const Text(
                                            "Ok",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Api().isTab() ? 18 : 12,
                      horizontal: Api().isTab() ? 26 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE712B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Api().isTab() ? 38 : 28,
                          backgroundColor: const Color(0xFFF1E9E3),
                          child: Icon(
                            CupertinoIcons.globe,
                            color: const Color(0xFFEE712B),
                            size: Api().isTab() ? 42 : 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select from Internet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Api().isTab() ? 26 : 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (aiImages) const SizedBox(height: 8),
                if (aiImages)
                  InkWell(
                    onTap: () async {
                      Api().customNavigator(const AIImagesList(), context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Api().isTab() ? 18 : 12,
                        horizontal: Api().isTab() ? 26 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE712B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Api().isTab() ? 38 : 28,
                            backgroundColor: const Color(0xFFF1E9E3),
                            child: SvgPicture.asset(
                              'assets/images/stars.svg',
                              // ignore: deprecated_member_use
                              color: const Color(0xFFEE712B),
                              height: Api().isTab() ? 42 : 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Your AI Generated Images',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Api().isTab() ? 26 : 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  'App Library',
                  style: TextStyle(
                    fontSize: Api().isTab() ? 28 : 22,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Api().customNavigator(const AIImageGenerate(), context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 12),
                    height: Api().isTab() ? 120 : 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFDC4712),
                          Color(0xFFEE712B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/Examples/$exampleImageNumber.webp',
                              height: Api().isTab() ? 90 : 65,
                              width: Api().isTab() ? 90 : 65,
                              fit: BoxFit.cover,
                              cacheWidth: 150,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          'Generate AI Images',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Api().isTab() ? 26 : 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: Api().categories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await FirebaseAnalytics.instance.logSelectContent(
                          contentType: "category",
                          itemId: Api().categories[index],
                        );
                        Api().customNavigator(
                            CategoryImages(category: Api().categories[index]),
                            context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: Api().isTab() ? 120 : 80,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFDC4712),
                              Color(0xFFEE712B),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/Thumbnails/${Api().categories[index]}.webp',
                                  height: Api().isTab() ? 90 : 65,
                                  width: Api().isTab() ? 90 : 65,
                                  fit: BoxFit.cover,
                                  cacheWidth: 200,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Text(
                              Api().categories[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Api().isTab() ? 26 : 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFolder(String key) {
    if (key == 'Doodles' || key == 'Sketches') {
      return 'lined';
    } else if (key == 'Cartoon' ||
        key == 'Food' ||
        key == 'Fruits' ||
        key == 'Vegetables') {
      return 'coloured';
    } else {
      num = num + 1;
      if (num.floor().isEven) {
        return 'lined';
      } else {
        num = num + 1;
        return 'coloured';
      }
    }
  }
}
