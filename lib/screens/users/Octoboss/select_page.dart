import 'dart:async';
import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/send_notification.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/customer_signin_screen.dart';
import 'package:octbs_ui/screens/users/Customer/google/facebook_auth.dart';
import 'package:octbs_ui/screens/users/Customer/home/customer_home_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/created_profile_login.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_profile_screen_publicView.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_profile_scrn.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {


  var obRole;
  var obData;
  var obLang;

  Future getLoginBefore() async{

    final SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    var obtainedRole=sharedPreferences.getString('role');
    var obtainedData=sharedPreferences.getString('data');
    var obtainedLanguage=sharedPreferences.getString('language');

    setState(() {
      obRole=obtainedRole;
      obData=obtainedData;
      obLang=obtainedLanguage;
    });
  }
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
        // Fluttertoast.showToast(msg: 'You are blocked');
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

    getLoginBefore().whenComplete(() async{
      if(obRole!=null){
        user_details=jsonDecode(obData);
        Box box=await Hive.openBox('dbbox');

        final cron=Cron();
        cron.schedule(Schedule.parse('*/5 * * * * *'), () async{
          // (* * * * * *)==(Second Minute Hour - Month Day)

          var data = {'user_id': user_details['data']['id']};
          var data2 = json.encode(data);
          var response = await post(
              Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
              body: data2);
          if (response.statusCode == 201) {
            var data1 = jsonDecode(response.body.toString());
            if(data1['data']['block']=='1'){
              Fluttertoast.showToast(msg: 'Your account is blocked');
              final SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('role');
              pref.remove('data');
              user_details=null;

              Get.offAll(SelectPage());
            }
            return profile_data;
          } else {
            return false;
          }

        },);

        if(obRole=='customer'){
          var locale=Locale(obLang);
          Get.updateLocale(locale);
          Get.to(CustomerNavBar());
        }
        if(obRole=='octoboss'){
          var locale=Locale(obLang);
          Get.updateLocale(locale);
          var role=jsonDecode(obData);

          var rolewise=role['data'];
          if(rolewise['first_name']!='' && rolewise['last_name']!='' && rolewise['date_of_birth']!='' && rolewise['email']!='' && rolewise['address']!='' && rolewise['city']!='' && rolewise['street_name']!='' && rolewise['street_address']!='' && rolewise['street_no']!='' && rolewise['unit_number']!='' && rolewise['phone']!='' && rolewise['job_title']!='' && rolewise['job_info']!='' && rolewise['detail_description']!='' && rolewise['country']!='' && rolewise['postal_code']!='' && rolewise['language']!='' && rolewise['category']!=''){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => OctoBossBottomNavBar()),
                    (route) => false);
          }
          else{
            checkProfile=true;
            setState(() {
            });
            Get.offAll(ProfileORLogin(), arguments: [user_details]);
          }
        }
      }
      else{
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Get.size.height*0.3,
                  width: Get.size.width*0.5,
                  child: Image.asset('assets/images/BigLogo.png'),
                ),
                SizedBox(
                  height: 25,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerSignInScreen()));
                          },
                          child: Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 17,
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
                                  side: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OctoBossSigninScreen()));
                          },
                          child: Text(
                            'Octoboss',
                            style: TextStyle(
                              fontSize: 17,
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
                                  side: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

    );
  }
}
