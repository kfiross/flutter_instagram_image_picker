import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/photo_paging.dart';

class GraphApi {
  static const String _graphApiEndpoint =
      'https://api.instagram.com/v1/users/self/media/recent';

  final String _accessToken;

  GraphApi(this._accessToken);

  Future<PhotoPaging> fetchPhotos({String pagingUrl}) async {
    String url = pagingUrl ?? '$_graphApiEndpoint/?access_token=$_accessToken';

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode != 200) {
      //throw GraphApiException(body['error']['message'].toString());
    }

    return PhotoPaging.fromJson(body);
  }
}
