import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int _progress = 0;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: backgroundColorBoxDecoration(),
      child: Stack(
        children: [
          WebView(
            initialUrl: "https://www.tlcme.org",
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (progress) {
              print("progress: $progress");
              setState(() {
                _progress = progress;
                _isLoading = !(_progress == 100);
              });
            },
          ),
          _isLoading ? LoadingIndicator() : Container(),
        ],
      ),
    ));
  }
}
