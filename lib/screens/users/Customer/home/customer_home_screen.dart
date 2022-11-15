import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/ServicesResponse.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/home/reviewscreen.dart';
import 'package:octbs_ui/screens/users/Customer/services_octoboss.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_services_offered_screen_api.dart';
import 'package:octbs_ui/screens/users/Octoboss/settings_screen.dart';


var customerAnnounce;
class banner {
  int? response;
  int? code;
  List<Data>? data;

  banner({this.response, this.code, this.data});

  banner.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? title;
  String? description;
  String? path;
  String? meta;

  Data(
      {this.id,
      this.image,
      this.title,
      this.description,
      this.path,
      this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    path = json['path'];
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['path'] = this.path;
    data['meta'] = this.meta;
    return data;
  }
}

class CustomerHomeScreen extends StatefulWidget {
  CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  Future<banner> getPostApi() async {
    final response = await http
        .get(Uri.parse("https://admin.octo-boss.com/API/Banners.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return banner.fromJson(data);
    } else {
      return banner.fromJson(data);
    }
  }


  Future<SettingsModel> getTermsandCondition() async {
    final response = await http.get(Uri.parse("https://admin.octo-boss.com/API/Settings.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      customerAnnounce=data;
      if(customerAnnounce['data']['user_notification_show'].toString()=='1'){
      await checkdialog();
      }
      return SettingsModel.fromJson(data);
    } else {
      return SettingsModel.fromJson(data);
    }
  }

  Future<ServicesResponse> getPostServiceApi() async {
    final response = await http
        .get(Uri.parse("https://admin.octo-boss.com/API/Services.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return ServicesResponse.fromJson(data);
    } else {
      return ServicesResponse.fromJson(data);
    }
  }

  String? announcment;
  int count = 0;
  Future<ServicesResponse>? serviceApi;
  Future<banner>? futurebanner;

  checkdialog(){
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Announcement'.tr,style: TextStyle(color: Colors.deepOrange)),
                SizedBox(height: 20,),
              Text(
                '${customerAnnounce['data']['user_notification'].toString()}',
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
  offerTimedialog(){
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Offer Time'.tr,style: TextStyle(color: Colors.deepOrange)),
                SizedBox(height: 20,),
                Container(
                  height: 168,
                  width: 200,
                  child: ListView.builder(
                    itemCount: timeAnnoucement.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(children: [
                                Text(
                                  'Date',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Time',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],),
                            SizedBox(width: 30,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                                '${timeAnnoucement[index]['date'].toString()}',
                                style: TextStyle(fontSize: 15),
                              ),
                                SizedBox(height: 10,),
                              Text(
                                '${timeAnnoucement[index]['time'].toString()}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],)
                          ],),
                          SizedBox(height: 20,),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 184,

                              child: Text(
                                'Kindly, Check your offer, Time of offer remain less than a day',
                                style: TextStyle(fontSize: 15,),textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 200,
                            child: ListView.builder(
                              itemCount: timeAnnoucement.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(CupertinoIcons.circle_fill,size:10,color: Colors.deepOrange,),
                              );
                            },),
                          )
                        ],
                      );

                  },),
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
    super.initState();
    futurebanner = getPostApi();
    approvedOfferList(user_details['data']['id']);
    if(customerAnnounce==null){
      che();
    }
  }


  approvedOfferList(String receiverId,{var onlyforOffer}) async{
    try{
      var data={'receiver_id':receiverId};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetApprovedOffers.php'),
          body: data1
      );
      if(response.statusCode==201){

        print('Get Approved Offer : 201');
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
        return false;
      }
      else{
        print('Get Approved Offer  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  offerTimeAnnoucement(String receiverId,{var onlyforOffer}) async{
    try{
      var data={'user_id':receiverId};

      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetApprovedOfferByUser.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Get Approved Offer by Id : 201');
        var data2=jsonDecode(response.body.toString());
        var timeAnnoucement_data=data2['data'];
        if(timeAnnoucement_data!=[]){
          timeAnnoucement=data2['data'];
        }
        else{
          timeAnnoucement=null;
        }
        return true;
      }
      else if(response.statusCode==200){
        print('Get Approved Offer by Id : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Get Approved Offer by Id : else');
        var data2=jsonDecode(response.body.toString());
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
        }
        else{
          review_details=chatId;
          Get.to(ReviewScreen());
        }
        return true;
      }
      else if(response.statusCode==200){
        print('Offer Time : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Offer Time : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  Future settingsApi() async {
    setState(() {});
    if (announcment != null && count == 0) {
      count++;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Announcement',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      announcment!,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'close',
                          style: TextStyle(
                            color: Color(0xffff6e01),
                          ),
                        ))
                  ],
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    tab_controller.addListener(() {

      if(tab_controller.index==0){
        futurebanner = getPostApi();
        approvedOfferList(user_details['data']['id']);
        offerTimeAnnoucement(user_details['data']['id']);
        if(customerAnnounce==null){
          che();
        }
        if(timeAnnoucement!=null){
          if(timeAnnoucement['data']!=[]){
            offerTimedialog();
          }
        }
      }
    });
    tab_controller.notifyListeners();
    tab_controller.removeListener(() { });
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset('assets/images/home_logo_new.jpg'),
          ),
          Expanded(
              child: FutureBuilder<banner>(
                  future: futurebanner,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.data!.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data.data[index].image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: MediaQuery.of(context).size.width,
                                height: screenHeight * 0.27,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Image.network(
                                      "http://via.placeholder.com/350x150"),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          Expanded(
              child: FutureBuilder<ServicesResponse>(
                  future: getPostServiceApi(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, right: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Card(
                                        child: Container(
                                          height: 65,
                                          width: 50,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(

                                          ),
                                          child: Wrap(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ServicesOctoboss(),arguments: [snapshot.data!.data![index].productName]);
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data!
                                                      .data![index].productImage
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    height: 60,
                                                    width: 70,
                                                    child: Image.network(
                                                        "http://via.placeholder.com/350x150"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Text(snapshot
                                                .data!.data![index].productName
                                                .toString()),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
        ]),
      ),
    );
  }
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 350, left: 16, right: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Octoboss',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Consider giving us a review!',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: TextFormField(
                              onChanged: (value) {
                                //Do something with the user input.
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your Comment(Optional)',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Not now',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Lets do it!',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              )
                            ],
                          )
                        ]),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
