import 'dart:convert';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/validations.dart';
import 'package:octbs_ui/screens/users/Octoboss/settings_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:octbs_ui/screens/users/Customer/customer_signin_screen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController ApartmentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController RepasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  String emailVerification = '';
  bool checkBoxValue = false;
  bool otpSent = false;
  String? _verificationId;
  String _code = "";
  var country_code = '';
  var country_name = '';

  Future<SettingsModel> getTermsandCondition() async {
    final response = await http.get(Uri.parse("https://admin.octo-boss.com/API/Settings.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return SettingsModel.fromJson(data);
    } else {
      return SettingsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
    Country country;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                          Get.back();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create your',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize * 25,
                            ),
                          ),
                          Text(
                            'account',
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
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                emailVerification,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: firstnameController,
                        validator: (firstname) =>
                            firstname_Validation(firstname!),
                        decoration: InputDecoration(
                          hintText: 'First Name*',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: lastnameController,
                        validator: (lastname) => lastname_Validation(lastname!),
                        decoration: InputDecoration(
                          hintText: 'Last Name*',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding:
                          EdgeInsets.only(left: 20, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: AgeController,
                        decoration: InputDecoration(hintText: 'Date of Birth*'),
                        onTap: () => _selectDate(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: AddressController,
                        decoration: InputDecoration(
                          hintText: 'Address-Optional',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: ApartmentController,
                        decoration: InputDecoration(
                          hintText: 'Appartment number',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (email) => email_Validation(email!),
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email Address*',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (password) => password_Validation(password!),
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password*',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (password) => password_Validation(password!),
                        controller: RepasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password*',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 12, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: CountryListPick(
                                initialSelection: '+1',
                                theme: CountryTheme(
                                    labelColor: Colors.black,
                                    alphabetTextColor: Colors.black,
                                    alphabetSelectedTextColor: Colors.black,
                                    alphabetSelectedBackgroundColor:
                                        Colors.black,
                                    isShowFlag: true, //show flag on dropdown
                                    isShowTitle: false, //show title on dropdown
                                    isShowCode: true, //show code on dropdown
                                    isDownIcon: true),
                                onChanged: (c) {
                                  setState(() {
                                    country_code = c.toString();
                                  });
                                },
                              ),
                              hintText: 'Phone Number*',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CountryListPick(
                              initialSelection: '+1',
                              theme: CountryTheme(
                                  isShowFlag: true, //show flag on dropdown
                                  isShowTitle: true, //show title on dropdown
                                  isShowCode: false, //show code on dropdown
                                  isDownIcon: true),
                              onChanged: (con) {
                                setState(() {
                                  country_name = con.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05, right: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (postalcode) =>
                            phone_Validation(postalcode!),
                        controller: postalCodeController,
                        decoration: InputDecoration(
                          hintText: 'Postal Code',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: Color(0xffff6e01),
                          value: checkBoxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Agree with',
                          style: TextStyle(
                            fontSize: fontSize * 15,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text('Terms & Conditions',style: TextStyle(color: Colors.deepOrange)),
                                        SizedBox(height: 20,),
                                        FutureBuilder<SettingsModel>(
                                            future: getTermsandCondition(),
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null) {
                                                return  Text(
                                                  snapshot.data!.data!.userTerCon.toString(),
                                                  style: TextStyle(fontSize: 15),
                                                );
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                            }),
                                        SizedBox(height: 20,),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                                              onPressed: () {
                                                Get.back();
                                              }, child: Text('cancel')),
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                  );
                                });
                          },
                          child: Text(
                            'Terms & Condition',
                            style: TextStyle(
                              color: Color(0xffff6e01),
                              fontSize: fontSize * 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      var phone = country_code + phoneController.text.toString();
                      if(firstnameController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('First Name is Mandatory'),
                        ));
                      }
                      else if(lastnameController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Last Name is Mandatory'),
                        ));
                      }
                      else if(emailController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Email is Mandatory'),
                        ));
                      }
                      else if(passwordController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password is Mandatory'),
                        ));
                      }
                      else if(RepasswordController.text!=passwordController.text){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password does not match'),
                        ));
                      }
                      else if(phoneController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Phone Number is Mandatory'),
                        ));
                      }
                      else if(checkBoxValue==false){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please Agree with Terms & Conditions'),
                        ));
                      }
                      else if(firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && RepasswordController.text==passwordController.text && phoneController.text.isNotEmpty && checkBoxValue==true){

                        ApiServices().customer_register(
                            firstnameController.text.toString(),
                            lastnameController.text.toString(),
                            dateTime.toString(),
                            AddressController.text.toString(),
                            ApartmentController.text.toString(),
                            emailController.text.toString(),
                            passwordController.text.toString(),
                            phone,
                            '',//street address
                            country_name,
                            postalCodeController.text.toString(),
                            "lahore",
                            "23",
                            "customer")
                            .then((value) {
                          if (value) {
                            showBottomSheet(context);
                          }
                        });
                      }
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: fontSize * 17,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xffff6e01),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have account?',
                    style: TextStyle(
                      fontSize: fontSize * 20,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => CustomerSignInScreen()));
                    },
                    child: Text(
                      'sign In',
                      style: TextStyle(
                        color: Color(0xffff6e01),
                        fontSize: fontSize * 20,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Get.height * 0.08),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(Get.height * 0.02),
                height: Get.height * 0.55,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.height * 0.08),
                  color: Color(0xffff6e01),
                ),
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    SizedBox(
                      height: Get.height * 0.25,
                      child: Image.asset('assets/images/otp_popup.png'),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter_OTP'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.height * 0.03,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            'OTP Code is sent to your Mobile Number via SMS.'
                                .tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.height * 0.014,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: Get.height * 0.003,
                          ),
                          Text(
                            'Please Enter the sent code below.'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.height * 0.014,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 25),
                      child: PinFieldAutoFill(
                        decoration: const UnderlineDecoration(
                            textStyle: TextStyle(color: Colors.white),
                            colorBuilder: FixedColorBuilder(Colors.white)),
                        currentCode: _code,
                        controller: pinCodeController,
                        onCodeChanged: (value) async {
                          if (value!.length == 6) {
                            ApiServices().verifyCode(user_id.value,
                                pinCodeController.text.toString());
                          }
                        },
                        codeLength: 6,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: Get.height * 0.02),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  DateTime dateTime = DateTime.now();

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1940),
        lastDate: DateTime.now());
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      AgeController.text = DateFormat.yMd().format(dateTime);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
