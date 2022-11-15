import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/payment_controller.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/Golden_plan.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/Silver_plan.dart';
import 'package:octbs_ui/screens/users/Octoboss/payments/plantinum_plan.dart';

class OctoBossMembershipScreen extends StatefulWidget {
  const OctoBossMembershipScreen({Key? key}) : super(key: key);

  @override
  _OctoBossMembershipScreenState createState() =>
      _OctoBossMembershipScreenState();
}

class _OctoBossMembershipScreenState extends State<OctoBossMembershipScreen> {
  Future<membershipModel> getMembership() async {
    final response = await http
        .get(Uri.parse('https://admin.octo-boss.com/API/MemberShipPlans.php'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return membershipModel.fromJson(data);
    } else {
      return membershipModel.fromJson(data);
    }
  }
  checkMembership_by_id(var id) async {

    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserPlanById.php"),
        body: data2);
    var data1 = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      membershipId=data1['data'];
      return true;
    } else {
      if(data1['message']=='No record found!'){
        membershipId=null;
      }
      return false;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      'Membership'.tr,
                      style: TextStyle(
                        fontSize: fontSize * 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    FutureBuilder(
                      future: checkMembership_by_id(user_details['data']['id']),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                        else{
                          if(membershipId==null){
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepOrange,width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'InActive'.tr,
                                  style: TextStyle(
                                    fontSize: fontSize * 17,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          else{
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepOrange,width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Active'.tr,
                                  style: TextStyle(
                                    fontSize: fontSize * 17,
                                  ),
                                ),
                              ),
                            );
                          }

                        }

                    },)
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Column(
                  children: [
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
                  ],
                ),
                SizedBox(height: 35),
                FutureBuilder(
                  future: checkMembership_by_id(user_details['data']['id']),
                  builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  else{
                    if(membershipId!=null){
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepOrange,width: 3),
                          borderRadius: BorderRadius.circular(20),

                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 3,),
                            Text(
                              'Membership Purchased',
                              style: TextStyle(
                                fontSize: fontSize * 20,
                              ),
                            ),
                            SizedBox(height: 3,),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text('${membershipId['membership_name']}',
                                    style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Description',
                                        style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                      Text('${membershipId['description']}',
                                        style: TextStyle(fontSize: fontSize * 13,color: Colors.white,),
                                        textAlign: TextAlign.center,),
                                    ],),
                                  SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Duration',
                                        style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                      Text('${membershipId['duration']} days',
                                        style: TextStyle(fontSize: fontSize * 13,color: Colors.white,),
                                        textAlign: TextAlign.center,),
                                    ],),
                                  SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Plan Start Date',
                                        style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                      Text('${membershipId['plan_start_date']}',
                                        style: TextStyle(fontSize: fontSize * 13,color: Colors.white,),
                                        textAlign: TextAlign.center,),
                                    ],),
                                  SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Plan expiry Date',
                                        style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                      Text('${membershipId['plan_expiry_date']}',
                                        style: TextStyle(fontSize: fontSize * 13,color: Colors.white,),
                                        textAlign: TextAlign.center,),
                                    ],),
                                  SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('${membershipId['price']} CAD',
                                        style: TextStyle(fontSize: fontSize * 16,color: Colors.white,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                    ],),
                                  SizedBox(height: 3,),

                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else{
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: screenHeight * 0.1,
                            child: Text(
                              'Please purchase membership to become active'.tr,
                              style: TextStyle(
                                fontSize: fontSize * 15,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },),

                FutureBuilder<membershipModel>(
                    future: getMembership(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if(membershipId==null){
                                    var uuId=int.parse(snapshot.data!.data![index].id.toString());
                                    PaymentController().makePayment(amount: snapshot.data!.data![index].price.toString(), currency: 'CAD',id:uuId );
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: 'You already have purchased Membership');
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, bottom: 12),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            snapshot.data!.data![index].price
                                                    .toString() +
                                                "/Month",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(snapshot.data!.data![index].description.toString(),),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            snapshot.data!.data![index].membershipName.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            "Duration: " +
                                                snapshot
                                                    .data!.data![index].duration
                                                    .toString(),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            )),
      ),
    );
  }

  ChoosePlan(String phoneNumber, name, amount, time, plan, email) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Card(
      child: Container(
        height: screenHeight * 0.2,
        width: screenWidth * 0.4,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            plan,
            style: TextStyle(
              fontSize: fontSize * 13,
              color: Color(0xffFF5A01),
            ),
          ),
          Divider(),
          SizedBox(height: 4),
          Text(
            '${amount}CAD /Month',
            style: TextStyle(
              fontSize: fontSize * 13,
              color: Color(0xffFF5A01),
            ),
          ),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: fontSize * 13,
              color: Color(0xffFF5A01),
            ),
          ),
          SizedBox(height: 14),
          InkWell(
            onTap: () {
              Get.to(PayNowScreen(
                description: plan,
                email: email,
                amount: amount,
                name: name,
                phone: phoneNumber,
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffFF5A01),
              ),
              child: Center(
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize * 10,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class PayNowScreen extends StatefulWidget {
  const PayNowScreen({
    required this.description,
    required this.email,
    required this.amount,
    required this.name,
    required this.phone,
    Key? key,
  }) : super(key: key);

  final String name, email, phone, description, amount;

  @override
  _PayNowScreenState createState() => _PayNowScreenState();
}

class _PayNowScreenState extends State<PayNowScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_RjTwt97hkzezfb",
      "amount": num.parse(widget.amount) * 100,
      "name": widget.name,
      "description": widget.description,
      "prefill": {"contact": widget.phone, "email": widget.email},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  void handlerPaymentSuccess() {
    // Fluttertoast.showToast(msg: 'Transfer Successful');
  }

  void handlerErrorFailure() {
    // Fluttertoast.showToast(msg: 'Something went wrong');
  }

  void handlerExternalWallet() {
    // Fluttertoast.showToast(msg: 'External Wallet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xffFF5A01)),
          onPressed: () {
            Get.back();
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}

class membershipModel {
  int? response;
  int? code;
  List<Data>? data;

  membershipModel({this.response, this.code, this.data});

  membershipModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? membershipName;
  String? price;
  String? description;
  String? status;
  String? duration;

  Data(
      {this.id,
      this.membershipName,
      this.price,
      this.description,
      this.status,
      this.duration});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    membershipName = json['membership_name'];
    price = json['price'];
    description = json['description'];
    status = json['status'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['membership_name'] = this.membershipName;
    data['price'] = this.price;
    data['description'] = this.description;
    data['status'] = this.status;
    data['duration'] = this.duration;
    return data;
  }
}
