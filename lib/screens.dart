import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'instagram_auth.dart';

/// Screen mimicking the login process of an Instagram account
class InstagramLoginPage extends StatefulWidget {
  @override
  _InstagramLoginPageState createState() => _InstagramLoginPageState();
}

class _InstagramLoginPageState extends State<InstagramLoginPage> {
  String _username;
  String _password;
  bool _isValid = false;
  bool _isPasswordVisible = false;
  bool _selectedPasswordField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: !_selectedPasswordField
                              ? Colors.grey[700]
                              : Colors.grey,
                          width: 1.1,
                        )),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _selectedPasswordField = false;
                        });
                      },
                      initialValue: _username ?? '',
                      onChanged: (val) {
                        _username = val;
                        _checkForm();
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        isDense: true,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _selectedPasswordField
                              ? Colors.grey[700]
                              : Colors.grey,
                          width: 1.1,
                        )),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _selectedPasswordField = true;
                        });
                      },
                      initialValue: _password ?? '',
                      onChanged: (val) {
                        _password = val;
                        _checkForm();
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        isDense: true,
                        suffixIcon: Container(
                          width: 76,
                          height: 40,
                          color: Colors.grey[100],
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              _isPasswordVisible ? "Hide" : "Show",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        // hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
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

  /// Checking if the form is valid, and enables/disables the login button
  /// accordingly
  void _checkForm() {
    setState(() {
      _isValid = _password.isNotEmpty && _username.isNotEmpty;
    });
  }
}
