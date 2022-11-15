import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:octbs_ui/screens/users/Customer/customer_signin_screen.dart';
import 'dart:convert';

import 'package:octbs_ui/screens/users/Octoboss/octoboss_forgot_pssd_scrn.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_signin_screen.dart';

class CustomerOTPScreen extends StatefulWidget {
  const CustomerOTPScreen({Key? key}) : super(key: key);

  @override
  State<CustomerOTPScreen> createState() => _CustomerOTPScreenState();
}

class _CustomerOTPScreenState extends State<CustomerOTPScreen> {

  TextEditingController otpController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  void changepass(new_password,otp_code, email) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://admin.octo-boss.com/API/ChangePassword.php'));
    request.body = json.encode({
      "email": email,
      "new_password": new_password,
      "otp_code": otp_code
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      final snackBar = SnackBar(
        content: const Text('Password changed'),
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
              builder: (context) =>  CustomerSignInScreen()));
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
            child: ListView(
              children: [
                Row(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 1.0,
                      fillColor: Colors.white70,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_back_ios,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(12.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                Flexible(
                  // flex: 2,
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
                      )
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(

                    children: [
                      Text(
                        'Select New Password',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xffff6e01),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Set your new password here',
                        style: TextStyle(
                          color: Color(0xff2B335E),
                        ),
                      ),
                    ],),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: TextFormField(
                    controller: otpController,

                    decoration: InputDecoration(

                      hintText: 'Enter Otp',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: TextFormField(
                    controller: newpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                ),
                SizedBox(
                  height: 40,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 130,right: 130),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      minWidth: 180,
                      color: Color(0xffff6e01),
                      height: 50,
                      onPressed: () {
                        var em=Get.arguments[0];
                        changepass(newpasswordController.text, otpController.text,em );
                      },
                      child: Text(
                        'Change',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}