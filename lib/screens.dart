import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'instagram_auth.dart';

class InstagramLoginPage extends StatefulWidget {
  @override
  _InstagramLoginPageState createState() => _InstagramLoginPageState();
}

class _InstagramLoginPageState extends State<InstagramLoginPage> {
  String _username;
  String _password;
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Login to Instagram',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/ig_logo.png',
                package: 'flutter_instagram_image_picker',
              ),
            ),
            // Expanded(child: Container(), flex: 1),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    height: 48,
                    child: TextFormField(
                      initialValue: _username ?? '',
                      onChanged: (val) {
                        _username = val;
                        _checkForm();
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.9),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 48,
                    child: TextFormField(
                      initialValue: _password ?? '',
                      onChanged: (val) {
                        _password = val;
                        _checkForm();
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.9),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: CupertinoButton.filled(
                        disabledColor: Colors.blue[100],
                        padding: const EdgeInsets.all(2),
                        borderRadius: BorderRadius.circular(4),
                        child: Text("Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        onPressed: !_isValid
                            ? null
                            : () async {
                                await InstagramAuth().login(
                                  _username,
                                  _password,
                                );
                                Navigator.pop(context, true);
                              }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkForm() {
    setState(() {
      _isValid = _password.isNotEmpty && _username.isNotEmpty;
    });
  }
}
