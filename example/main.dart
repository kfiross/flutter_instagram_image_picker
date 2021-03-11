import 'package:flutter/material.dart';
import 'package:flutter_instagram_image_picker/InstagramAuth.dart';
import 'package:flutter_instagram_image_picker/flutter_instagram_image_picker.dart';
import 'package:flutter_instagram_image_picker/screens.dart';

void main() => runApp(
      MaterialApp(
        title: 'Instagram picker Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginPage(),
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
            onPressed: () async {

              Map loginMap;
              bool isLogged = await InstagramAuth().isLogged;
              // check if user already logged in, if not log the user using the
              // WebView interface
              if (!isLogged) {
                loginMap = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InstagramLoginPage(),
                    ));

                // if user canceled the operation
                if (loginMap == null)
                  return;

                await InstagramAuth().login(loginMap['username'], loginMap['password']);
              }


              final accessMapData = await InstagramAuth().accessData;
              if(accessMapData == null){
                return null;
              }

              // After got the access data, can go to picker screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InstagramImagePicker(
                    accessMapData,
                    showLogoutButton: true,
                    onDone: (items) {
                      Navigator.pop(context);
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
