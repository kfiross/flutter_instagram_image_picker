import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'model/photo_paging.dart';

class GraphApi {
  static const String _mediaApiEndpoint =
      'https://instagram-media-api-2021.herokuapp.com';

  //final String _accessToken;

  // final String sessionKey;
  // final String userId;

  GraphApi();//{@required this.sessionKey, @required this.userId});//this._accessToken);

  Future<Map> signInUser(String username, String password) async {
    String url = "$_mediaApiEndpoint/login?username=$username&password=$password";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode != 200){
      return {};
    }
    return json.decode(response.body);
  }
  
  Future<PhotoPaging> fetchPhotos({@required String sessionKey, @required String userId}) async {
    //String url = pagingUrl ?? '$_graphApiEndpoint/?access_token=$_accessToken';

    String url = "$_mediaApiEndpoint/media?sessionKey=$sessionKey&user_id=$userId";

    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> body = {};
    if (response.statusCode == 200) {
      body = json.decode(response.body);
      //throw GraphApiException(body['error']['message'].toString());
    }

    return PhotoPaging.fromJson(body);
  }
}
