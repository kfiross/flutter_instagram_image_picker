import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'screens.dart';

class InstagramAuth with ChangeNotifier {
  static String _accessToken = "";

  String get accessToken => _accessToken;

  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> signInWithInstagram(BuildContext context) async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('access_token=')) {
        _accessToken = url.split("access_token=")[1];
        print(accessToken);
        await flutterWebviewPlugin.cleanCookies();
        await flutterWebviewPlugin.close();

        // pop the webview Scaffold and immediately enter the picker
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen2()));
      }
    });
  }
}