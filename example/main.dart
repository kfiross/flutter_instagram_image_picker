import 'package:flutter/material.dart';
import 'package:flutter_instagram_image_picker/InstagramAuth.dart';
import 'package:flutter_instagram_image_picker/flutter_instagram_image_picker.dart';
import 'package:flutter_instagram_image_picker/screens.dart';

void main() => runApp(
      new MaterialApp(
        title: 'Instagram picker Demo',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram login demo'),
      ),
      body: Center(
        child: RaisedButton(
            child: Text("Continue with instagram"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => InstagramWebViewLoginPage()));

            }),
      ),
    );
  }
}
class ResultsScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accessToken = InstagramAuth().accessToken;

    return Container(
      child: InstagramImagePicker(
      accessToken,
      onDone: (items) {
        // items contains the urls of the selected photos
        print(items.length);
        Navigator.pop(context);
      },
      onCancel: () => Navigator.pop(context),
      ),
    );
  }

}
