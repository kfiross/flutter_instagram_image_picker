import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'env.dart';
import 'model/photo_paging.dart';

/// Class that handles the communication with the (custom-made) API
class InstagramApiClient {
  static const String _igQueryEndpoint =
      "https://www.instagram.com/web/search/topsearch";
  static const String _igScrapperEndpoint =
      "https://instagram-scraper-data.p.rapidapi.com";

  InstagramApiClient();

  /// Signing in a user with the given username and password
  // Future<Map> signInUser(String username, String password) async {
  //   String url = "$_endpoint/login?username=$username&password=$password";
  //   var response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode != 200) {
  //     return {};
  //   }
  //
  //   return json.decode(response.body);
  // }

  /// Attach a user with the given username
  Future<Map> attachUser(String username) async {
    var userId = await getUserId(username);
    return {
      'userID': userId,
    };
  }

  /// Retrieve the user's by his username
  Future<String?> getUserId(String username) async {
    String url = "$_igQueryEndpoint?query=$username";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var users = body['users'] ?? [];
      if (users.isEmpty == true) {
        return null;
      }
      var userJson = users.first as Map<String, dynamic>;
      String igUserId = userJson['user']['pk'];
      return igUserId;
    } else {
      return null;
    }
  }

  /// Retrieve an instagram account's PUBLIC feed images recognized by
  /// his [userId]
  Future<PhotoPaging> fetchPhotos({
    //required String sessionKey,
    required String userId,
    //int? page,
  }) async {
    const limit = 16;
    String url =
        '$_igScrapperEndpoint/userpost/$userId/$limit/%7Bend_cursor%7D';

    var response = await http.get(Uri.parse(url), headers: {
      'X-RapidAPI-Key': Env.apiKey,
      'X-RapidAPI-Host': 'instagram-scraper-data.p.rapidapi.com'
    });

    Map<String, dynamic> body = {};
    if (response.statusCode == 200) {
      body = json.decode(response.body);
    }

    List<String> urls = [];
    final edges = body['data']['edges'];
    for (var map in edges) {
      urls.add(map['node']['display_url']);
    }
    Map body2 = {
      'data': urls,
    };
    return PhotoPaging.fromJson(body2);
  }
}
