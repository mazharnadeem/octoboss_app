
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/Model/filteroctoboss.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_chatlist_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class ServicesOctoboss extends StatefulWidget {
  const ServicesOctoboss({Key? key}) : super(key: key);

  @override
  State<ServicesOctoboss> createState() => _ServicesOctobossState();
}

class _ServicesOctobossState extends State<ServicesOctoboss> {


  var ttt=Get.arguments[0];
  var searching=0;
  var list_of_octoboss=[];
  var sorted_octoboss=[];
  var dummy_octoboss=[];
  var searchController=TextEditingController();
   bool active=false;
   var act;
  var jobdone_data;
  var userdata_byid;

  var totalrating=0.0;
  var review;
  var totalreview=0.0;
  var totalReviewRating;
  var totalstars;
  getJobsDone(String receiverId) async{
    try{

      var data={'reciever_id':receiverId};
      totalrating=0.0;
      var rating=0.0;

      //It is used for raw data;
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetJobDone.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Get Job Done : 201');
        var data2=jsonDecode(response.body.toString());
        jobdone_data=data2['data'];
        var len=jobdone_data.length;
        for(int i=0;i<len;i++){
          if(jobdone_data[i]['rating']==""){
            totalrating +=0.0;
          }
          if(jobdone_data[i]['rating']!=""){
            var rating=double.parse(jobdone_data[i]['rating']);
            totalrating +=rating;
          }
        }
        totalrating /=len;
        totalrating=double.parse(totalrating.toStringAsFixed(2));
        return true;
      }
      else if(response.statusCode==200){
        print('Get Job Done : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Get Job Done Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }


  bool checkbool(var value){
     if(value=='Yes'){
       return true;
     }
     else {
       return false;
     }
     
   }

  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      print ('Get User by Id : 201');
      var data1 = jsonDecode(response.body.toString());
      userdata_byid = data1['data'];
      setState(() {});
    }
    else {
      print ('Get User by Id : 200');
    }
  }

  checkBoost_by_id(var id) async {

    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/BoostPlanById.php"),
        body: data2);
    if (response.statusCode == 201) {
      print ('Boost user by id : 201');
      var data1 = jsonDecode(response.body.toString());
      boostUsers.add(data1['data']['user_id']);
      boostUsers=boostUsers.toSet().toList();
      setState(() {
        boostUsers;
      });
    } else {
      print ('Boost user by id : 200');
    }
  }


  Future<Filteroctoboss> getProducts() async{
    final response=await http.get(Uri.parse('https://admin.octo-boss.com/API/FilterOctoboss.php'));
    var data=jsonDecode(response.body.toString());
    if(response.statusCode==201){
      var mazhar;
      mazhar=data['data'];

      var all_actve_octo=mazhar.where(
            (u) => (u['is_active'].toString().toLowerCase().contains(
          'Yes'.toLowerCase(),
        )),
      ).toList();
      var boosted_octo=all_actve_octo.where(
            (u) => (u['has_boost'].toString().toLowerCase().contains(
          'Yes'.toLowerCase(),
        )),
      ).toList();

      var unBoosted_octo=all_actve_octo.where(
            (u) => (u['has_boost'].toString().toLowerCase().contains(
          'No'.toLowerCase(),
        )),
      ).toList();

      boosted_octo.addAll(unBoosted_octo);
      list_of_octoboss=boosted_octo;

      var len=data['data'].length;
      if(searching==0){

        sorted_octoboss=list_of_octoboss.where(
              (u) => (u['service'].toString().toLowerCase().contains(
            ttt.toString().toLowerCase(),
          )),
        ).toList();

        var len=sorted_octoboss.length;
        for(int i=0;i<len;i++){
          checkBoost_by_id(sorted_octoboss[i]['id']);
        }
        searchController.text=ttt.toString().trim();
      }

      if(searching==1){
        sorted_octoboss=dummy_octoboss;
      }
      return Filteroctoboss.fromJson(data);
    }
    else{
      return Filteroctoboss.fromJson(data);
    }
  }
  @override
  void initState() {
    Filteroctoboss();
    // TODO: implement initState
    super.initState();
  }


  get_AllReviews(var id) async {
    var data = {
      'user_id': id,
    };
    var encoded_data = json.encode(data);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/Reviewes.php'),
        body: encoded_data);

    if (response.statusCode == 201) {
      print('Get all Review : 201');
      var reviews_res = jsonDecode(response.body.toString());
      var totalreview=0.0;
      review=reviews_res['data'];
      var len=review.length;
      for(int i=0;i<len;i++){
          var rating1=double.parse(review[i]['rating']);
          totalreview +=rating1;
      }

      totalreview /=len;
      totalreview=double.parse(totalreview.toStringAsFixed(2));
      setState(() {
        totalreview;
      });
      return true;
    }
    if (response.statusCode == 200) {
      print('Get all Review : 200');
      var reviews_res = jsonDecode(response.body.toString());
      review =null;
      return false;
    }

