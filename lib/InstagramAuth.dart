import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_image_picker/graph_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstagramAuth with ChangeNotifier {
  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> logout() async {
    // remove access data from prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_auth.logged");
    prefs.remove("instagram_auth.sessionKey");
    prefs.remove("instagram_auth.userId");
  }

  Future<void> _setData(
      {@required String sessionKey, @required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("instagram_auth.logged", true);
    await prefs.setString("instagram_auth.sessionKey", sessionKey);
    await prefs.setString("instagram_auth.userId", userId);
  }

  Future<bool> get isLogged async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("instagram_auth.logged") ?? false;
  }

  Future<Map<String, String>> get accessData async {
    if (!await isLogged) {
      return null;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionKey = prefs.getString("instagram_auth.sessionKey");
    String userId = prefs.getString("instagram_auth.userId");

    return {
      'sessionKey': sessionKey,
      'userId': userId,
    };
  }

  Future<void> login(String username, String password) async {
    Map accessMapResponse =
        await InstagramApiClient().signInUser(username, password);
    await _setData(
      sessionKey: accessMapResponse['sessionKey'],
      userId: "${accessMapResponse['userID']}",
    );
  }
}
