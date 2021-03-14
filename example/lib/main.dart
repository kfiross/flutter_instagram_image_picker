import 'package:flutter/material.dart';
import 'package:flutter_instagram_image_picker/flutter_instagram_image_picker.dart';

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
        child: ElevatedButton(
            child: Text("Continue with instagram"),
            onPressed: () async {

              bool isLogged = await InstagramAuth().isLogged;
              // check if user already logged in, if not log the user
              if (!isLogged) {
                bool loginStatus = await InstagramAuth().signUserIn(context);

                // if user canceled the operation
                if (!loginStatus)
                  return;
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
                      items.forEach((element) {
                        print('selected: ${element.url}');
                      });
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
