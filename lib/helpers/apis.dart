// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ardrawing_pro/dialogs/no_internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class Api {
  bool shouldLoad(SharedPreferences sharedPreferences, String key) {
    int? lastTrendingLoadedDate =
        sharedPreferences.getInt('last${key}LoadedDate');
    if (lastTrendingLoadedDate == null) {
      return true;
    }
    DateTime dt1 = DateTime.fromMillisecondsSinceEpoch(lastTrendingLoadedDate);
    DateTime dt2 = DateTime.now();
    if (dt2.difference(dt1).inMinutes > 1) {
      return true;
    } else {
      return false;
    }
  }

  String getCategoryTypes(String category) {
    if (category == 'Anime' ||
        category == 'Animals' ||
        category == 'Nature' ||
        category == 'Architecture' ||
        category == 'Vehicles' ||
        category == 'Sketches') {
      return 'both';
    } else if (category == 'Doodles') {
      return 'lined';
    }
    return 'coloured';
  }

  String generateRandomString() {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(15, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<void> saveImageInMemory(Uint8List uint8list, String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, base64.encode(uint8list));
  }

  Route getRoute(Widget widget) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(builder: (context) => widget);
    } else {
      return CupertinoPageRoute(builder: (context) => widget);
    }
  }

  Future<void> customNavigator(Widget widget, BuildContext context) async {
    Navigator.push(context, getRoute(widget));
  }

  Future<bool> checkInternetStatus(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      showDialog(
          context: context,
          builder: (context) {
            return const NoInternet(
              message: 'Please check you internet connection and try again.',
            );
          });
      return false;
    }
    return true;
  }

  int getUint8ListKey(Uint8List uint8List) {
    int i1 = uint8List[1] + uint8List.length;
    int i2 = uint8List[2] + uint8List.length;
    int i3 = uint8List[3] + uint8List.length;
    int i4 = uint8List[4] + uint8List.length;
    int i5 = uint8List[5] + uint8List.length;
    int i6 = uint8List.last - 4 + uint8List.length;
    int i7 = uint8List.last - 3 + uint8List.length;
    int i8 = uint8List.last - 2 + uint8List.length;
    int i9 = uint8List.last - 1 + uint8List.length;
    int i10 = uint8List.last + uint8List.length;
    return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
  }

  Future<Uint8List> convertToLineArt(
      [Uint8List? image, String? imageUrl]) async {
    List<int> bytes = [];
    if (image != null) {
      bytes = image.buffer.asUint8List();
    } else {
      http.Response response = await http.get(Uri.parse(imageUrl!));

      bytes = response.bodyBytes;
    }

    img.Image originalImage = img.decodeImage(Uint8List.fromList(bytes))!;

    img.Image grayscaleImage = img.grayscale(originalImage);

    img.Image edgeDetectedImage = img.sobel(grayscaleImage);

    img.Image invertedImage = img.invert(edgeDetectedImage);

    Uint8List sketchBytes = Uint8List.fromList(img.encodeJpg(invertedImage));

    return sketchBytes;
  }

  final List<String> categories = [
    'Anime',
    'Animals',
    'Cute',
    if (Platform.isAndroid) 'Cartoon',
    'Sketches',
    'Architecture',
    'Food',
    'Fruits',
    'Doodles',
    'Nature',
    'Vegetables',
    'Vehicles',
  ];

  final List<String> categoriesForHome = [
    'Anime',
    'Animals',
    'Cute',
    if (Platform.isAndroid) 'Cartoon',
    'Sketches',
    'Nature',
    'Vehicles',
  ];

  final List<String> badWords = [
    'rape',
    'raped',
    'boobs',
    'gang bang',
    'big chest',
    'big boobs',
    'sex',
    'vagina',
    'cock',
    'pussy',
    'naked',
    'without clothes',
    'cloths',
    'removing cloths',
    'removing clothes',
    'nude',
    'unclothed',
    'undressed',
    'uncovered',
    'fuck',
    'giving birth',
    'birth',
    'bikini',
    'bikini',
    'no bikini',
    'whore',
    'hoe',
    'no clothes',
    'no underwere',
    'prostitute',
    'not wearing under garments',
    'short clothes',
    'mini clothes',
    'porn',
    'porned',
    'transparent',
    'girl with big',
    'women with big',
    'showing bum',
    'bum',
    'birth',
    'cum',
    'onepiece',
    'linger',
    'sexy',
    'xnxx',
    'porner',
    'breasts',
    'breast',
    'nipple',
    'nipples',
    'penis',
    'penetrating someone',
    'testicles',
    'testicle',
    '69',
  ];

  List<String> fontsFamilies = [
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
  ];

  List<String> animationsNames = [
    'fruits',
    'gem',
    'orb',
    'rocket',
    'rocketYellow',
    'stars',
    'toaster',
  ];

  List<String> randomPrompts = [
    'portrait of stoic looking john oliver as vigo carpathian, military uniform, fantasy, intricate, elegant, highly detailed, centered, dark, smokey, charcoal painting, digital painting, artstation, concept art, smooth, sharp focus, illustration, art by artgerm and greg rutkowski and alphonse mucha',
    'selma hayek as she hulk profile picture by Greg Rutkowski, matte painting, intricate, fantasy concept art, elegant, by Stanley Artgerm Lau, golden ratio, thomas kindkade, alphonse mucha, loish, norman Rockwell,',
    'digital artwork, illustration, cinematic camera, bright lights, vivid colors, elegant biomechanical machinery, intricate machinery, biomimicry, bioluminescence, the ghosts in the machine, cyberpunk concept art by artgerm and Alphonse Mucha and Greg Rutkowski, highly detailed, elegant, intricate, sci-fi, sharp focus, dramatic lighting, Trending on Artstation HQ, deviantart',
    'a wlop 3d render of very very very very highly detailed beautiful mystic portrait of a phantom undead mage ape with whirling galaxy around, tattoos by anton pieck, intricate, extremely detailed, digital painting, artstation, concept art, smooth, sharp focus, illustration, intimidating lighting, incredible art,',
    'pixar portrait 8k photo, beautiful shiny white porcelain rich galactic hottie clowncore vixen russian cyborg college girl, golden ratio details, sci-fi, fantasy, cyberpunk, intricate, decadent, highly detailed, digital painting, octane render, artstation, concept art, smooth, sharp focus, illustration, art by artgerm, loish, wlop',
    'wizard, female, in crystal cave, D&D, fantasy, intricate, elegant, highly detailed, digital painting, artstation, octane render, concept art, matte, sharp focus, illustration, hearthstone, art by Artgerm and Greg Rutkowski and Alphonse Mucha',
    'Close up of a singular necron warrior, green glowing eyes reflecting on the shinny armor. At night, underexposed, desolated wasteland, matte painting by craig mullins and dan mumford, cinematic, warhammer 40k, dark sci-fi,concept art trending on artstation, 4k, insane details',
    'anna from frozen in game of thrones, highly detailed digital painting, artstation, concept art, smooth, sharp focus, illustration, art by artgerm and greg rutkowski and alphonse mucha',
    // 'digital art, birth of mami wata, sumerian goddess inanna ishtar, ashteroth, techno mystic goddess princess intergalactica, with aqua neon rapunzel dreadlocks, mami wata, detailed, by gaston bussiere, bayard wu, greg rutkowski, giger, maxim verehin, greg rutkowski, masterpiece, sharp focus-9',
    'A whimsical scene of a fluffy orange cat lounging in a sun-drenched window, surrounded by colorful potted plants. The style is reminiscent of Henri Matisse, with bold colors and dynamic shapes. Soft shadows create a warm, inviting atmosphere, while a few curious butterflies flutter outside the glass, adding a touch of playfulness. The overall composition is vibrant, capturing the serene essence of a lazy afternoon.',
    'A whimsical scene featuring a playful golden retriever wearing a oversized wizard hat, surrounded by floating colorful balloons and twinkling stars. The background is a dreamy pastel sunset with cotton candy clouds, reminiscent of a Van Gogh painting. Include hints of magical sparkles in the air to evoke a sense of enchantment.',
    'symmetry!! ultra realistic portrait of primates! cover art! moon and galaxy in background!, intricate, elegant, highly detailed, digital painting, artstation, concept art, smooth, sharp focus, illustration, art by artgerm and ross tran and greg rutkowski and alphonse mucha, 8k',
    'A dapper handsome man in elegant tailored clothing stands confidently on a bustling city street at dusk. The warm golden glow of streetlights casts a soft light on his features, highlighting his chiseled jawline and charming smile. He has stylish short hair, and a hint of stubble adds to his rugged appeal. The background features blurred silhouettes of individuals, creating an urban atmosphere, while the faint outlines of historic buildings add a touch of sophistication. The scene is depicted in a mix of realistic portraiture and impressionistic brush strokes to emphasize the vibrant energy of the city.',
    'A vintage red convertible cruising down a winding coastal road at sunset, with palm trees swaying in the breeze, watercolor style mixed with vibrant digital art, reminiscent of a classic 1950s Americana poster, subtle reflections on the cars glossy surface, soft clouds illuminated by warm golden hues.',
    'A whimsical princess standing in a vibrant enchanted forest, adorned in a flowing gown embroidered with flowers and shimmering jewels. She holds a magical staff that glows softly, surrounded by playful woodland creatures. The scene is illuminated by golden sunlight filtering through the leaves, with delicate butterflies fluttering around her. The style is reminiscent of classic fairy tale illustrations, blending realism with a touch of watercolor whimsy, akin to the works of Arthur Rackham and Beatrix Potter.',
    'A black man standing confidently in an urban setting, adorned in a vibrant, patterned traditional African attire, merging elements of modern streetwear with cultural heritage. The background features a lively cityscape with graffiti art and abstract murals, evoking a blend of contemporary urban art and traditional textures. The scene is illuminated by warm, golden hour sunlight, casting long shadows and highlighting the man\'s expression of hope and determination. The artwork is influenced by the styles of Kehinde Wiley and Jean-Michel Basquiat, with a surreal twist that adds depth and emotion to the composition.',
  ];

  List<String> examples = [
    'assets/images/Examples/0.webp',
    'assets/images/Examples/1.webp',
    'assets/images/Examples/2.webp',
    'assets/images/Examples/3.webp',
    'assets/images/Examples/4.webp',
    'assets/images/Examples/5.webp',
    'assets/images/Examples/6.webp',
    'assets/images/Examples/7.webp',
    'assets/images/Examples/8.webp',
    'assets/images/Examples/9.webp',
    'assets/images/Examples/10.webp',
    'assets/images/Examples/11.webp',
    'assets/images/Examples/12.webp',
    'assets/images/Examples/13.webp',
    'assets/images/Examples/14.webp',
    'assets/images/Examples/15.webp',
    'assets/images/Examples/16.webp',
    'assets/images/Examples/17.webp',
    'assets/images/Examples/18.webp',
    'assets/images/Examples/19.webp',
    'assets/images/Examples/20.webp',
  ];

  bool containsBadWords(String text) {
    if (badWords.any((item) => text.toLowerCase().contains(item))) {
      return true;
    }
    return false;
  }

  bool isTab() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? false : true;
  }

  bool isSmallPhone() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide > 380 ? false : true;
  }

  Future<int> getAppOpenTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int i = sharedPreferences.getInt('appOpenTime')!;
    return i;
  }
}
