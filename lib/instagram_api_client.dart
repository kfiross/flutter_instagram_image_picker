import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'model/photo_paging.dart';

/// Class that handles the communication with the (custom-made) API
class InstagramApiClient {
  static const String _endpoint =
      'https://instagram-media-api-2021.herokuapp.com';

  InstagramApiClient();

  /// Signing in a user with the given username and password
  Future<Map> signInUser(String username, String password) async {
    String url = "$_endpoint/login?username=$username&password=$password";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print(response.statusCode);
      return {};
    }

    return json.decode(response.body);
  }

  /// Retrieve an instagram account's feed images recognized by [sessionKey]
  /// and his [userId]
  Future<PhotoPaging> fetchPhotos({
    @required String sessionKey,
    @required String userId,
    int page,
  }) async {
    //String url = pagingUrl ?? '$_graphApiEndpoint/?access_token=$_accessToken';

    String url = "$_endpoint/media?sessionKey=$sessionKey&user_id=$userId";
    if (page != null) {
      url += "&page=$page";
    }

    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> body = {};
    if (response.statusCode == 200) {
      body = json.decode(response.body);
    }

    return PhotoPaging.fromJson(body);
  }
}
