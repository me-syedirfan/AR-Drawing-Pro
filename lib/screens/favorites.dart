import 'dart:async';

import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/screens/selected_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<String> favorites = [];
  late SharedPreferences sharedPreferences;
  Timer? timer;
  int appOpenTime = 0;

  @override
  void initState() {
    super.initState();
    init();
    Api().getAppOpenTime().then((value) => appOpenTime = value);
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getStringList('favorits') != null) {
      favorites = sharedPreferences.getStringList('favorits')!;
      setState(() {});
    } else {
      debugPrint('Favorites is empty');
    }

    await FirebaseAnalytics.instance.logScreenView(screenName: 'Favorites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xFFEE712B),
        onRefresh: () => init(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'dazzle',
                  fontWeight: FontWeight.bold,
                  fontSize: Api().isTab() ? 32 : 26,
                ),
              ),
              favorites.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/panda.json',
                              height: Api().isTab() ? 350 : 200,
                              width: Api().isTab() ? 400 : 250,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Add your favorites here',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: Api().isTab() ? 32 : 22,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => init(),
                              child: Text(
                                'Refresh',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Api().isTab() ? 20 : 14),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Api().isTab() ? 3 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: favorites.length + 1,
                        itemBuilder: (context, index) {
                          return index == favorites.length
                              ? appOpenTime <= 10
                                  ? const Text('Swipe down to refresh')
                                  : const SizedBox()
                              : Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Api().customNavigator(
                                            SelectedImage(
                                                imageUrl: favorites[index]),
                                            context);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: const Color(0xFFEE712B)),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Hero(
                                            tag: favorites[index],
                                            child: CachedNetworkImage(
                                              imageUrl: favorites[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        var snackBar = const SnackBar(
                                          content:
                                              Text('Removed from Favorites ;)'),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.black,
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();

                                        List<String>? list = sharedPreferences
                                            .getStringList('favorits');

                                        if (list != null &&
                                            list.contains(favorites[index])) {
                                          list.remove(favorites[index]);
                                        }
                                        sharedPreferences.setStringList(
                                            'favorits', list!);
                                        init();
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.yellow.shade700)),
                                        padding: EdgeInsets.all(
                                            Api().isTab() ? 8 : 6),
                                        child: Icon(
                                          CupertinoIcons.star_fill,
                                          size: Api().isTab() ? 28 : 18,
                                          color: Colors.yellow.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
