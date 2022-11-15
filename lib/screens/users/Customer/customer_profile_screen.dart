import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool showPassword = false;
  final ImagePicker picker = ImagePicker();
  bool isEdit = false;
  File? imageLink;
  String imageUrl = '';
  String name = '';
  String phone = '';
  String streetAddress = '';
  String postalCode = '';
  String country = '';
  TextEditingController nameController = TextEditingController(text: profile_data['full_name']);
  TextEditingController emailController = TextEditingController(text: profile_data['email']);
  TextEditingController phoneController = TextEditingController(text: profile_data['phone_number']);
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController(text: profile_data['street_address']);
  TextEditingController CountryController = TextEditingController();
  TextEditingController PostalCodeController = TextEditingController(text: profile_data['postal_code']);

  var country_name = '';
  var country_code = '';
  var totalReviewRating;
  var totalstars=0.0;
  get_Total_AllReviews(var id) async {
    totalstars=0.0;
    var data = {
      'user_id': id,
    };
    var encoded_data = json.encode(data);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/Reviewes.php'),
        body: encoded_data);

    if (response.statusCode == 201) {
      print('Reviews : 201');
      var reviews_res = jsonDecode(response.body.toString());
      totalReviewRating=reviews_res['data'];
      var len=totalReviewRating.length;
      for(int i=0;i<len;i++){
        var rating1=double.parse(totalReviewRating[i]['rating']);
        totalstars +=rating1;
      }
      totalstars /=len;
      totalstars=double.parse(totalstars.toStringAsFixed(2));
      return true;
    }

    if (response.statusCode == 200) {
      print('Reviews : 200');
      var reviews_res = jsonDecode(response.body.toString());
      return false;
    }

    else {
      print('Reviews : else');
      var issue_response = jsonDecode(response.body.toString());
    }
  }

  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      print ('Get User by Id : 201');
      var data1 = jsonDecode(response.body.toString());
      profile_data = data1['data'];
      return profile_data;
    }
    else {
      print ('Get User by Id : 200');
      return false;
    }
  }

  @override
  void initState() {
    get_user_by_id(user_details['data']['id']);
    setState(() {
      profile_data;
    });
    // TODO: implement initState
    super.initState();
  }
  late Future get_rating;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    get_rating=get_Total_AllReviews(user_details['data']['id']);
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Row(
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
                        setState(() {
                          isEdit=false;
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                        size: screenHeight * 0.02,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: isEdit == false
                      ? null
                      : () {
                    showImagePicker(context);
                  },
                  child: Container(
                      height: 130,
                      width: 150,
                      child: imageLink == null
                          ? Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.network(profile_data['picture'].toString(),fit: BoxFit.fill,)
                        ),
                      )
                          : CircleAvatar(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          clipBehavior: Clip.hardEdge,
                          child: Image.file(
                            File(imageLink!.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(

                          shape: BoxShape.circle)),
                ),
              ),
              SizedBox(height: 35),
              Visibility(
                visible: isEdit ? false : true,
                child: Row(
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              FutureBuilder(
                future: get_user_by_id(user_details['data']['id']),
                builder: (context, snapshot) {
                  if(profile_data==null){
                    return CircularProgressIndicator();
                  }
                  else{
                    return Column(
                      children: [

                        Container(
                          child: FutureBuilder(
                            future:get_rating,
                            builder: (context, snapshot) {
                              if(snapshot.connectionState==ConnectionState.waiting){
                                return CircularProgressIndicator();
                              }
                              else{
                                return Center(
                                    child: SmoothStarRating(
                                        allowHalfRating: true,
                                        onRated: (v) {},
                                        starCount: 5,

                                        rating: totalstars,
                                        size: 45.0,
                                        isReadOnly: true,
                                        color: Colors.yellow,
                                        borderColor: Colors.yellow,
                                        spacing: 0.0));
                              }
                            },),
                        ),

                        SizedBox(height: 35),
                        TextFormField(
                          enabled: isEdit,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'Name'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 35),
                        TextFormField(
                          enabled: false,
                          controller: emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'Email'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 35),
                        Visibility(
                          visible: isEdit,
                          child: TextFormField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              prefixIcon: CountryListPick(
                                initialSelection: '+1',
                                theme: CountryTheme(
                                    labelColor: Colors.black,
                                    alphabetTextColor: Colors.black,
                                    alphabetSelectedTextColor: Colors.black,
                                    alphabetSelectedBackgroundColor: Colors.black,
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
                              hintText: 'Phone Number'.tr,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Visibility(
                          visible: !isEdit,
                          child: TextFormField(
                            enabled: false,
                            controller: phoneController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 3),
                              labelText: 'Phone Number'.tr,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        TextFormField(
                          enabled: isEdit,
                          controller: streetAddressController,
                          onChanged: (value) {
                            setState(() {
                              streetAddress = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'Street Address'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 35),
                        TextFormField(
                          enabled: isEdit,
                          controller: PostalCodeController,
                          onChanged: (value) {
                            setState(() {
                              postalCode = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'Postal Code'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                    ],
                    );
                  }

              },),


              SizedBox(height: 35),
              Visibility(
                visible: isEdit,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      var code=country_code==''?'+1':country_code;
                      var phone=code+phoneNumberController.text;
                      ApiServices().custmrprofile(
                          nameController.text.toString(),
                          emailController.text.toString(),
                          phone.toString(),
                          streetAddressController.text.toString(),
                          // CountryController.text.toString(),
                          PostalCodeController.text.toString(),
                          totalstars.toString(),
                          imageLink?.path
                      );
                      get_user_by_id(user_details['data']['id']);
                      setState(() {
                        isEdit=false;
                      });
                      Timer(Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      },);

                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xffff6e01)),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))

                    ),
                    child: Text(
                      "Save".tr,
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                      'Photo library',
                    ),
                    onTap: () {
                      getImageGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'Camera',
                  ),
                  onTap: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void getImageGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      imageLink = File(image!.path);
    });
  }

  void getImageCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      imageLink = File(image!.path);
    });
  }
}
