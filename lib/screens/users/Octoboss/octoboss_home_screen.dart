import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Octoboss/Issues_market_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_boost_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_chatlist_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_issues_list_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_membership_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_notification_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_profile_scrn.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_reports_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/reviewscreen_octoboss.dart';
import 'package:octbs_ui/screens/users/Octoboss/select_page.dart';
import 'package:octbs_ui/screens/users/Octoboss/services_offered_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/settings_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

 var octoAnnounce;
class OctoBossHomeScreen extends StatefulWidget {
  const OctoBossHomeScreen({Key? key}) : super(key: key);

  @override
  State<OctoBossHomeScreen> createState() => _OctoBossHomeScreenState();
}

class _OctoBossHomeScreenState extends State<OctoBossHomeScreen> {
  var status=false;
  var public_issue='public';

  bool isSwitch = false;
  bool? dynamicSwitch;
  bool isSwitched = false;
  var textValue = 'Status is OFF';
  var toggle_Disable=false;

  String? announcment;
  int count = 0;
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
       print ('Get User by Id : 201 :$profile_data');
       setState(() {
         profile_data;
       });

       return profile_data;
     } else {
       print ('Get User by Id : 200');
       return false;
     }
   }
   Future<SettingsModel> getTermsandCondition() async {
     final response = await http.get(Uri.parse("https://admin.octo-boss.com/API/Settings.php"));
     var data = jsonDecode(response.body.toString());
     if (response.statusCode == 201) {
       octoAnnounce=data;
       if(octoAnnounce['data']['octo_notification_show'].toString()=='1'){
         await checkdialog();
       }
       return SettingsModel.fromJson(data);
     } else {
       return SettingsModel.fromJson(data);
     }
   }
   checkdialog(){
     showDialog<void>(
         context: context,
         barrierDismissible: false, // user must tap button!
         builder: (BuildContext context) {
           return AlertDialog(
             title: Column(
               children: [
                 Text('Announcement',style: TextStyle(color: Colors.deepOrange)),
                 SizedBox(height: 20,),
                 Text(
                   '${octoAnnounce['data']['octo_notification'].toString()}',
                   style: TextStyle(fontSize: 15),
                 ),
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
   }
   che(){
     getTermsandCondition();
   }

  @override
  void initState() {
    approvedOfferList(user_details['data']['id']);
    get_user_by_id(user_details['data']['id']);
    if(octoAnnounce==null){
      che();
    }
    // TODO: implement initState
    super.initState();
  }
   approvedOfferList(String receiverId,{var onlyforOffer}) async{
     try{
       var data={'receiver_id':receiverId};

       var data1=json.encode(data);
       var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetApprovedOffers.php'),
           body: data1
       );
       if(response.statusCode==201){
         var data2=jsonDecode(response.body.toString());
         var offerlist_data=data2['data'];
         if(offerlist_data!=[]){
           for(int i=0;i<offerlist_data.length;i++){
             if(offerlist_data[i]['sender_id']==user_details['data']['id']){
               offer_data=offerlist_data[i];
               checkOfferTime(offerlist_data[i]['time'], offerlist_data[i]['date'],receiverId: offerlist_data[i]['receiver_id'],chatId: offerlist_data[i]['offer_id']);
             }
           }
         }
         return true;
       }
       else if(response.statusCode==200){
         print('Get Approved Offer : 200');
         var data2=jsonDecode(response.body.toString());
         // Fluttertoast.showToast(msg: '${data2['message'].toString()}');
         print(data);
         return false;
       }
       else{
         print('Get Approved Offer  : else');
         var data2=jsonDecode(response.body.toString());
         // Fluttertoast.showToast(msg: '${data2['message'].toString()}');

         print(data);
         return false;
       }

     }catch(e){
       // Fluttertoast.showToast(msg: e.toString());
       return false;
     }

   }
   checkOfferTime(var time,var date,{var receiverId,var chatId}) async{
     try{
       var data={'time':time,'date':date};

       var data1=json.encode(data);
       var response=await post(Uri.parse('https://admin.octo-boss.com/API/CheckOfferTime.php'),
           body: data1
       );
       if(response.statusCode==201){

         print('Offer Time : 201');
         var data2=jsonDecode(response.body.toString());

         var offertime=data2['message'];
         if(offertime==null){
           print('Offer Time is Null');
         }
         else{
           print('Offer Time is not Null');
           review_details=chatId;
           Get.to(ReviewScreenOctoboss());
         }
         print('Offer Time Data $offertime');
         return true;
       }
       else if(response.statusCode==200){
         print('Offer Time : 200');
         var data2=jsonDecode(response.body.toString());
         // Fluttertoast.showToast(msg: '${data2['message'].toString()}');
         return false;
       }
       else{
         print('Offer Time : else');
         var data2=jsonDecode(response.body.toString());
         // Fluttertoast.showToast(msg: '${data2['message'].toString()}');

         return false;
       }

     }catch(e){
       // Fluttertoast.showToast(msg: e.toString());
       return false;
     }

   }
   checkToggle() async {
     var data=await ApiServices().toggleStatus_userById(user_details['data']['id']);
     return data;
   }

  @override
  Widget build(BuildContext context) {
    handleSwitch(bool value) {
      setState(() {
        isSwitch = value;
        dynamicSwitch = value;
      });
    }
    ApiServices().toggleStatus_userById(user_details['data']['id']);
    status=togglemove??false;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    var toggleSwitch;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                  height: screenHeight * 0.23,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/home_logo_new.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                                  if(profile_data!=null){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => EditProfilePage()));}
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.person,
                                isToggle: false,
                              ),
                              Text(
                                'Profile'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctoBossMembershipScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                icon: Icons.monetization_on,
                                screenHeight: screenHeight,
                                isToggle: false,
                              ),
                              Text(
                                'Membership'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctobossSettingsScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.settings,
                                isToggle: false,
                              ),
                              Text(
                                'Settings'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    //
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctobossIssuesListScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.format_list_bulleted_outlined,
                                isToggle: false,
                              ),
                              Text(
                                'Job'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctoBossChatListScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.message,
                                isToggle: false,
                              ),
                              Text(
                                'Chats'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                // ServicesOfferedScreen
                                builder: (ctx) => ServicesOfferedScreen()));
                          },
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: screenHeight * 0.12,
                                width: screenHeight * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffff6e01),
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
                                child: SvgPicture.asset(
                                  'assets/svg/business_service.svg',
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Services Offered'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctobossReportsScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.signal_cellular_alt,
                                isToggle: false,
                              ),
                              Text(
                                'Report'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => IssuesMarket()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.search,
                                isToggle: false,
                              ),
                              Text(
                                'Issues'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: screenHeight * 0.12,
                              width: screenHeight * 0.12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffff6e01),
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
                              child:FlutterSwitch(
                                      width: 105.0,
                                      height: 35.0,
                                      valueFontSize: 15.0,
                                      toggleSize: 45.0,
                                      value: status,

                                      inactiveColor: Colors.grey.withOpacity(0.5),
                                      activeColor: Color(0xffff6e01),
                                      // borderRadius: 30.0,
                                      padding: 8.0,
                                      showOnOff: true,
                                      disabled: toggle_Disable,
                                      onToggle: (val) async {
                                        setState(() {
                                          toggle_Disable=true;
                                        });
                                        Fluttertoast.showToast(msg: 'Status Updating...\nPlease Wait',);

                                        var profile_da=await ApiServices().user_by_id(user_details['data']['id']);
                                        var member=await ApiServices().Membership_by_id(user_details['data']['id']);
                                        setState(() {
                                          profile_da;
                                          member;
                                        });

                                        if(profile_da['first_name']!=''
                                            && profile_da['last_name']!=''
                                            && profile_da['date_of_birth']!=''
                                            && profile_da['email']!=''
                                            && profile_da['address']!=''
                                            && profile_da['city']!=''
                                            && profile_da['street_name']!=''
                                            && profile_da['street_address']!=''
                                            && profile_da['street_no']!=''
                                            && profile_da['unit_number']!=''
                                            && profile_da['phone']!=''
                                            && profile_da['job_title']!=''
                                            && profile_da['job_info']!=''
                                            // && profile_da['tag_of_services']!=''
                                            && profile_da['detail_description']!=''
                                            && profile_da['country']!=''
                                            && profile_da['postal_code']!=''
                                            && profile_da['language']!=''
                                            && profile_da['category']!=''
                                        ){
                                          if(member!=null){
                                            await ApiServices().makeOnline(user_details['data']['id'], val==true?'online':'offline');

                                            setState(() {
                                              status = val;
                                              toggle_Disable=false;
                                            });
                                          }
                                          else{
                                            Fluttertoast.showToast(msg: 'Kindly, atleast one Membership Plan');
                                            setState(() {
                                              toggle_Disable=false;
                                            });

                                          }
                                        }
                                        else{
                                          Fluttertoast.showToast(msg: 'Complete Your Profile');
                                          setState(() {
                                            toggle_Disable=false;
                                          });
                                        }
                                      }
                                    ),
                            ),
                            Text(
                              'Status'.tr,
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OctobossBoostScreen()));
                          },
                          child: Column(
                            children: [
                              OctobossHomeWidget(
                                screenHeight: screenHeight,
                                icon: Icons.bookmarks_outlined,
                                isToggle: false,
                              ),
                              Text(
                                'Boost'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class OctobossHomeWidget extends StatefulWidget {
  OctobossHomeWidget({
    Key? key,
    required this.screenHeight,
    // required this.txt,
    required this.icon,
    required this.isToggle,
  }) : super(key: key);

  final double screenHeight;

  // String txt;
  IconData icon;
  bool isToggle = false;

  @override
  State<OctobossHomeWidget> createState() => _OctobossHomeWidgetState();
}

class _OctobossHomeWidgetState extends State<OctobossHomeWidget> {
  var _val = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.screenHeight * 0.12,
      width: widget.screenHeight * 0.12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffff6e01),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: !widget.isToggle
          ? Icon(
              widget.icon,
              color: Colors.white,
              size: widget.screenHeight * 0.05,
            )
          : Switch(
              value: _val,
              onChanged: (value) {
                _val = value;
              },
            ),
    );
  }
}
