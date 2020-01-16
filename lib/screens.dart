import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'InstagramAuth.dart';

class InstagramWebViewLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url =
        "https://instagram.com/oauth/authorize/?client_id=1677ed07ddd54db0a70f14f9b1435579&redirect_uri=http://instagram.pixelunion.net&response_type=token&hl=en";

    InstagramAuth().signInWithInstagram(context);

    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text('Login to Instagram', style: TextStyle(color: Colors.white),),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );
  }
}
