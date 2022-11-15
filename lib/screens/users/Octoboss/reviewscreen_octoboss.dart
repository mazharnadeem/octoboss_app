import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/home/customer_home_screen.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:http/http.dart' as http;

class ReviewScreenOctoboss extends StatefulWidget {
  const ReviewScreenOctoboss({Key? key}) : super(key: key);

  @override
  State<ReviewScreenOctoboss> createState() => _ReviewScreenOctobossState();
}

class _ReviewScreenOctobossState extends State<ReviewScreenOctoboss> {

  var offerdata;
  var commentController=TextEditingController();
  var rating;
  var ww=Get.put(CustomerNavBar());
  updateIssueStatus(var issueId ,var status) async{
    try{

      var data={'id':issueId,'user_id':user_details['data']['id'],'status':status};
      var data1=json.encode(data);

      var response=await post(Uri.parse('https://admin.octo-boss.com/API/UpdateIssueStatus.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Issue Successfully Updated : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Issue Updated Failed: 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Issue Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  addReview(var customerId,var rating,var review) async{
    try{
      var data={
        'member_id':user_details['data']['id'],
        'user_id':customerId,
        'rating':rating,
        'review':review
      };

      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/AddReview.php'),
          body: data1
      );
      if(response.statusCode==201){

        var data2=jsonDecode(response.body.toString());
        deleteoffer(offer_data['id']);
        tab_controller.jumpToTab(0);
        tab_controller.notifyListeners();
        Get.back();
        setState(() { });

        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  offerList(String receiverId,var chatId) async{
    try{
      var data={'receiver_id':receiverId};

      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ChatList.php'),
          body: data1
      );
      if(response.statusCode==201){
        var data2=jsonDecode(response.body.toString());
        var offer1=data2['data'];
        for(int m=0;offer1.length>m;m++){
          if(m<offer1.length){
            if(offer1[m]['id']==chatId)
            {
              offerdata=offer1[m];
            }


          }
        }
        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      return false;
    }

  }
  updateChatStatus(var offerId ,var status) async{
    try{

      var data={'chat_id':offerId,'status':status};
      var data1=json.encode(data);


      var response=await post(Uri.parse('https://admin.octo-boss.com/API/UpdateChatStatus.php'),
          body: data1
      );
      if(response.statusCode==201){
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      return false;
    }

  }

  deleteoffer(var offerId) async{
    try{
      var data={'offer_id':offerId};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/DeleteOfferById.php'),
          body: data1
      );
      if(response.statusCode==201){
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      return false;
    }

  }
  octobossJobDone(var senderId ,var receiverId, var issueId, var location, var description, var problem, var languages, var price, var time, var date, var duration, var rating ,var image) async{
    try{
      var data={
        'sender_id':senderId,
        'reciever_id':receiverId,
        'issue_id':issueId,
        'location':location,
        'description':description,
        'problem':problem.toString(),
        'languages':languages,
        'price':price,
        'time':time,
        'date':date,
        'rating':rating,
        'duration':duration
      };
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/AddJobsDone.php'),
          body: data
      );
      if(response.statusCode==201){
        return true;
      }
      if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
      }

    }catch(e){
      return false;
    }

  }


  updateApprovedOffers(var status ,var chatId,var receiverr,{var time,var date}) async{
    try{
      var data={
        'sender_id':user_details['data']['id'],
        'receiver_id':receiverr,
        'approved':status,
        'offer_id':chatId,
        'date':date,
        'time':time

      };
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ApprovedOffers.php'),
          body: data1
      );
      if(response.statusCode==201){
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Material(
          child: Container(
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
                    'Customer',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Consider giving us a review!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 16),
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
                            onRatingUpdate: (rating1) {
                              rating=rating1;
                              print('Rating : $rating : ${rating.runtimeType}');
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
                      controller: commentController,
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
                          // Navigator.pop(context);
                        },
                        child: Text(
                          '',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: ()  {
                          var rec=offerdata['sender_id'];
                          addReview(rec, rating, commentController.text);
                        },
                        child: Text(
                          'Make Reveiw',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  SizedBox(height: 16),
                  FutureBuilder(
                    future: offerList(user_details['data']['id'], review_details),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Card(
                              elevation: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Offer Completed',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                      ],
                                    ),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('TIME'),
                                          Container(width: Get.size.width*0.8,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: offerdata['time'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('DATE'),
                                          Container(width: Get.size.width*0.8,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: offerdata['dates'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ISSUE PROBLEM'),
                                          Container(width: Get.size.width*0.8,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: offerdata['problem'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: Get.size.height*0.01,),
                                          Text('ISSUE DESCRIPTION'),
                                          Container(width: Get.size.width*0.8,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: offerdata['description'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: Get.size.height*0.01,),
                                          Text('ISSUE LOCATION'),
                                          Container(width: Get.size.width*0.8,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: offerdata['location'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('PRICE'),
                                              Container(width: Get.size.width*0.35,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${offerdata['price']} \$',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: Get.size.width*0.1,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('DURATION'),
                                              Container(width: Get.size.width*0.35,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${offerdata['duration']} hrs',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    SizedBox(height: Get.size.height*0.02,),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        );
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkVisibilty_review(){
    if(offerdata==null || offerdata==[]){
      return false;
    }
    else{
      return true;
    }
  }
}