    else {
      var issue_response = jsonDecode(response.body.toString());
      print('Get all Review : else');
    }
  }
  get_Total_AllReviews(var id) async {
    totalstars=0.0;
    var data = {
      'user_id': id,
    };
    var encoded_data = json.encode(data);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/Reviewes.php'),
        body: encoded_data);

    if (response.statusCode == 201) {
      print('Get all Review : 201');
      var reviews_res = jsonDecode(response.body.toString());
      totalReviewRating=reviews_res['data'];
      var len=totalReviewRating.length;
      for(int i=0;i<len;i++){
        var rating1=double.parse(totalReviewRating[i]['rating']);
        totalstars +=rating1;
      }
      totalstars /=len;
      totalstars=double.parse(totalstars.toStringAsFixed(2));
      setState(() {
        totalstars;
      });
      return true;
    }
    if (response.statusCode == 200) {
      print('Get all Review : 200');
      var reviews_res = jsonDecode(response.body.toString());
      review =null;
      return false;
    }

    else {
      var issue_response = jsonDecode(response.body.toString());
      print('Get all Review : else');
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
    } else {
      var issue_response = jsonDecode(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 33,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: (value) {
                      sorted_octoboss =list_of_octoboss.where(
                            (u) => (u['service'].toString().toLowerCase().contains(
                          value.toLowerCase(),
                        )),
                      ).toList();
                      dummy_octoboss=sorted_octoboss;
                      setState(() {
                        searching=1;
                      });
                      //Do something with the user input.
                    },
                    controller: searchController,
                    autocorrect: true,

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Search any Services...',
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
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.orange.shade900,
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Result offering Benefits'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),

          Expanded(
            child: FutureBuilder<Filteroctoboss>(
              future: getProducts(),
              builder: (context,AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemCount: sorted_octoboss.length,
                  itemBuilder: (context, index) {
                    var last=sorted_octoboss[index]['last_seen'];
                    var lastseen=last.toString().split(' ').last.split(':');
                    var lastseen_hour=int.parse(lastseen[0]);
                    var lastseen_minutes=int.parse(lastseen[1]);

                    return InkWell(
                      onTap: ()  {
                        get_user_by_id(sorted_octoboss[index]['id']);
                        _showMyDialog(sorted_octoboss[index]['id'].toString());
                      },
                      child: Card(
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
                                    Stack(
                                        clipBehavior: Clip.none,
                                        children:[
                                          CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.blue,
                                          backgroundImage: NetworkImage(
                                              sorted_octoboss[index]['image']??'https://admin.octo-boss.com/images/profile/626fd6636d644scaled_image_picker1287484104404574785.jpg'
                                          ),
                                        ),
                                         checkbool(sorted_octoboss[index]['is_active'])?
                                        Positioned(
                                         top: 10,left: 80,
                                         child: CircleAvatar(backgroundColor: Colors.green,radius: 10,)):
                                           Positioned(
                                         top: 10,left: 80,
                                         child: CircleAvatar(backgroundColor: Colors.grey,radius: 10,)),

                                      ]),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(sorted_octoboss[index]['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Text(sorted_octoboss[index]['service']??'', style: TextStyle()),
                                    SizedBox(height: 10,),
                                    SizedBox(height: 5,),
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
                                        Text('${sorted_octoboss[index]['chats']} Chats', style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade900,
                                          borderRadius: BorderRadius.circular(22),
                                          border: Border.all(color: Colors.grey)),
                                      child: Center(
                                          child: (boostUsers.contains(sorted_octoboss[index]['id'].toString()))?Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text('Featured'.tr,style: TextStyle(color: Colors.white),),
                                          ):Text('',style: TextStyle(color: Colors.white),),
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
                      ),
                    );
                  },);
              },
            ),
          )
        ],
      )),
    );
  }


  Future<void> _showMyDialog(var userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return SingleChildScrollView(
          physics: ScrollPhysics(),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text('Octoboss Profile'.tr),
                content: Column(
                  children: [
                    Container(
                      child: FutureBuilder(
                        future: get_user_by_id(userId),
                        builder: (context, snapshot) {

                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          else{
                            return Column(
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(userdata_byid['picture'].toString()??"https://admin.octo-boss.com/images/profile/6265f587a9ef8image_2022_03_05T11_48_38_160Z.png"),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  child: FutureBuilder(
                                    future:get_Total_AllReviews(userId),
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState==ConnectionState.waiting){
                                        return CircularProgressIndicator();
                                      }
                                      else{
                                        return Center(
                                            child: SmoothStarRating(
                                                allowHalfRating: false,
                                                onRated: (v) {},
                                                starCount: 5,
                                                rating: totalstars,
                                                size: 40.0,
                                                isReadOnly: true,
                                                color: Color(0xffff6e01),
                                                borderColor: Color(0xffff6e01),
                                                spacing: 0.0));
                                      }


                                    },),
                                ),

                                SizedBox(height: 35),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Color(0xffff6e01),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'First Name'.tr,
                                            style:
                                            TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Color(0xffff6e01),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Last Name'.tr,
                                            style:
                                            TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 28,
                                        ),
                                        Text(
                                          userdata_byid['first_name']??'',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 28,
                                        ),
                                        Text(
                                          userdata_byid['last_name'].toString(),
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      color: Color(0xffff6e01),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Services Offered'.tr,
                                      style: TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Text(
                                        userdata_byid['category']??'',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.countertops,
                                      color: Color(0xffff6e01),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Country'.tr,
                                      style: TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      userdata_byid['country']??'',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    ElevatedButton(
                                      onPressed: () {
                                        makeFavorite(userdata_byid['id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Favorite'.tr),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xffff6e01),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        var online=int.parse(userdata_byid['is_online']??'2');

                                        if(online==1){
                                          print('Profile = 1');
                                          get_receiverId=int.parse(userId);
                                          get_octobossName=userdata_byid;
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
                                      child: Text('Chat with me'.tr),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xffff6e01),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50))),
                                    ),
                                  ],),
                                Text(
                                  'Certificates'.tr,
                                  style: TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    height: 170,
                                    width: Get.size.width*0.8,
                                    child: SizedBox(height: 100, child: buildGridView1(userdata_byid)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.grey.shade100,
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Work Pictures'.tr,
                                  style: TextStyle(color: Color(0xffff6e01), fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 170,
                                    width: Get.size.width*0.8,
                                    child: SizedBox(height: 100, child: buildGridView(userdata_byid)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.grey.shade100,
                                    )),
                              ],
                            );
                          }
                        },),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Rating & Reviews'.tr,
                      style: TextStyle(color: Color(0xffff6e01), fontSize: 18),
                    ),
                    SizedBox(height: 25),
                    Container(


                      child: FutureBuilder(
                        future: get_AllReviews(userId),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator());
                          }
                          else{
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: review!=null?300:100,
                              child: ListView.builder(
                                  itemCount: review==null?0:review.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                        children: [
                                          Center(
                                              child: SmoothStarRating(
                                                  allowHalfRating: false,
                                                  onRated: (v) {},
                                                  starCount: 5,
                                                  rating: double.parse(review[index]['rating']),
                                                  size: 40.0,
                                                  isReadOnly: true,
                                                  color: Color(0xffff6e01),
                                                  borderColor: Color(0xffff6e01),
                                                  spacing: 0.0)),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              SizedBox(width: 35),
                                              Text(review[index]['review'].toString()),
                                              Visibility(
                                                  visible: review==null?true:false,
                                                  child: Text('No Rating & Reviews Found')),
                                            ],
                                          ),
                                          Divider(thickness: 3,)
                                        ]);
                                  }),
                            );
                          }
                        },),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },)
        );
      },
    );
  }

  Widget buildGridView1(var user) {
      return StatefulBuilder(
        builder: (context, setState) {
        return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          children: List.generate(user['certificate'].length, (index) {
            var asset = user['certificate']![index]['image'];
            return Container(
              child: Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Certificate Image',
                        titleStyle: TextStyle(color: Colors.deepOrange),
                        content: Column(
                          children: [
                            SizedBox(height: 10,),
                            Image.network(
                              user['certificate'][index]['image'].toString(),
                              width: 500,
                              height: 500,
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
                        )
                      );
                    },
                    child: Image.network(
                      user['certificate'][index]['image'].toString(),
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ]),
            );
          }),
        );
      },);

  }
  Widget buildGridView(var user) {
      return StatefulBuilder(builder: (context, setState) {
        return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          children: List.generate(user['work_picture'].length, (index) {
            var asset = user['work_picture']![index]['image'];
            return Container(
              child: Stack(
                  clipBehavior: Clip.none, children: [
                Positioned(
                  child:  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Work Image',
                          titleStyle: TextStyle(color: Colors.deepOrange),
                          content: Column(
                            children: [
                              SizedBox(height: 10,),
                              Image.network(
                                user['work_picture'][index]['image'].toString(),
                                width: 500,
                                height: 500,
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
                          )
                      );
                    },
                    child: Image.network(
                      user['work_picture'][index]['image'].toString(),
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ]),
            );
          }),
        );
      },
      );

  }
}
