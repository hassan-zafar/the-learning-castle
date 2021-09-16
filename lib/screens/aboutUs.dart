import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: backgroundColorBoxDecoration(),
      child: WebView(
        initialUrl: "https://www.tlcme.org",
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (progress) => LoadingIndicator(),
      ),
    ));
  }
}
