// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/apis.dart';
import '../screens/category_images.dart';
import '../screens/selected_image.dart';

class HomeImageCard extends StatefulWidget {
  final String imageUrl;
  final bool isLast;
  final int? remaining;
  final String category;
  const HomeImageCard(
      {super.key,
      required this.imageUrl,
      required this.isLast,
      this.remaining,
      required this.category});

  @override
  State<HomeImageCard> createState() => _HomeImageCardState();
}

class _HomeImageCardState extends State<HomeImageCard> {
  bool isFavSelected = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String>? favorits = sharedPreferences.getStringList('favorits');

    if (favorits != null) {
      if (favorits.contains(widget.imageUrl)) {
        setState(() {
          isFavSelected = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await FirebaseAnalytics.instance.logSelectContent(
          contentType: "category",
          itemId: widget.category,
        );
        if (widget.isLast) {
          Api().customNavigator(
              CategoryImages(category: widget.category), context);
        } else {
            Api().customNavigator(
                SelectedImage(imageUrl: widget.imageUrl), context);
          
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: const Color(0xFFEE712B)),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: widget.imageUrl,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: MediaQuery.of(context).size.width / 3.3,
                  height: MediaQuery.of(context).size.width / 3.3,
                  fit: BoxFit.cover,
                  maxWidthDiskCache: 350,
                  memCacheWidth: 350,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Shimmer.fromColors(
                      baseColor: const Color(0xFFECEBEB),
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: MediaQuery.of(context).size.width / 3.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (!widget.isLast)
              InkWell(
                onTap: () async {
                  var snackBar = SnackBar(
                    content: Text(isFavSelected
                        ? 'Removed to Favorites ;)'
                        : 'Added to Favorites <3'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() {
                    isFavSelected = !isFavSelected;
                  });

                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  if (isFavSelected) {
                    await FirebaseAnalytics.instance.logSelectContent(
                      contentType: "addedToFavorites",
                      itemId: widget.category,
                    );
                    String key = widget.imageUrl.toString();

                    List<String>? list =
                        sharedPreferences.getStringList('favorits');

                    if (list != null) {
                      list.add(key);
                    } else {
                      list = [];
                      list.add(key);
                    }

                    sharedPreferences.setStringList('favorits', list);
                  } else {
                    List<String>? list =
                        sharedPreferences.getStringList('favorits');

                    if (list != null &&
                        list.contains(widget.imageUrl.toString())) {
                      list.remove(widget.imageUrl.toString());
                    }
                    sharedPreferences.setStringList('favorits', list!);
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: isFavSelected
                            ? Colors.yellow.shade700
                            : Colors.white,
                      )),
                  padding: EdgeInsets.all(Api().isTab() ? 8 : 4),
                  child: isFavSelected
                      ? Icon(
                          CupertinoIcons.star_fill,
                          size: Api().isTab() ? 28 : 16,
                          color: Colors.yellow.shade700,
                        )
                      : Icon(
                          CupertinoIcons.star,
                          size: Api().isTab() ? 28 : 16,
                        ),
                ),
              ),
            if (widget.isLast)
              Container(
                width: MediaQuery.of(context).size.width / 3.3,
                height: MediaQuery.of(context).size.width / 3.3,
                decoration: BoxDecoration(
                  color: const Color(0xB0943904),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.remaining! > 0 ? '+${widget.remaining}' : '+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Api().isTab() ? 62 : 42,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'View More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Api().isTab() ? 32 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
              ),
          ],
        ),
      ),
    );
  }
}
