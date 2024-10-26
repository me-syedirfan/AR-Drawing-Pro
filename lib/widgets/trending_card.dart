import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/apis.dart';
import '../screens/selected_image.dart';

class TrendingCard extends StatelessWidget {
  final String imageUrl;
  const TrendingCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 2, bottom: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            await FirebaseAnalytics.instance.logSelectContent(
              contentType: "category",
              itemId: 'Trending',
            );
            Api().customNavigator(SelectedImage(imageUrl: imageUrl), context);
          },
          child: Material(
            elevation: 12,
            child: Container(
              width: Api().isTab()
                  ? MediaQuery.of(context).size.width / 3
                  : MediaQuery.of(context).size.width - 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: const Color(0xFFEE712B)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover, 
                    maxWidthDiskCache: Api().isTab()
                        ? (MediaQuery.of(context).size.width / 3).round()
                        : (MediaQuery.of(context).size.width - 220).round(),
                    progressIndicatorBuilder: (context, url, progress) {
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFECEBEB),
                        highlightColor: Colors.grey.shade300,
                        child: Container(
                          width: Api().isTab()
                              ? MediaQuery.of(context).size.width / 3
                              : MediaQuery.of(context).size.width - 220,
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
            ),
          ),
        ),
      ),
    );
  }
}
