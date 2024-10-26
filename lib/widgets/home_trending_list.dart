import 'package:flutter/material.dart';
import '../helpers/apis.dart';
import 'trending_card.dart';

class HomeTrendingList extends StatefulWidget {
  const HomeTrendingList({super.key});

  @override
  State<HomeTrendingList> createState() => _HomeTrendingListState();
}

class _HomeTrendingListState extends State<HomeTrendingList> {
  List<String> trendingImages = [];
  ScrollController controller = ScrollController();

  Future<void> loadTrending() async {
    for (int i = 0; i < 4; i++) {
      String url = 'https://ardrawing.b-cdn.net/Trending/$i.webp';
      trendingImages.add(url);
    }
    trendingImages.shuffle();
  }

  @override
  void initState() {
    super.initState();
    loadTrending();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 300) {
      setState(() {
        trendingImages.addAll(List.generate(
            4,
            (index) =>
                'https://ardrawing.b-cdn.net/Trending/${4 + index}.webp'));
      });
      controller.removeListener(_scrollListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Api().isTab()
          ? MediaQuery.of(context).size.width / 3
          : MediaQuery.of(context).size.height / 4,
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: trendingImages.length,
        itemBuilder: (context, index) {
          return TrendingCard(imageUrl: trendingImages[index]);
        },
      ),
    );
  }
}
