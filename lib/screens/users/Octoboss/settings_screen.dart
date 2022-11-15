import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/empty_userDetails.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/send_notification.dart';
import 'package:octbs_ui/screens/users/Customer/google/googleclass.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_about_us.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_signin_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/select_page.dart';

// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'octoboss_profile_scrn.dart';
import 'package:http/http.dart' as http;

class OctobossSettingsScreen extends StatefulWidget {
  @override
  _OctobossSettingsScreenState createState() => _OctobossSettingsScreenState();
}

class _OctobossSettingsScreenState extends State<OctobossSettingsScreen> {
  bool showPassword = false;
  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      profile_data = data1['data'];
      if(data1['data']['block']=='1'){
        Fluttertoast.showToast(msg: 'Your account is blocked');
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.remove('role');
        pref.remove('data');
        user_details=null;
        Get.offAll(SelectPage());
      }
      setState(() {
        profile_data;
      });
      return profile_data;

    } else {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    get_user_by_id(user_details['data']['id']);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Settings'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Profile'.tr),
              leading: Icon(Icons.person),
              onTap: () {
                if(profile_data!=null){
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: EditProfilePage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }

              },
            ),
            ExpansionTile(
              title: Text('Language'.tr),
              leading: Icon(Icons.language),
              children: <Widget>[
                ListTile(
                  title: Text('English'.tr),
                  leading: Icon(Icons.translate),
                  onTap: () async {
                    var locale = const Locale('english');
                    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    sharedPreferences.setString('language', 'english');
                    Get.updateLocale(locale);
                  },
                ),
                ListTile(
                  title: Text('French'.tr),
                  leading: Icon(Icons.translate),
                  onTap: () async {
                    var locale = const Locale('french');
                    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    sharedPreferences.setString('language', 'french');
                    Get.updateLocale(locale);
                  },
                ),
                ListTile(
                  title: Text('Arabic'.tr),
                  leading: Icon(Icons.translate),
                  onTap: () async {
                    var locale = const Locale('arabic');
                    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    sharedPreferences.setString('language', 'arabic');
                    Get.updateLocale(locale);
                  },
                ),
              ],
            ),
            ListTile(
              title: Text('Terms and conditions'.tr),
              leading: Icon(Icons.policy),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndCondition()));
              },
            ),
            ListTile(
              title: Text('About us'.tr),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OctobossAboutUs()));
              },
            ),
            ListTile(
              title: Text('Logout'.tr),
              leading: Icon(Icons.logout),
              onTap: () async {
                makeEmpty();
                final SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove('role');
                pref.remove('data');
                Get.offAll(SelectPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsModel {
  int? response;
  int? code;
  Data? data;

  SettingsModel({this.response, this.code, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class TermsAndCondition extends StatefulWidget {
  TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {

  Future<SettingsModel> getPostApi() async {
    final response = await http
        .get(Uri.parse("https://admin.octo-boss.com/API/Settings.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return SettingsModel.fromJson(data);
    } else {
      return SettingsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: screenWidth * 0.04),
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
            ],
          ),
          Expanded(
            child: FutureBuilder<SettingsModel>(
                future: getPostApi(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 8),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!.data!.octoTerCon.toString(),
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ));
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )
        ],
      )),
    );
  }
}

class Data {
  String? aboutOctoboss;
  String? aboutOctobossShow;
  String? aboutUser;
  String? aboutUserShow;
  String? octoNotification;
  String? octoNotificationShow;
  String? octoTerCon;
  String? octoTerConShow;
  String? userTerCon;
  String? userTerConShow;
  String? userNotification;
  String? userNotificationShow;

  Data(
      {this.aboutOctoboss,
      this.aboutOctobossShow,
      this.aboutUser,
      this.aboutUserShow,
      this.octoNotification,
      this.octoNotificationShow,
      this.octoTerCon,
      this.octoTerConShow,
      this.userTerCon,
      this.userTerConShow,
      this.userNotification,
      this.userNotificationShow});

  Data.fromJson(Map<String, dynamic> json) {
    aboutOctoboss = json['about_octoboss'];
    aboutOctobossShow = json['about_octoboss_show'];
    aboutUser = json['about_user'];
    aboutUserShow = json['about_user_show'];
    octoNotification = json['octo_notification'];
    octoNotificationShow = json['octo_notification_show'];
    octoTerCon = json['octo_ter_con'];
    octoTerConShow = json['octo_ter_con_show'];
    userTerCon = json['user_ter_con'];
    userTerConShow = json['user_ter_con_show'];
    userNotification = json['user_notification'];
    userNotificationShow = json['user_notification_show'];
  }
}
