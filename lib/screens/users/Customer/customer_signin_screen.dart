import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/validations.dart';
import 'package:octbs_ui/screens/users/Customer/cstmr_forgot_password_screen.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/google/facebook_auth.dart';
import 'package:octbs_ui/screens/users/Customer/google/fb_profile.dart';
import 'package:octbs_ui/screens/users/Customer/google/googleclass.dart';
import 'package:octbs_ui/screens/users/Customer/google/logged_in_page.dart';
import 'package:octbs_ui/screens/users/Customer/sign_up/customer_sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSignInScreen extends StatefulWidget {
  const CustomerSignInScreen({Key? key}) : super(key: key);

  @override
  _CustomerSignInScreenState createState() => _CustomerSignInScreenState();
}

class _CustomerSignInScreenState extends State<CustomerSignInScreen> {
  bool _isLoggedIn = false;
  Map _userObj = {};
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailVerification = '';
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
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
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColorDark,
                                        ))
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
                                          CustomerForgotPasswordScreen()));
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
                                customer_login(emailController.text.toString(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.to(HomePage());
                                },
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffff6e01),
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              GestureDetector(
                                onTap: () {
                                  signin();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffff6e01),
                                  child: FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("I don't have an account:",
                            style: TextStyle(
                              color: Colors.grey[600],
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => SignUpScreen()));
                          },
                          child: Text('Create a Customer Account',
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
          )),
    );

  }
  Future signin() async {
    final user = await GoogleSigninApi.login();

    if (user == null) {
      print('Error');
    } else {
      google_sign_withApi(user.displayName, user.email);
    }
  }
  google_sign_withApi(var name,var email) async {
    var data = {'name': name,'email':email,'type':'customer'};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/APISignup.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1=jsonDecode(response.body.toString());
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('social', 'google');
      get_user_by_id(data1['user_id']);

    } else {
      print ('Get User by Id : 200');
      return false;
    }
  }
  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      
      user_details=data1;
      Get.offAll(CustomerNavBar(), arguments: [user_details]);
    } else {
      print ('Get User by Id : 200');
      return false;
    }
  }

   Future customer_login(String email, String password) async {
    try {
      var data = {'email': email, 'password': password,'type':'customer'};

      var data1 = json.encode(data);
      var response = await post(
          Uri.parse('https://admin.octo-boss.com/API/Login.php'),
          body: data1);
      if (response.statusCode == 201) {
        print('Customer Login : 201');
        var responseBody=response.body.toString();
        var data2 = jsonDecode(responseBody);

        final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
        sharedPreferences.setString('role', 'customer');
        sharedPreferences.setString('data', responseBody);
        sharedPreferences.setString('language', 'english');

        user_details = data2;
        login_details = responseBody;
        setState(() {});
        RoutePage(user_details['data']['email']);
        Get.offAll(CustomerNavBar(), arguments: [user_details]);
      } else if (response.statusCode == 200) {
        print('Customer Login : 200');
        var data2 = jsonDecode(response.body.toString());
        Fluttertoast.showToast(
            msg: '${data2['message'].toString()}',
            toastLength: Toast.LENGTH_LONG);
        user_details = data2;
        setState(() {});
      } else {
        print('Customer Login : else');
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
