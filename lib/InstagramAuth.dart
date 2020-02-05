import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InstagramAuth with ChangeNotifier {
  Future<String> get accessToken async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("instagram_token");
  }

  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> signInWithInstagram(BuildContext context) async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('access_token=')) {
        // save access token for later logins
        var _accessToken = url.split("access_token=")[1];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("instagram_token", _accessToken);

        await flutterWebviewPlugin.cleanCookies();
        await flutterWebviewPlugin.close();

        // pop the webview Scaffold and immediately enter the picker
        Navigator.pop(context, _accessToken);
      }
    });
  }

  Future<void> logout() async{
    // remove access token from prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_token");
  }
}