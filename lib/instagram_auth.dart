import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_image_picker/instagram_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens.dart';

/// The entry point of the custom Instagram Authentication
class InstagramAuth with ChangeNotifier {
  static final InstagramAuth _singleton = InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  /// Signing out the current user
  /// Also removes all access data from prefs
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_auth.logged");
    prefs.remove("instagram_auth.sessionKey");
    prefs.remove("instagram_auth.userId");
  }

  /// Saving access data on cache for later usage
  Future<void> _setData(
      {@required String sessionKey, @required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("instagram_auth.logged", true);
    await prefs.setString("instagram_auth.sessionKey", sessionKey);
    await prefs.setString("instagram_auth.userId", userId);
  }

  /// Checks if the current user is already logged in
  Future<bool> get isLogged async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("instagram_auth.logged") ?? false;
  }

  /// Return the unique access data (userID & sessionKey) generated when
  /// he logged in
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

  /// Tries to login a user (by his username)
  /// If successful, keep the access data on cache
  Future<void> login(String username, String password) async {
    Map accessMapResponse =
        await InstagramApiClient().signInUser(username, password);
    await _setData(
      sessionKey: accessMapResponse['sessionKey'],
      userId: "${accessMapResponse['userID']}",
    );
  }

  /// Singing in the user by designated screen for entering his login data
  /// Return true if user filled in the login form
  /// Return false if the user aborted the login
  Future<bool> signUserIn(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InstagramLoginPage(),
      ),
    );
    return result ?? false;
  }
}
