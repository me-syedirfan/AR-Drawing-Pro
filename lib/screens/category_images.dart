
import 'package:ardrawing_pro/widgets/category_image_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../helpers/apis.dart';

class CategoryImages extends StatefulWidget {
  final String category;
  const CategoryImages({
    super.key,
    required this.category,
  });

  @override
  State<CategoryImages> createState() => _CategoryImagesState();
}

class _CategoryImagesState extends State<CategoryImages> {
  List<String> colouredList = [];
  List<String> linedList = [];
  bool isColorSelected = true;

  ScrollController controller = ScrollController();

  Future<void> loadFromDatabase(String type) async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    int count =
        remoteConfig.getInt('${widget.category.toLowerCase()}$type') + 1;

    for (int i = 0; i < count; i++) {
      String url =
          'https://ardrawing.b-cdn.net/Drawings/${widget.category}/$type/$i.webp';
      if (type == 'coloured') {
        colouredList.add(url);
        colouredList.shuffle();
      } else {
        linedList.add(url);
        linedList.shuffle();
      }
    }
  }

  void makeList() async {
      if (Api().getCategoryTypes(widget.category) == 'lined') {
        loadFromDatabase('lined');
      } else {
        loadFromDatabase('coloured');
      }
      setState(() {});

    await FirebaseAnalytics.instance
        .logScreenView(screenName: 'Category Images');
  }

  @override
  void initState() {
    super.initState();
    makeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'dazzle',
                fontWeight: FontWeight.bold,
                fontSize: Api().isTab() ? 32 : 26,
              ),
            ),
            if (Api().getCategoryTypes(widget.category) == 'both')
              const SizedBox(height: 12),
            if (Api().getCategoryTypes(widget.category) == 'both')
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      if (colouredList.isEmpty) {
                        loadFromDatabase('coloured');
                      }
                      isColorSelected = true;
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isColorSelected
                            ? const Color(0xFFEE712B)
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Api().isTab() ? 16 : 8,
                        vertical: Api().isTab() ? 8 : 6,
                      ),
                      child: Text(
                        '🎨 Colour Arts',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Api().isTab() ? 28 : 20,
                          color: isColorSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (linedList.isEmpty) {
                          loadFromDatabase('lined');
                        }
                        isColorSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isColorSelected
                            ? const Color(0xFFEE712B)
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Api().isTab() ? 16 : 8,
                        vertical: Api().isTab() ? 8 : 6,
                      ),
                      child: Text(
                        '✏️ Line Arts',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Api().isTab() ? 28 : 20,
                          color: !isColorSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: isColorSelected ? 0 : 1,
                children: [
                  if (Api().getCategoryTypes(widget.category) != 'lined')
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Api().isTab() ? 4 : 3,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: colouredList.length,
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CategoryImageCard(
                          imageUrl: colouredList[index],
                          category: widget.category,
                        );
                      },
                    ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Api().isTab() ? 4 : 3,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: linedList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CategoryImageCard(
                        imageUrl: linedList[index],
                        category: widget.category,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
