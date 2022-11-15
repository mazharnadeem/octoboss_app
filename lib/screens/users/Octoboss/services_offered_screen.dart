import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:octbs_ui/Model/servicesModel.dart';
import 'package:octbs_ui/controller/ServicesResponse.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/services_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ServicesOfferedScreen extends StatefulWidget {
  const ServicesOfferedScreen({Key? key}) : super(key: key);

  @override
  _ServicesOfferedScreenState createState() => _ServicesOfferedScreenState();
}

class _ServicesOfferedScreenState extends State<ServicesOfferedScreen> {
  List selectedServices = [];
  String? selectedSpinnerItem;

  List date = [];
  Future? myFuture;
  final String uri = 'https://admin.octo-boss.com/API/Services.php';
  Future<ServicesResponse> getPostServiceApi() async {
    final response = await http.get(Uri.parse(uri));
    var data = jsonDecode(response.body.toString());

    setState(() {
      date = data['data'];
      var xx = {'product_name': 'Others'};
      date.add(xx);
    });

    if (response.statusCode == 201) {
      return ServicesResponse.fromJson(date);
    } else {
      return ServicesResponse.fromJson(date);
    }
  }

  var store_services = [];
  var users_data_by_id;
  var serviceslist;

  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      users_data_by_id = data1['data'];
      var x=users_data_by_id['category'];
      serviceslist = x.toString().split(',');
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              Expanded(
                flex: 8,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return FutureBuilder(
                      future: get_user_by_id(user_details['data']['id']),
                      builder: (context, AsyncSnapshot snapshot) {
                        if(serviceslist!=null) {
                          return ListView.builder(
                            itemCount: serviceslist.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: SizedBox(
                                      height: screenHeight * 0.08,
                                      width: double.infinity,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: Text(
                                                  serviceslist[index],
                                                  style: TextStyle(
                                                      fontSize: fontSize * 20,
                                                      color: Color(0xffff6e01)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(onPressed: () {
                                                var addService=users_data_by_id['category'].toString().split(',');
                                                addService.remove(serviceslist[index]);
                                                ApiServices().AddOctobossPictureandData(
                                                  fname: user_details['data']['first_name'].toString(),
                                                  lname: user_details['data']['last_name'].toString(),
                                                  dob: user_details['data']['date_of_birth'].toString(),
                                                  fullAddress: user_details['data']['address'].toString(),
                                                  email: user_details['data']['email'].toString(),
                                                  streetname: user_details['data']['street_name'].toString(),
                                                  streetAddress: user_details['data']['street_address'].toString(),
                                                  unitNumber: user_details['data']['unit_number'].toString(),
                                                  city: user_details['data']['city'].toString(),
                                                  phoneNumber: user_details['data']['phone'].toString(),
                                                  jobInfo: user_details['data']['job_info'].toString(),
                                                  tagsServices: user_details['data']['tag_of_services'].toString(),
                                                  // tagsServices: '',
                                                  jobTitle: user_details['data']['job_title'].toString(),
                                                  detailedDescription: user_details['data']['detail_description'].toString(),
                                                  country: user_details['data']['country'].toString(),
                                                  postalCode: user_details['data']['postal_code'].toString(),
                                                  category: addService.join(','),
                                                  language: user_details['data']['language'].toString(),
                                                  streetnumber:user_details['data']['street_no'].toString(),
                                                  // image: File(user_details['data']['picture'].toString()).path,
                                                  // certficate: user_details['data']['street_no'],
                                                  // work_picture: user_details['data']['street_no'],
                                                );
                                                get_user_by_id(user_details['data']['id']);
                                                setState(() {
                                                  serviceslist;
                                                });
                                                setState(() {
                                                  serviceslist;
                                                });

                                              }, icon: Icon(Icons.cancel_sharp,size: 30,color: Color(0xffff6e01),)),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                );
                            },
                          );
                        }
                        else{
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    PersistentBottomNavBar();
                     await showbottomsheet();
                     setState(() {});
                  },
                  child: Card(
                    child: Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                        Spacer(),
                        Text(
                          "Choose Services".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   showbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamBuilder(
            builder: (context, snapshot) {
            return Wrap(
              children: [
                Center(
                    child: FutureBuilder(
                        future: getPostServiceApi(),
                        builder: (context, snapshot) {
                          return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      items: date.map((item) {
                                        return DropdownMenuItem(
                                          child: Text(item['product_name']),
                                          value: item['product_name'],
                                        );
                                      }).toList(),
                                      enableFeedback: true,
                                      hint: Text(
                                        "Choose Services".tr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (newVal) {
                                        var addService1=users_data_by_id['category'].toString().trim();
                                        var addService=addService1.split(',');
                                        if(addService[0]==''){
                                          addService.remove('');
                                        }
                                        addService.add(newVal.toString().trim());
                                        addService=addService.toSet().toList();

                                        if(newVal.toString()!='Others'){
                                        ApiServices().AddOctobossPictureandData(
                                          fname: user_details['data']['first_name'].toString(),
                                          lname: user_details['data']['last_name'].toString(),
                                          dob: user_details['data']['date_of_birth'].toString(),
                                          fullAddress: user_details['data']['address'].toString(),
                                          email: user_details['data']['email'].toString(),
                                          streetname: user_details['data']['street_name'].toString(),
                                          streetAddress: user_details['data']['street_address'].toString(),
                                          unitNumber: user_details['data']['unit_number'].toString(),
                                          city: user_details['data']['city'].toString(),
                                          phoneNumber: user_details['data']['phone'].toString(),
                                          jobInfo: user_details['data']['job_info'].toString(),
                                          tagsServices: user_details['data']['tag_of_services'].toString(),
                                          // tagsServices: '',
                                          jobTitle: user_details['data']['job_title'].toString(),
                                          detailedDescription: user_details['data']['detail_description'].toString(),
                                          country: user_details['data']['country'].toString(),
                                          postalCode: user_details['data']['postal_code'].toString(),
                                          category: addService.join(','),
                                          language: user_details['data']['language'].toString(),
                                          streetnumber:user_details['data']['street_no'].toString(),
                                          // image: File(user_details['data']['picture'].toString()).path,
                                          // certficate: user_details['data']['street_no'],
                                          // work_picture: user_details['data']['street_no'],
                                        );
                                        }
                                        setState(() {
                                          setState(() {
                                            selectedSpinnerItem = newVal.toString();
                                            Navigator.pop(context);
                                          });
                                          if (selectedSpinnerItem == 'Others') {
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                context: context,
                                                builder: ((context) =>
                                                    SingleChildScrollView(
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                            MediaQuery.of(context)
                                                                .viewInsets
                                                                .bottom),
                                                        child: NameBottomSheet(),
                                                      ),
                                                    )));
                                          }
                                        });
                                      },
                                      value: selectedSpinnerItem,
                                    ),
                                  ]));
                        }))
              ],
            );
          },);
        });
  }
}

class ServiceWidget extends StatelessWidget {
  ServiceWidget({Key? key, required this.txt}) : super(key: key);

  String txt;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: Alignment.center,
        height: screenHeight * 0.18,
        width: screenHeight * 0.18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: FittedBox(
            child: Text(
          txt,
          style: TextStyle(),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
