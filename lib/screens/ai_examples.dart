import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/apis.dart';
import '../widgets/button.dart';
import 'selected_image.dart';

class AIExamples extends StatelessWidget {
  final item;
  const AIExamples({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Example',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image(
                      image: AssetImage(item['path']),
                      fit: BoxFit.cover,
                      width: Api().isTab()
                          ? 500
                          : MediaQuery.of(context).size.width,
                      height: Api().isTab()
                          ? 500
                          : MediaQuery.of(context).size.width - 32,
                    ),
                  ),
                ),
                SizedBox(height: Api().isTab() ? 22 : 12),
                Container(
                  width:
                      Api().isTab() ? 600 : MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.orangeAccent)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    item['prompt'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Api().isTab() ? 22 : 16,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: item['prompt']));
                    var snackBar = const SnackBar(
                      content: Text('Prompt copied to Clipboard <3'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.black,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: Api().isTab()
                        ? MediaQuery.of(context).size.width / 1.5
                        : MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFDC4712),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Copy Prompt',
                        style: TextStyle(
                          color: const Color(0xFFDC4712),
                          fontSize: Api().isTab() ? 24 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: AppButton(
                      title: 'Use this image',
                      voidCallback: () async {
                        Navigator.pop(context);
                        final ByteData bytes =
                            await rootBundle.load(item['path']);
                        final Uint8List list = bytes.buffer.asUint8List();
                        Api().customNavigator(
                            SelectedImage(uint8List: list), context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
