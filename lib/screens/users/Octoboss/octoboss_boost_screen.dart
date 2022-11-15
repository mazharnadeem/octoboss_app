import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/boost_payment.dart';
import 'package:octbs_ui/controller/payment_controller.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/Golden_plan.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/Silver_plan.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/plantinum_plan.dart';
import 'package:http/http.dart' as http;

class OctobossBoostScreen extends StatefulWidget {
  OctobossBoostScreen({Key? key}) : super(key: key);


  @override
  State<OctobossBoostScreen> createState() => _OctobossBoostScreenState();
}

class _OctobossBoostScreenState extends State<OctobossBoostScreen> {

  getBoostPlan() async {
    final response = await http.get(Uri.parse('https://admin.octo-boss.com/API/BoostPlans.php'));
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());
      boostPlans=data['data'];
    } else {
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.04,
              left: screenHeight * 0.01,
              right: screenHeight * 0.01,
            ),
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
                    //
                    // Spacer(),
                    SizedBox(width: screenWidth * 0.1),
                    Text(
                      'Boost'.tr,
                      style: TextStyle(
                        fontSize: fontSize * 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.3),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: fontSize * 16,
                      ),
                    )
                    // Spacer(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.1,
                      screenWidth * 0.0,
                      screenWidth * 0.1,
                      screenWidth * 0),
                  child: Image.asset('assets/icons/logo.png'),
                ),
                Text(
                  'OctoBoss',
                  style: TextStyle(
                    fontSize: fontSize * 20,
                    color: Color(0xff2F302B),
                  ),
                ),

                   Wrap(
                    children: [
                      Container(
                        width: Get.size.width,
                        height: Get.size.height*0.7,
                        child: FutureBuilder(
                          future: getBoostPlan(),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator());
                            }
                            else{
                              return ListView.builder(
                                itemCount: boostPlans.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      var idd=int.parse(boostPlans[index]['id'].toString());
                                      BoostPayment().makePayment(amount: boostPlans[index]['price'].toString(), currency: 'CAD',id: idd);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(22)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    '${boostPlans[index]['boost_name']}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  Text(
                                                    '${boostPlans[index]['description']}',
                                                    style: TextStyle(fontSize: 16,),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '${boostPlans[index]['duration']} days',
                                                    style: TextStyle(fontSize: 16,),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '${boostPlans[index]['price']} CAD',
                                                    style: TextStyle(fontSize: 16,),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },);
                            }

                          },),
                      )
                    ],
                  ),


                SizedBox(height: 35),
              ],
            )),
      ),
    );
  }
}
