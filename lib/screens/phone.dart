import 'dart:typed_data';
import 'package:ardrawing_pro/helpers/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class Phone extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? uint8List;
  final String? text;
  const Phone({super.key, this.imageUrl, this.text, this.uint8List});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1.0;

  double _angle = 0;
  double _initialAngle = 0;

  bool isLocked = false;
  String selectedFont = 'a';

  double brightness = 0;

  late DateTime started;
  DateTime? ended;

  Future<double> get currentBrightness async {
    try {
      return await ScreenBrightness().current;
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text('Error Occurred'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw 'Failed to get current brightness';
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text('Error Occurred'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text('Error Occurred'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw 'Failed to reset brightness';
    }
  }

  @override
  void initState() {
    Wakelock.enable();
    started = DateTime.now();
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('selectedFont') != null) {
      selectedFont = sharedPreferences.getString('selectedFont')!;
    }
    brightness = await currentBrightness;
    setState(() {});

    await FirebaseAnalytics.instance.logScreenView(screenName: 'Phone');
  }

  @override
  void dispose() {
    Wakelock.disable();
    ended = DateTime.now();
    if (ended != null) {
      var lapse = Duration(
          microseconds:
              ended!.microsecondsSinceEpoch - started.microsecondsSinceEpoch);
      saveTime(lapse.inMinutes);
    }
    resetBrightness();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.back,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  onScaleStart: (details) {
                    _initialFocalPoint = details.focalPoint;
                    _initialScale = _scale;
                    _initialAngle = _angle;
                  },
                  onScaleUpdate: (details) {
                    if (!isLocked) {
                      setState(() {
                        _angle = _initialAngle + details.rotation;
                        _sessionOffset =
                            details.focalPoint - _initialFocalPoint;
                        _scale = _initialScale * details.scale;
                      });
                    }
                  },
                  onScaleEnd: (details) {
                    setState(() {
                      _offset += _sessionOffset;
                      _sessionOffset = Offset.zero;
                    });
                  },
                  child: Transform.translate(
                    offset: _offset + _sessionOffset,
                    child: Transform.scale(
                        scale: _scale,
                        child: Transform.rotate(
                          angle: _angle,
                          child: widget.text != null
                              ? Container(
                                  margin: const EdgeInsets.all(50),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2)),
                                  child: Text(
                                    widget.text!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 38, fontFamily: selectedFont),
                                  ))
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Image(
                                    image: widget.imageUrl != null
                                        ? CachedNetworkImageProvider(
                                            widget.imageUrl!)
                                        : MemoryImage(widget.uint8List!)
                                            as ImageProvider,
                                  ),
                                ),
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    label: Text(
                      !isLocked ? 'Unlocked' : 'Locked',
                      style: TextStyle(
                        color: Color(0xFFEE712B),
                        fontSize: Api().isTab() ? 22 : 14,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isLocked) {
                          isLocked = false;
                        } else {
                          isLocked = true;
                        }
                      });
                    },
                    icon: Icon(
                      !isLocked
                          ? CupertinoIcons.lock_open
                          : CupertinoIcons.lock,
                      size: Api().isTab() ? 34 : 22,
                      color: const Color(0xFFEE712B),
                    ),
                  ),
                  SizedBox(
                    height: Api().isTab() ? 90 : 70,
                    child: Column(
                      children: [
                        Text(
                          'Brightness',
                          style: TextStyle(
                            fontSize: Api().isTab() ? 22 : 14,
                          ),
                        ),
                        Slider(
                          activeColor: Colors.orange,
                          value: brightness,
                          max: 1,
                          onChanged: (value) {
                            if (!isLocked) {
                              brightness = value;
                              setBrightness(brightness);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
