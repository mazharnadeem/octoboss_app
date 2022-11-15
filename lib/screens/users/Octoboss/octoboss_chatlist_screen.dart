import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/customer_chatlist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:octbs_ui/screens/users/Octoboss/octoboss_chat_screen.dart';

class OctoBossChatListScreen extends StatefulWidget {
  const OctoBossChatListScreen({ Key? key }) : super(key: key);

  @override
  _OctoBossChatListScreenState createState() => _OctoBossChatListScreenState();
}

class _OctoBossChatListScreenState extends State<OctoBossChatListScreen> {
  var users_octoboss=[];
  var chat_customer;

  //for search field
  var searching=0;
  var list_of_octoboss=[];
  var sorted_octoboss=[];
  var dummy_octoboss=[];
  var chat_octoboss;
  var messageSearchController=TextEditingController();
  var search=false;

  Future<void> get_all_Octoboss() async{
    final response = await http.get(Uri.parse("https://admin.octo-boss.com/API/Customers.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      users_octoboss=data['data']['all_customers'];
    }
    else {
    }
  }
  get_customer() async {
    var data = {'user_id': user_details['data']['id'],'type':'octoboss'};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUsersFilter.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      chat_customer=data1['data'];
    } else {
      print ('Get Chat Octoboss by Id : 200');
      return false;
    }
  }
  get_customerChatUser() async {
    var data = {'user_id': user_details['data']['id'],'type':'octoboss'};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUsersFilter.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      chat_octoboss=data1['data'];

      if(searching==0){
        sorted_octoboss=chat_octoboss;
      }
      if(searching==1){
        sorted_octoboss=dummy_octoboss;
      }

    } else {
      print ('Get Chat Octoboss by Id : 200');
      return false;
    }
  }
  get_UnReadById(var rec,var sen) async {
    var data = {'sender_id': sen,'receiver_id':rec};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUnreadMsgs.php"),
        body: data2);
    if (response.statusCode == 201) {
      print ('Message Count by Id : 201');
      var data1 = jsonDecode(response.body.toString());
      return data1['count'];
    } else {
      print ('Message Count by Id : 200');
      return false;
    }
  }
  readData(var recId,SenId) async {
    var x=await get_UnReadById(recId,SenId);
    return x;
  }
  recentMessage(String receiverId) async{
    try{
      var data={'receiver_id':receiverId};

      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ChatList.php'),
          body: data1
      );
      if(response.statusCode==201){

        print('Message List Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return data2['last_message']['message'];
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        print(data);
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 40,),

              SizedBox(
                height: 60,
                child: Card(
                  elevation: 5,
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Visibility(
                          visible: !search,
                          child: Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () {
                                  search=true;
                                  setState(() {
                                    search;
                                  });

                                },icon: Icon(Icons.search),
                              )),
                        ),
                        Visibility(
                          visible: search,
                          child: Expanded(
                              flex: 4,
                              child: IconButton(
                                onPressed: () {
                                  search=false;
                                  sorted_octoboss=chat_octoboss;
                                  setState(() {
                                    searching=0;
                                    search;
                                  });
                                },icon: Icon(Icons.close),
                              )),
                        ),
                        Visibility(
                          visible: !search,
                          child: Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Messages".tr, style: TextStyle(color: Colors.black),))),
                        ),
                        Visibility(
                          visible: search,
                          child: Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: TextField(
                                    onChanged: (value) {

                                      sorted_octoboss =chat_octoboss.where(
                                            (u) => (u['full_name'].toString().toLowerCase().contains(
                                          value.toLowerCase(),
                                        )),
                                      ).toList();
                                      dummy_octoboss=sorted_octoboss;
                                      setState(() {
                                        searching=1;
                                      });
                                      setState(() {});
                                      //Do something with the user input.
                                    },
                                    controller: messageSearchController,
                                    autocorrect: true,

                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'Search Name...',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                      ),
                                    ),
                                  )
                              )),
                        ),

                      ],),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              FutureBuilder(
                future: get_customerChatUser(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(
                      height: Get.height*0.7,
                        width: Get.width*1,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if(snapshot.connectionState==ConnectionState.none){
                    return Text('active');
                  }
                  else{
                    try{
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sorted_octoboss.length,
                        itemBuilder: (context, index) {

                          return  Card(
                            child:  ListTile(
                                onTap: () {
                                  var ss=int.parse(sorted_octoboss[index]['sender_id']);
                                  var rr=int.parse(sorted_octoboss[index]['receiver_id']);
                                  var uu=int.parse(user_details['data']['id']);
                                  get_receiverId=(rr==uu)?ss:rr;
                                  get_octobossName=sorted_octoboss[index];
                                  Get.to(OctobossChatScreen());
                                },
                                leading:  (sorted_octoboss[index]['picture']==null || sorted_octoboss[index]['picture']=="")?
                                CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/home_logo_new.jpg"),

                                  radius: 30,
                                  backgroundColor: Colors.white,
                                ):
                                CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage:
                                  NetworkImage(sorted_octoboss[index]['picture']),
                                ),
                                title: Text(sorted_octoboss[index]['full_name'], style: TextStyle(color: Colors.deepOrange),),
                              subtitle: FutureBuilder(
                                future: recentMessage(sorted_octoboss[index]['receiver_id']),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return Text('');
                                  }
                                  else{
                                    return Text('${snapshot.data==false?'':snapshot.data}',maxLines: 2,overflow: TextOverflow.ellipsis,);
                                  }
                                },),
                              trailing: Visibility(
                                visible: true,
                                child: FutureBuilder(
                                  future: readData(user_details['data']['id'],sorted_octoboss[index]['receiver_id']),
                                  builder: (context, snapshot) {
                                    if(snapshot.connectionState==ConnectionState.waiting){
                                      return Text('');
                                    }
                                    else{
                                      return Visibility(
                                        visible: snapshot.data!=false,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(80), color: Colors.deepOrange),
                                          child: Center(
                                            child: Container(
                                              child: Text('${snapshot.data==false?'':snapshot.data}'),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },),
                              ),
                            ),
                          );
                        },);

                    }catch(e){
                      return Text('');
                    }
                  }
                },),
            ],),
        ),
      ),
    );

  }
}