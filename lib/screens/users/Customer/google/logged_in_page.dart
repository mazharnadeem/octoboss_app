import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:octbs_ui/screens/users/Customer/customer_signin_screen.dart';
import 'package:octbs_ui/screens/users/Customer/google/googleclass.dart';

class LoggedIN extends StatelessWidget {
  final GoogleSignInAccount user;

  const LoggedIN({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Logged In'),
            TextButton(
                onPressed: () async {
                  await GoogleSigninApi.logout();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CustomerSignInScreen()));
                },
                child: Text('Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )))
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: user.photoUrl == null
                  ? NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659651__340.png')
                  : NetworkImage(user.photoUrl!),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Name' + user.displayName!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Email' + user.email,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
