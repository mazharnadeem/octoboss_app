import 'package:flutter/material.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_otp_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:octbs_ui/screens/users/Octoboss/set_password.dart';

var emailone;

class OctoBossForgotPassWordScrn extends StatefulWidget {
  const OctoBossForgotPassWordScrn({Key? key}) : super(key: key);

  @override
  State<OctoBossForgotPassWordScrn> createState() => _OctoBossForgotPassWordScrnState();
}

class _OctoBossForgotPassWordScrnState extends State<OctoBossForgotPassWordScrn> {
  var emailController = TextEditingController();

  void forgtpassword(var email) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://admin.octo-boss.com/API/SendOTP.php'));
    request.body = json.encode({
      "email": email,
      "type": "email"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      emailone =email;
      final snackBar = SnackBar(
        content: const Text('Varification code send to your mail'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );


      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewPassword()));
    }
    else {
      final snackBar = SnackBar(
        content: const Text('Somethig went wrong'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


  }
  @override

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.08,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          alignment: Alignment.center,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: screenHeight * 0.02,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot your password',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: fontSize * 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/images/Logo_NameSlogan_Map.png',
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (value){},
                      decoration: InputDecoration(hintText: 'Email or Phone no'),
                    )
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Container(
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      onPressed: () {
                        forgtpassword(emailController.text);

                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: fontSize * 17,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffff6e01),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)))),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}