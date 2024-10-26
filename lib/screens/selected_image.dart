// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:ardrawing_pro/dialogs/loading.dart';
import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:ardrawing_pro/screens/camera.dart';
import 'package:ardrawing_pro/screens/phone.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class SelectedImage extends StatefulWidget {
  final Uint8List? uint8List;
  final String? imageUrl;
  const SelectedImage({
    super.key,
    this.uint8List,
    this.imageUrl,
  });

  @override
  State<SelectedImage> createState() => _SelectedImageState();
}

class _SelectedImageState extends State<SelectedImage> {
  bool isFirstRun = false;
  bool isLineArtSelected = false;
  Uint8List? lineArt;

  Future<void> checkPermissions([String? permission]) async {
    var cstatus = await Permission.camera.status;

    if (cstatus != PermissionStatus.granted) {
      if (!Platform.isIOS) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Permissions!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'This App requries Camera access to work. Please grant app permissions.',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          await openAppSettings();
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 17, color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      }
    } else {
      // isInitialised = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selected Image',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1, color: const Color(0xFFEE712B)),
                      ),
                      child: Hero(
                        tag: widget.uint8List ?? widget.imageUrl!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isLineArtSelected
                              ? Image.memory(
                                  lineArt!,
                                  width: Api().isTab()
                                      ? 500
                                      : MediaQuery.of(context).size.width - 50,
                                )
                              : widget.uint8List != null
                                  ? Image.memory(
                                      widget.uint8List!,
                                      width: Api().isTab()
                                          ? 500
                                          : MediaQuery.of(context).size.width -
                                              50,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.imageUrl!,
                                      fit: BoxFit.cover,
                                      maxWidthDiskCache: Api().isTab()
                                          ? (MediaQuery.of(context).size.width /
                                                  3)
                                              .round()
                                          : (MediaQuery.of(context).size.width -
                                                  220)
                                              .round(),
                                      progressIndicatorBuilder:
                                          (context, url, progress) {
                                        return Shimmer.fromColors(
                                          baseColor: const Color(0xFFD1D1D1),
                                          highlightColor: Colors.grey.shade300,
                                          child: Container(
                                            width: Api().isTab()
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    220,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Convert to Line Art',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: isLineArtSelected,
                        activeColor: Colors.deepOrange,
                        onChanged: (value) async {
                          if (value && lineArt == null) {
                            showDialog(
                                context: context,
                                builder: (context) => const LoadingDialog());
                            Future.delayed(const Duration(milliseconds: 1000))
                                .then((v) async {
                              if (widget.uint8List != null) {
                                lineArt = await Api()
                                    .convertToLineArt(widget.uint8List!, null);
                              } else {
                                lineArt = await Api()
                                    .convertToLineArt(null, widget.imageUrl!);
                              }
                            });
                            Future.delayed(const Duration(seconds: 4))
                                .then((v) async {
                              isLineArtSelected = value;
                              Navigator.pop(context);
                              setState(() {});
                            });
                          } else {
                            isLineArtSelected = value;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await [
                          Permission.storage,
                          Permission.camera,
                        ].request();

                        checkPermissions();

                        await FirebaseAnalytics.instance.logSelectContent(
                          contentType: "drawingMethod",
                          itemId: 'Camera',
                        );
                        if (isFirstRun) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                late VideoPlayerController controller;
                                controller = VideoPlayerController.asset(
                                    'assets/videos/intro.mp4')
                                  ..initialize().then((_) {});
                                controller.play();
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'How to use',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: VideoPlayer(controller)),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);

                                                  Api().customNavigator(
                                                      isLineArtSelected
                                                          ? Camera(
                                                              uint8list:
                                                                  lineArt,
                                                            )
                                                          : widget.imageUrl ==
                                                                  null
                                                              ? Camera(
                                                                  uint8list: widget
                                                                      .uint8List,
                                                                )
                                                              : Camera(
                                                                  imageUrl: widget
                                                                      .imageUrl,
                                                                ),
                                                      context);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ))),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              barrierDismissible: false);
                        } else {
                          Api().customNavigator(
                            isLineArtSelected
                                ? Camera(
                                    uint8list: lineArt,
                                  )
                                : widget.imageUrl == null
                                    ? Camera(
                                        uint8list: widget.uint8List,
                                      )
                                    : Camera(
                                        imageUrl: widget.imageUrl,
                                      ),
                            context,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFDC4712),
                                Color(0xFFEE712B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 9,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.camera,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height / 16,
                            ),
                            const SizedBox(height: 12),
                            const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Trace with camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await FirebaseAnalytics.instance.logSelectContent(
                          contentType: "drawingMethod",
                          itemId: 'Trace',
                        );
                        Api().customNavigator(
                            isLineArtSelected
                                ? Phone(uint8List: lineArt)
                                : widget.imageUrl == null
                                    ? Phone(uint8List: widget.uint8List)
                                    : Phone(imageUrl: widget.imageUrl),
                            context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFDC4712),
                                Color(0xFFEE712B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.pen,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height / 16,
                            ),
                            const SizedBox(height: 12),
                            const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Trace on phone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
