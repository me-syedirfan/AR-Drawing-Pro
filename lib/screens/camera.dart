// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:ardrawing_pro/dialogs/share_art.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class Camera extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? uint8list;
  final String? text;
  const Camera({
    super.key,
    this.imageUrl,
    this.text,
    this.uint8list,
  });

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1.0;

  double _angle = 0;
  double _initialAngle = 0;

  double zoom = 0.0;
  double opacity = 0.5;
  String selectedFont = 'a';

  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  late List<CameraDescription> _cameras;

  late CameraController controller;

  bool isRecording = false;
  bool isUnlocked = false;
  bool isFlashOn = false;
  bool isZoomSliderShown = false;
  bool isOpacitySliderShown = false;
  bool isInitialised = false;

  late DateTime started;
  DateTime? ended;

  Future<void> getCameras() async {
    await [
      // Permission.storage,
      Permission.camera,
    ].request();
    _cameras = await availableCameras();
    controller = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('selectedFont') != null) {
      selectedFont = sharedPreferences.getString('selectedFont')!;
      setState(() {});
    }
  }

  Future<void> checkPermissions([String? permission]) async {
    var cstatus = await Permission.camera.status;

    if (cstatus != PermissionStatus.granted) {
      if (Platform.isIOS && _cameras.isNotEmpty) {
        isInitialised = true;
        setState(() {});
      } else {
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
      isInitialised = true;
      setState(() {});
    }

    if (permission != null && permission == 'Storage') {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
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
                        'This App requries Storage access to work. Please grant app permissions.',
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
    }
  }

  Future<void> init() async {
    await FirebaseAnalytics.instance.logScreenView(screenName: 'Camera');
  }

  @override
  void initState() {
    Wakelock.enable();
    started = DateTime.now();
    super.initState();
    getCameras().then((value) {
      checkPermissions();
      init();
    });
  }

  Future<void> askReview() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('asked') == null) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
      sharedPreferences.setBool('asked', true);
    }
  }

  @override
  void dispose() {
    askReview();
    ended = DateTime.now();
    if (ended != null) {
      var lapse = Duration(
          microseconds:
              ended!.microsecondsSinceEpoch - started.microsecondsSinceEpoch);
      saveTime(lapse.inMinutes);
    }
    controller.dispose();
    Wakelock.disable();
    super.dispose();
  }

  Future<void> saveTime(int mins) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? prevTime = sharedPreferences.getInt('timeSpent');
    if (prevTime != null) {
      prevTime = prevTime + mins;
    } else {
      prevTime = mins;
    }
    sharedPreferences.setInt('timeSpent', prevTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isInitialised
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            )
          : Stack(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTapUp: (details) {
                        _onTap(details);
                      },
                      onTap: () {
                        if (isZoomSliderShown || isOpacitySliderShown) {
                          setState(() {
                            isZoomSliderShown = false;
                            isOpacitySliderShown = false;
                          });
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: 100,
                              child: CameraPreview(controller),
                            ),
                          )),
                    ),
                    if (showFocusCircle)
                      Positioned(
                          top: y - 25,
                          left: x - 25,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GestureDetector(
                        onTapUp: (details) {
                          _onTap(details);
                        },
                        onTap: () {
                          if (isZoomSliderShown || isOpacitySliderShown) {
                            setState(() {
                              isZoomSliderShown = false;
                              isOpacitySliderShown = false;
                            });
                          }
                        },
                        onScaleStart: (details) {
                          _initialFocalPoint = details.focalPoint;
                          _initialScale = _scale;
                          _initialAngle = _angle;
                        },
                        onScaleUpdate: (details) {
                          if (!isUnlocked) {
                            setState(() {
                              _angle = _initialAngle + details.rotation;
                              _sessionOffset =
                                  details.focalPoint - _initialFocalPoint;
                              _scale = _initialScale * details.scale;
                            });
                          }
                        },
                        onScaleEnd: (details) {
                          _offset += _sessionOffset;
                          _sessionOffset = Offset.zero;
                        },
                        child: Transform.translate(
                          offset: _offset + _sessionOffset,
                          child: Transform.scale(
                              scale: _scale,
                              child: Transform.rotate(
                                angle: _angle,
                                child: widget.text != null
                                    ? Align(
                                        child: Container(
                                            margin: const EdgeInsets.all(50),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 2)),
                                            child: Opacity(
                                              opacity: opacity,
                                              child: Text(
                                                widget.text!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 38,
                                                    color: Colors.black,
                                                    fontFamily: selectedFont),
                                              ),
                                            )),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        child: Image(
                                          image: widget.imageUrl != null
                                              ? CachedNetworkImageProvider(
                                                  widget.imageUrl!)
                                              : MemoryImage(widget.uint8list!)
                                                  as ImageProvider,
                                          opacity:
                                              AlwaysStoppedAnimation(opacity),
                                        ),
                                      ),
                              )),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            margin: const EdgeInsets.only(
                                right: 22, left: 22, bottom: 22, top: 6),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: isOpacitySliderShown
                                ? SizedBox(
                                    height: 70,
                                    child: Column(
                                      children: [
                                        const Text('Opacity'),
                                        Slider(
                                          activeColor: Colors.orange,
                                          value: opacity,
                                          max: 1,
                                          onChanged: (value) {
                                            setState(() {
                                              opacity = value;
                                            });

                                            Future.delayed(
                                                const Duration(seconds: 10),
                                                () {
                                              if (isOpacitySliderShown) {
                                                setState(() {
                                                  isOpacitySliderShown = false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : isZoomSliderShown
                                    ? SizedBox(
                                        height: 70,
                                        child: Column(
                                          children: [
                                            const Text('Zoom'),
                                            Slider(
                                              activeColor: Colors.orange,
                                              value: zoom,
                                              onChanged: (value) {
                                                value = value * 10;
                                                if (value <= 8.0 &&
                                                    value >= 1.0) {
                                                  controller
                                                      .setZoomLevel(value);
                                                }
                                                setState(
                                                    () => zoom = value / 10);

                                                Future.delayed(
                                                    const Duration(seconds: 10),
                                                    () {
                                                  if (isZoomSliderShown) {
                                                    setState(() {
                                                      isZoomSliderShown = false;
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              try {
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                if (!isRecording) {
                                                  if (!controller
                                                      .value.isInitialized) {
                                                    return;
                                                  }
                                                  final player = AudioPlayer();
                                                  await player.play(AssetSource(
                                                      'audios/video-start.m4a'));
                                                  controller
                                                      .startVideoRecording();
                                                  isRecording = true;
                                                } else {
                                                  if (!controller
                                                      .value.isInitialized) {
                                                    return;
                                                  }
                                                  if (!controller
                                                      .value.isRecordingVideo) {
                                                    return;
                                                  }
                                                  final player = AudioPlayer();
                                                  await player.play(AssetSource(
                                                      'audios/video-end.m4a'));
                                                  XFile videoFile =
                                                      await controller
                                                          .stopVideoRecording();

                                                  final Directory tempDir =
                                                      await getTemporaryDirectory();
                                                  final String tempPath =
                                                      videoFile.path;
                                                  final String newFileName =
                                                      '${tempDir.path}${DateTime.now().millisecondsSinceEpoch}.mp4';
                                                  final File tempFile =
                                                      File(tempPath);
                                                  final File newFile = tempFile
                                                      .renameSync(newFileName);
                                                  GallerySaver.saveVideo(
                                                          newFile.path)
                                                      .then((value) async {
                                                    const snackBar = SnackBar(
                                                      content: Text('Saved'),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);

                                                    List<String>? videos =
                                                        prefs.getStringList(
                                                            'videos');
                                                    if (videos == null ||
                                                        videos.isEmpty) {
                                                      await prefs.setStringList(
                                                          'videos',
                                                          [newFile.path]);
                                                    } else {
                                                      videos
                                                          .add(newFile.path);
                                                      await prefs.setStringList(
                                                          'videos', videos);
                                                    }
                                                  });
                                                  isRecording = false;
                                                }
                                                setState(() {});
                                              } catch (error, stackTrace) {
                                                await FirebaseCrashlytics
                                                    .instance
                                                    .recordError(
                                                  error,
                                                  stackTrace,
                                                  reason:
                                                      'error while recording video',
                                                  fatal: true,
                                                );
                                                var snackBar = const SnackBar(
                                                  content:
                                                      Text('Error Occurred!'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.black,
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            },
                                            icon: Icon(
                                              !isRecording
                                                  ? CupertinoIcons
                                                      .largecircle_fill_circle
                                                  : CupertinoIcons.stop_circle,
                                              size: 28,
                                              color: isRecording
                                                  ? Colors.red
                                                  : Colors.grey[800],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              try {
                                                if (!controller
                                                    .value.isInitialized) {
                                                  return;
                                                }
                                                if (controller
                                                    .value.isTakingPicture) {
                                                  return;
                                                }

                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                final player = AudioPlayer();
                                                await player.play(AssetSource(
                                                    'audios/camera.m4a'));

                                                try {
                                                  XFile file = await controller
                                                      .takePicture();

                                                  GallerySaver.saveImage(
                                                          file.path)
                                                      .then((value) async {
                                                    const snackBar = SnackBar(
                                                      content: Text('Saved'),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);

                                                    if (prefs.getBool(
                                                                'shareDrawing') ==
                                                            null ||
                                                        prefs.get(
                                                                'shareDrawing') ==
                                                            false) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ShareArt(
                                                                prefs: prefs,
                                                                file: file);
                                                          });
                                                    }

                                                    List<String>? videos =
                                                        prefs.getStringList(
                                                            'photos');
                                                    if (videos == null ||
                                                        videos.isEmpty) {
                                                      await prefs.setStringList(
                                                          'photos',
                                                          [file.path]);
                                                    } else {
                                                      videos.add(file.path);
                                                      await prefs.setStringList(
                                                          'photos', videos);
                                                    }
                                                  });
                                                } on CameraException catch (e) {
                                                  debugPrint(e.description);
                                                }
                                              } catch (error, stackTrace) {
                                                await FirebaseCrashlytics
                                                    .instance
                                                    .recordError(
                                                        error, stackTrace,
                                                        reason:
                                                            'error while taking photo',
                                                        fatal: true);
                                                var snackBar = const SnackBar(
                                                  content:
                                                      Text('Error Occurred!'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.black,
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.camera,
                                                size: 28),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (isUnlocked) {
                                                isUnlocked = false;
                                              } else {
                                                isUnlocked = true;
                                              }
                                              setState(() {});
                                            },
                                            icon: Icon(
                                                isUnlocked
                                                    ? CupertinoIcons.lock_fill
                                                    : CupertinoIcons.lock_open,
                                                color: isUnlocked
                                                    ? Colors.deepOrange
                                                    : Colors.grey[800],
                                                size: 28),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isZoomSliderShown = true;
                                              });
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.zoom_in,
                                                size: 28),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isOpacitySliderShown = true;
                                              });
                                            },
                                            icon: const Icon(
                                                CupertinoIcons
                                                    .circle_lefthalf_fill,
                                                size: 28),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (isFlashOn) {
                                                controller.setFlashMode(
                                                    FlashMode.off);
                                                isFlashOn = false;
                                              } else {
                                                isFlashOn = true;
                                                controller.setFlashMode(
                                                    FlashMode.torch);
                                              }
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              isFlashOn
                                                  ? CupertinoIcons.bolt_fill
                                                  : CupertinoIcons.bolt,
                                              color: isFlashOn
                                                  ? Colors.yellow
                                                  : Colors.grey[800],
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.black,
                              size: 26,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Finished?',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Are you sure you finished?',
                                        style: TextStyle(
                                          fontSize: 17,
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
                                            },
                                            child: const Text(
                                              "No",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();

                                              int? totalDrawings =
                                                  sharedPreferences
                                                      .getInt('totalDrawings');
                                              if (totalDrawings != null) {
                                                totalDrawings =
                                                    totalDrawings + 1;
                                              } else {
                                                totalDrawings = 1;
                                              }
                                              sharedPreferences.setInt(
                                                  'totalDrawings',
                                                  totalDrawings);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text(
                            'Finish',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);

      await controller.setFocusPoint(point);

      controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}
