// ignore_for_file: use_build_context_synchronously

import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/screens/categories.dart';
import 'package:ardrawing_pro/widgets/home_category_list.dart';
import 'package:ardrawing_pro/widgets/home_trending_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:palestine_first_run/palestine_first_run.dart';

import '../intro screens/ai_image_intro.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? categories;

  Future<void> init() async {
    if (await PalFirstRun.isFirstRun('firstTimeLoadingCategories')) {
      categories = ['Anime', 'Sketches', 'Cute'];
    } else {
      categories = Api().categoriesForHome;
      categories!.shuffle();
    }
    setState(() {});
    await FirebaseAnalytics.instance.logScreenView(screenName: 'Home');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AR Drawing',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'dazzle',
                    fontWeight: FontWeight.bold,
                    fontSize: Api().isTab() ? 32 : 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Trending 🔥',
              style: TextStyle(
                fontSize: Api().isTab() ? 32 : 20,
              ),
            ),
            SizedBox(height: Api().isTab() ? 12 : 6),
            const HomeTrendingList(),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                if (await Api().checkInternetStatus(context)) {
                  Api().customNavigator(const AIImageIntro(), context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Api().isTab()
                    ? 150
                    : MediaQuery.of(context).size.width / 4.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedMeshGradient(
                    colors: const [
                      Color(0xFFDC4712),
                      Color(0xFFEE7D3C),
                      Color(0xFFEE7D3C),
                      Color(0xFFDC4712),
                    ],
                    options: AnimatedMeshGradientOptions(speed: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Generate Image with ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Api().isTab() ? 33 : 20,
                          ),
                        ),
                        Text(
                          'AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Api().isTab() ? 38 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          'assets/images/stars.svg',
                          width: Api().isTab() ? 40 : 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return categories == null
                    ? const SizedBox()
                    : HomeCategoryList(
                        category: categories![index],
                      );
              },
            ),
            InkWell(
              onTap: () async {
                Api().customNavigator(const Categories(), context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Api().isTab()
                    ? 150
                    : MediaQuery.of(context).size.width / 4.5,
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedMeshGradient(
                    colors: const [
                      Color(0xFFDC4712),
                      Color(0xFFEE7D3C),
                      Color(0xFFEE7D3C),
                      Color(0xFFDC4712),
                    ],
                    options: AnimatedMeshGradientOptions(speed: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View More Pictures',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Api().isTab() ? 34 : 20,
                          ),
                        ),
                        SizedBox(width: Api().isTab() ? 12 : 6),
                        Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: Colors.white,
                          size: Api().isTab() ? 42 : 32,
                        ),
                      ],
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
