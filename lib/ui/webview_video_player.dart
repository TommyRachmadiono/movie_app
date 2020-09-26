import 'package:flutter/material.dart';
import 'package:webview_plugin/webview_plugin.dart';

class VideoPlayer extends StatelessWidget {
  final String url;
  VideoPlayer({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlutterWebView(
          onWebCreated: (controller) {
            controller.loadUrl(url);
          },
        ),
      ),
    );
  }
}
