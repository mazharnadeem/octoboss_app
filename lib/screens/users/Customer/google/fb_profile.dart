import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FbProfile extends StatefulWidget {
  const FbProfile({Key? key}) : super(key: key);

  @override
  _FbProfileState createState() => _FbProfileState();
}

class _FbProfileState extends State<FbProfile> {
  Map _userObj = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  Column(
        children: [
        Image.network(_userObj["picture"]["data"]["url"]),
    Text(_userObj[ "name"]),
    Text(_userObj["email"]),
    TextButton(
    onPressed: () {
    FacebookAuth.instance.logOut().then((value) {
    setState(() {
    // _isLoggedIn = false;
    _userObj = {};
    });
    });
    },
    child: Text("Logout")),
    ],
    ),
    ));
  }
}
