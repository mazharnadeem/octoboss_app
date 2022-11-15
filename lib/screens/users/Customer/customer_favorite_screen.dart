import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:octbs_ui/Model/filteroctoboss.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' ;
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_chatlist_screen.dart';

class CustomerFavoriteScreen extends StatefulWidget {


  @override
  State<CustomerFavoriteScreen> createState() => _CustomerFavoriteScreenState();
}

var favorite_data=[];
class _CustomerFavoriteScreenState extends State<CustomerFavoriteScreen> {
  var fav_list=[];
  var userdata_byid;


  getProducts() async{
    var data={'type':'octoboss'};

    var data1=json.encode(data);

    final response=await post(Uri.parse('https://admin.octo-boss.com/API/FilterOctoboss.php'),body: data1);

    if(response.statusCode==201){
      var data2=jsonDecode(response.body.toString());
      favorite_data.clear();
      var len=data2['data'].length;
        for(int i=0;len>i;i++) {
              var val=fav_list.contains(data2['data'][i]['id']);
              if(val){
                favorite_data.add(data2['data'][i]);
              }
          }
       setState(() {
          fav_list;
          favorite_data;});
    }
    else{}
  }

  steamget(){
    favorite_list();
    getProducts();
    setState(() {
    });
  }

favorite_list() async{

  var data={'user_id':user_details['data']['id']};

  var data1=json.encode(data);
  var response=await post(Uri.parse('https://admin.octo-boss.com/API/FavouriteOctobossList.php'),
      body: data1
  );
  if(response.statusCode==201){

    fav_list.clear();

    var data2=jsonDecode(response.body.toString());
    var fav=data2['data'];
    var len=fav.length;
    for(int i=0;i<len;i++){
      fav_list.add(fav[i]['octoboss_id']);
    }
  }
  else{
    fav_list.clear();
    var data2=jsonDecode(response.body.toString());
  }

}
  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      userdata_byid = data1['data'];
      print ('Get User by Id : 201');
      setState(() {
        userdata_byid;
      });
    } else {
      print ('Get User by Id : 200');
    }
  }


  makeFavorite(String id) async {
    var favorite_data = {
      'user_id': user_details['data']['id'],
      'octoboss_id': id,
    };
    var encoded_data = json.encode(favorite_data);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/FavouriteOctoboss.php'),
        body: encoded_data);

    if (response.statusCode == 201) {
      var favorite_res = jsonDecode(response.body.toString());
      setState(() {});
    } else {
      var issue_response = jsonDecode(response.body.toString());
    }
  }

@override
  void initState() {
  favorite_list();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Text(
                        'Favorites'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream: steamget(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if(snapshot.connectionState==ConnectionState.waiting)
                      {
                        return CircularProgressIndicator();
                      }

                    else{
                      return ListView.builder(
                          itemCount: favorite_data.length,
                          itemBuilder: (context, index) {
                            var last=favorite_data[index]['last_seen'];
                            var lastseen=last.toString().split(' ').last.split(':');
                            var lastseen_hour=int.parse(lastseen[0]);
                            var lastseen_minutes=int.parse(lastseen[1]);
                            return Card(

                              elevation: 5,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.blue,
                                            backgroundImage: NetworkImage(
                                                favorite_data[index]['image'].toString()
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(favorite_data[index]['name'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Text(favorite_data[index]['service'].toString(), style: TextStyle()),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 25,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(22),
                                                    border: Border.all(color: Colors.orange)),
                                                child: Text(' ${lastseen_hour>=12?lastseen_hour-12:lastseen_hour} : ${lastseen_minutes} ${lastseen_hour>=12?'PM':'AM'} '),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.message,
                                                color: Colors.orange.shade800,
                                              ),
                                              Text('${favorite_data[index]['chats']} Chats', style: TextStyle(fontSize: 15)),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xffff6e01),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(50))),

                                              onPressed: () async {
                                                await get_user_by_id(favorite_data[index]['id']);
                                               setState(() {
                                                 userdata_byid;
                                               });

                                                var online=int.parse(userdata_byid['is_online']??'2');

                                                if(online==1){
                                                  print('Profile = 1');
                                                  get_receiverId=int.parse(favorite_data[index]['id'].toString());
                                                  get_octobossName=userdata_byid;
                                                  setState(() {
                                                    get_receiverId;
                                                    get_octobossName;
                                                  });
                                                  Get.to(CustomerChatListScreen());
                                                }
                                                if(online==0){
                                                  Fluttertoast.showToast(msg: 'User is currently Unavailable');
                                                  print('Profile = 0');

                                                }
                                                else{
                                                  print('Profile = Else');
                                                }

                                              },

                                              child: Text('Chat with me'.tr))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              makeFavorite(favorite_data[index]['id']);
                                              favorite_list();
                                              setState(() {});
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.orange.shade800,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 80,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );

                          }
                      );
                    }

                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
