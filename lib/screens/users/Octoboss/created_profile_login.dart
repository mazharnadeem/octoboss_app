import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_profile_scrn.dart';

class ProfileORLogin extends StatefulWidget {
  ProfileORLogin({Key? key}) : super(key: key);

  @override
  State<ProfileORLogin> createState() => _ProfileORLoginState();
}

class _ProfileORLoginState extends State<ProfileORLogin> {

  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      profile_data = data1['data'];
      print ('Get User by Id : 201 :$profile_data');
      setState(() {
        profile_data;});

      return profile_data;

    } else {
      print ('Get User by Id : 200');
      return false;
    }
  }

  @override
  void initState() {

    get_user_by_id(user_details['data']['id']);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 80),
          child: Column(
            children: [
              Container(
                height: 150,
                width: 150,
                child: Image.asset('assets/images/BigLogo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Text('Complete Your Profile',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 80,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          if(profile_data!=null){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()));
                          }
                          else{
                            setState(() {

                            });
                          }

                        },
                        child: Text(
                          'Complete Now',
                          style: TextStyle(
                            fontSize: 17,
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
                                side: BorderSide(color: Colors.red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          checkProfile=false;
                          setState(() {
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OctoBossBottomNavBar()));
                        },
                        child: Text(
                          'Do it Later',
                          style: TextStyle(
                            fontSize: 17,
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
                                side: BorderSide(color: Colors.red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
