import 'package:ardrawing_pro/dialogs/customDialog.dart';
import 'package:ardrawing_pro/screens/creations.dart';
import 'package:ardrawing_pro/screens/favorites.dart';
import 'package:ardrawing_pro/screens/home.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ionicons/ionicons.dart';

import '../helpers/apis.dart';
import 'text_art.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      AppUpdateInfo updateInfo = info;
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            message: 'Press update to update the app',
            imagePath: 'assets/images/update.svg',
            title: 'Update Available',
            buttonTitle: 'Update',
            voidCallback: () {
              Navigator.pop(context);
              InAppUpdate.performImmediateUpdate().catchError((e) {
                var snackBar = const SnackBar(
                  content: Text('Error Occurred'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return AppUpdateResult.inAppUpdateFailed;
              });
            },
          ),
        );
      }
    }).catchError((e) {
      debugPrint('Error Occurred While Checking For Update $e');
    });
  }

  @override
  void initState() {
    checkForUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                Home(),
                TextArt(),
                Favorites(),
                Creations(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Api().isTab() ? 12 : 1),
          child: CustomNavigationBar(
            iconSize: Api().isTab() ? 36 : 22.0,
            selectedColor: Colors.black,
            strokeColor: Colors.black,
            unSelectedColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 2,
            isFloating: false,
            borderRadius: const Radius.circular(12),
            items: [
              CustomNavigationBarItem(
                selectedIcon: Center(
                  child: Icon(
                    Ionicons.planet,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                icon: Center(
                  child: Icon(
                    Ionicons.planet_outline,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: Api().isTab() ? 20 : 12),
                ),
              ),
              CustomNavigationBarItem(
                selectedIcon: Center(
                  child: Icon(
                    Ionicons.text,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                icon: Center(
                  child: Icon(
                    Ionicons.text_outline,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                title: Text(
                  "Text Art",
                  style: TextStyle(fontSize: Api().isTab() ? 20 : 12),
                ),
              ),
              CustomNavigationBarItem(
                selectedIcon: Center(
                  child: Icon(
                    Ionicons.star,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                icon: Center(
                  child: Icon(
                    Ionicons.star_outline,
                    size: Api().isTab() ? 36 : 24,
                  ),
                ),
                title: Text(
                  "Favroites",
                  style: TextStyle(fontSize: Api().isTab() ? 20 : 12),
                ),
              ),
              CustomNavigationBarItem(
                selectedIcon: Icon(
                  Ionicons.brush,
                  size: Api().isTab() ? 36 : 24,
                ),
                icon: Icon(
                  Ionicons.brush_outline,
                  size: Api().isTab() ? 36 : 24,
                ),
                title: Text(
                  "Creations",
                  style: TextStyle(fontSize: Api().isTab() ? 20 : 12),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ));
  }
}
