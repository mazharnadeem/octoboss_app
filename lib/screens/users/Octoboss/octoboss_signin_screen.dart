import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/validations.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/google/googleclass.dart';
import 'package:octbs_ui/screens/users/Customer/google/logged_in_page.dart';
import 'package:octbs_ui/screens/users/Octoboss/created_profile_login.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_forgot_pssd_scrn.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OctoBossSigninScreen extends StatefulWidget {
  const OctoBossSigninScreen({Key? key}) : super(key: key);

  @override
  _OctoBossSigninScreenState createState() => _OctoBossSigninScreenState();
}

class _OctoBossSigninScreenState extends State<OctoBossSigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailVerification = '';
  bool _passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height,
              child: Column(
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
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                              size: screenHeight * 0.02,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize * 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
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
                  Text(
                    emailVerification,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Column(
                    children: [
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.09),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: fontSize * 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                validator: (email) => email_Validation(email!),
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.09),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: fontSize * 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                // border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                validator: (password) =>
                                    password_Validation(password!),
                                controller: passwordController,
                                obscureText: !_passwordVisibility,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisibility =
                                              !_passwordVisibility;
                                        });
                                      },
                                      icon: Icon(
                                        _passwordVisibility
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          OctoBossForgotPassWordScrn()));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: fontSize * 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                octoboss_login(emailController.text.toString(),
                                    passwordController.text.toString()).whenComplete(() async {
                                });
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: fontSize * 17,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffff6e01),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "I don't have an account:",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OctoBossSignUpScreen()));
                          },
                          child: Text('Create a Octoboss Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
  Future signin() async {
    final user = await GoogleSigninApi.login();
    if (user == null) {
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoggedIN(user: user)));
    }
  }

  Future octoboss_login(String email, String password) async {
    try {
      var data = {'email': email, 'password': password,'type':'octoboss'};

      var data1 = json.encode(data);
      var response = await post(
          Uri.parse('https://admin.octo-boss.com/API/Login.php'),

          body: data1);
      if (response.statusCode == 201) {
        var responseData=response.body.toString();
        var data2 = jsonDecode(responseData);
        user_details = data2;

        final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
        sharedPreferences.setString('role', 'octoboss');
        sharedPreferences.setString('data', responseData);
        sharedPreferences.setString('language', 'english');

        login_details_Octo=responseData;
        var rolewise=data2['data'];
        setState(() {});
        RoutePage(user_details['data']['email']);
        if(rolewise['first_name']!='' && rolewise['last_name']!='' && rolewise['date_of_birth']!='' && rolewise['email']!='' && rolewise['address']!='' && rolewise['city']!='' && rolewise['street_name']!='' && rolewise['street_address']!='' && rolewise['street_no']!='' && rolewise['unit_number']!='' && rolewise['phone']!='' && rolewise['job_title']!='' && rolewise['job_info']!='' && rolewise['detail_description']!='' && rolewise['country']!='' && rolewise['postal_code']!='' && rolewise['language']!='' && rolewise['category']!=''){

            Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
            builder: (context) => OctoBossBottomNavBar()),
            (route) => false);
        }
        else{
          checkProfile=true;
          setState(() {});
          Get.offAll(ProfileORLogin(), arguments: [user_details]);
        }
      } else if (response.statusCode == 200) {

        var data2 = jsonDecode(response.body.toString());
        Fluttertoast.showToast( msg: '${data2['message'].toString()}', toastLength: Toast.LENGTH_LONG);
        user_details = data2;
        setState(() {});
      } else {
        var data2 = jsonDecode(response.body.toString());
        user_details = data2;
        setState(() {});
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
    }
  }
  void RoutePage(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", email);
  }
}
