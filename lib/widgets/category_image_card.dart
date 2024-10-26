import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/apis.dart';
import '../screens/selected_image.dart';

class CategoryImageCard extends StatefulWidget {
  final String imageUrl;
  final String category;
  const CategoryImageCard(
      {super.key, required this.imageUrl, required this.category});

  @override
  State<CategoryImageCard> createState() => _CategoryImageCardState();
}

class _CategoryImageCardState extends State<CategoryImageCard> {
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
      onTap: () {
        Api()
            .customNavigator(SelectedImage(imageUrl: widget.imageUrl), context);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEE712B), width: 1),
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                  tag: widget.imageUrl,
                  transitionOnUserGestures: true,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.cover,
                    maxWidthDiskCache: 350,
                    memCacheWidth: 350,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFECEBEB),
                        highlightColor: Colors.grey.shade300,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),
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
                String key = widget.imageUrl;

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

                if (list != null && list.contains(widget.imageUrl)) {
                  list.remove(widget.imageUrl);
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
                  color: isFavSelected ? Colors.yellow.shade700 : Colors.white,
                ),
              ),
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
        ],
      ),
    );
  }
}
