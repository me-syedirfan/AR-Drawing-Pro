// ignore_for_file: use_build_context_synchronously
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import '../helpers/apis.dart';
import 'home_image_card.dart';

class HomeCategoryList extends StatefulWidget {
  final String category;
  const HomeCategoryList({super.key, required this.category});

  @override
  State<HomeCategoryList> createState() => _HomeCategoryListState();
}

class _HomeCategoryListState extends State<HomeCategoryList> {
  List<String> list = [];

  Future<void> loadFromDatabase(String type) async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    int count =
        remoteConfig.getInt('${widget.category.toLowerCase()}$type') + 1;

    for (int i = 0; i < count; i++) {
      String url =
          'https://ardrawing.b-cdn.net/Drawings/${widget.category}/$type/$i.webp';
      list.add(url);
      list.shuffle();
    }
  }

  Future<void> makeList() async {
    if (Api().getCategoryTypes(widget.category) == 'lined') {
      loadFromDatabase('lined');
    } else if (Api().getCategoryTypes(widget.category) == 'coloured') {
      loadFromDatabase('coloured');
    } else {
      loadFromDatabase('lined');
      loadFromDatabase('coloured');
    }
    setState(() {});
  }

  @override
  void initState() {
    makeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.category,
            style: TextStyle(
              fontSize: Api().isTab() ? 32 : 20,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.width / 3.3,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return list.isEmpty
                    ? const SizedBox()
                    : HomeImageCard(
                        imageUrl: list[index],
                        isLast: index == 4 ? true : false,
                        remaining: list.length - 5,
                        category: widget.category,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
