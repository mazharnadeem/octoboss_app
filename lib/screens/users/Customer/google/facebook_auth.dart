import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facebook"),
      ),
      body: Container(
        child: _isLoggedIn
            ? Column(
          children: [
            Image.network(_userObj["picture"]["data"]["url"]),
            Text(_userObj[ "name"]),
            Text(_userObj["email"]),
            TextButton(
                onPressed: () {
                  FacebookAuth.instance.logOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                      _userObj = {};
                    });
                  });
                },
                child: Text("Logout")),
          ],
        )
            : Center(
          child: ElevatedButton(
            child: Text("Login with Facebook"),
            onPressed: () async {
              signInWithFacebook();
            },
          ),
        ),
      ),
    );
  }
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      _checking = false;
    });
  }

  void signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: (['email', 'public_profile']));


      if (result.status == LoginStatus.success) {

        final token = result.accessToken!.token;
        print('Facebook token userID : ${result.accessToken!.grantedPermissions}');
        final graphResponse = await http.get(Uri.parse( 'https://graph.facebook.com/'
            'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));

        final profile = jsonDecode(graphResponse.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(profile.toString())));
      } else {
        print(result.status);
        print(result.message);
      }

    } catch (e) {
      print("error occurred");
      print(e.toString());
    }
  }
}