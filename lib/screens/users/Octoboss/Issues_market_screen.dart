import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:octbs_ui/screens/users/Octoboss/octoboss_chat_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class issueList {
  int? response;
  int? code;
  List<Data>? data;

  issueList({this.response, this.code, this.data});

  issueList.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  String? status;
  String? image;
  String? languages;
  String? createdBy;
  String? createdAt;
  List<History>? history;

  Data(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.image,
      this.languages,
      this.createdBy,
      this.createdAt,
      this.history});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    image = json['image'];
    languages = json['languages'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['image'] = this.image;
    data['languages'] = this.languages;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  String? id;
  String? issueId;
  String? status;
  String? userId;
  String? date;

  History({this.id, this.issueId, this.status, this.userId, this.date});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    issueId = json['issue_id'];
    status = json['status'];
    userId = json['user_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issue_id'] = this.issueId;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    return data;
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;
  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class IssuesMarket extends StatefulWidget {
  const IssuesMarket({Key? key}) : super(key: key);

  @override
  _IssuesMarketState createState() => _IssuesMarketState();
}

class _IssuesMarketState extends State<IssuesMarket> {
  final _debouncer = Debouncer();
  var searching = 0;
  var dummy = [];
  var filterSelect=false;


  Future<issueList> getIssuesApi() async {
    final response = await http.get(
        Uri.parse("https://admin.octo-boss.com/API/IssuesList.php"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {

      var xyz;
       var issue = data['data'];
       // var nadeem=issue.reversed.toList();
       // xyz=issue.reversed.toList();
       var che=[];
      var y;
      var ind = 0;
      var ls = [];
      var len = data['data'].length - 1;
      var x = user_details['data']['category'].toString().split(',');
      var temp;

      for(int i=0;i<x.length;i++){
        temp=issue.where(
              (u) => (u['problem'].toString().toLowerCase().contains(
            x[i].trim().toLowerCase(),
          )),
        ).toList();

        for(int j=0;j<temp.length;j++){
          che.add(temp[j]);
        }
      }
      xyz=che;
       issue_details = xyz.toList();

      abc.clear();
      for (int i = 0; i<xyz.length; i++) {
        if (xyz[i]['issue_type'].toString().toLowerCase() == 'public')
        {
          if (i < xyz.length) {
            y = xyz[i];
            abc.add(y);
          }
        }
      }

      if (searching == 0) {
        sorted_list = abc;
      }
      if (searching == 1) {
        sorted_list = dummy;
      }

      return issueList.fromJson(data);
    } else {
      return issueList.fromJson(data);
    }
  }

  String? query;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Issues Market'.tr,
                      style: TextStyle(
                        fontSize: fontSize * 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Visibility(
                visible: !filterSelect,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    cursorColor: Color(0xffff6e01),
                    onChanged: (val) {
                      sorted_list = abc
                          .where(
                            (u) =>
                                (u['languages'].toString().toLowerCase().contains(
                                      val.toLowerCase(),
                                    )),
                          )
                          .toList();
                      dummy = sorted_list;
                      setState(() {
                        searching = 1;
                      });
                    },

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xffff6e01),
                      ),
                      contentPadding: EdgeInsets.only(left: 25.0),
                      hintText: 'Search by Language',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffff6e01)),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: filterSelect,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    cursorColor: Color(0xffff6e01),
                    onChanged: (val) {
                      sorted_list = abc
                          .where(
                            (u) =>
                        (u['tags'].toString().toLowerCase().contains(
                          val.toLowerCase(),
                        )),
                      )
                          .toList();
                      dummy = sorted_list;
                      setState(() {
                        searching = 1;
                      });
                    },

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xffff6e01),
                      ),
                      contentPadding: EdgeInsets.only(left: 25.0),
                      hintText: 'Search by Tags',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffff6e01)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20,top: 2,bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          filterSelect=false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                            color: filterSelect==false?Colors.deepOrangeAccent:Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.orange)),
                        child: Text('Language'.tr,style: TextStyle(color: filterSelect==false?Colors.white:Colors.black)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          filterSelect=true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                            color: filterSelect==false?Colors.white:Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.orange)),
                        child: Text('Tags'.tr,style: TextStyle(color: filterSelect==false?Colors.black:Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder(
                  future: getIssuesApi(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          itemCount: sorted_list.length,
                          itemBuilder: (context, index) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  ali = sorted_list[index];
                                  Get.to(OctobossIssueDetails());
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: sorted_list[index]['image'].toString(),
                                                  imageBuilder: (context, imageProvider) => CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        sorted_list[index]['image']
                                                    ),
                                                    radius: 30,
                                                    backgroundColor: Colors.white,
                                                  ),
                                                  placeholder: (context, url) => const Center(
                                                      child: CircularProgressIndicator()),

                                                  errorWidget: (context, url, error) =>CircleAvatar(
                                                    backgroundImage: AssetImage("assets/images/home_logo_new.jpg"),
                                                    radius: 30,

                                                    backgroundColor: Colors.white,
                                                  )
                                                      // Image.asset("assets/images/BigLogo.jpg"),
                                                )
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Problem'.tr,
                                                    style: TextStyle(
                                                      fontSize: fontSize * 18,
                                                      color: Color(0xffff6e01),
                                                    ),
                                                  ),
                                                  Text(
                                                    sorted_list[index]
                                                        ['description'],
                                                    style: TextStyle(
                                                      fontSize: fontSize * 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    sorted_list[index]
                                                        ['languages'],
                                                    style: TextStyle(
                                                      fontSize: fontSize * 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var ali;

class OctobossIssueDetails extends StatefulWidget {
  OctobossIssueDetails({Key? key}) : super(key: key);

  @override
  State<OctobossIssueDetails> createState() => _OctobossIssueDetailsState();
}

class _OctobossIssueDetailsState extends State<OctobossIssueDetails> {
  final _debouncer = Debouncer();
  var searching = 0;
  var dummy = [];
  var user;

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

      return profile_data;
    } else {
      print ('Get User by Id : 200');
      return false;
    }
  }
  get_chatUser_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      user = data1['data'];
      print ('Get Octoboss by Id : 201 :$user');

      return user;
    } else {
      print ('Get Octoboss by Id : 200');
      return false;
    }
  }


  Future<issueList> getIssuesApi() async {
    final response = await http.get(
        Uri.parse("https://admin.octo-boss.com/API/IssuesList.php"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {

      var xyz;
      var issue = data['data'];
      var che=[];
      var y;
      var ind = 0;
      var ls = [];
      var len = data['data'].length - 1;
      var x = user_details['data']['category'].toString().split(',');
      var temp;

      for(int i=0;i<x.length;i++){
        temp=issue.where(
              (u) => (u['problem'].toString().toLowerCase().contains(
            x[i].trim().toLowerCase(),
          )),
        ).toList();

        for(int j=0;j<temp.length;j++){
          che.add(temp[j]);
        }
      }
      xyz=che;
      issue_details = xyz.toList();
      abc.clear();
      for (int i = 0; i<xyz.length; i++) {
        if (xyz[i]['issue_type'].toString().toLowerCase() == 'public')
            {
          if (i < xyz.length) {
            y = xyz[i];
            abc.add(y);
          }
        }
      }

      if (searching == 0) {
        sorted_list = abc;
      }
      if (searching == 1) {
        sorted_list = dummy;
      }
      return issueList.fromJson(data);
    } else {
      return issueList.fromJson(data);
    }
  }
 @override
  void initState() {
   get_chatUser_by_id(user_details['data']['id']);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
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
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: screenHeight * 0.02,
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Issue Details'.tr,
                style: TextStyle(
                  fontSize: fontSize * 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          flex: 3,
          child: FutureBuilder(
            future: getIssuesApi(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      print('Specific image = ${ali['image']}');
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                imageUrl: ali['image'],
                                imageBuilder: (context, imageProvider) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: screenHeight * 0.37,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: screenHeight * 0.25,
                                  decoration: BoxDecoration(
                                    color: Color(0xffb74c3a).withOpacity(.4)

                                  ),
                                  child: Center(child: Container(
                                    height: Get.size.height*0.2,
                                    width: Get.size.width*0.5,
                                    child: Image.asset('assets/images/BigLogo.png'),
                                  )),
                                ),

                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xffff6e01),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Problem'.tr,
                                  style: TextStyle(
                                      color: Color(0xffff6e01), fontSize: 18),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 36, top: 5, right: 20),
                                  child: Text(
                                    ali['problem'],
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.location_pin,
                                  color: Color(0xffff6e01),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Location'.tr,
                                  style: TextStyle(
                                      color: Color(0xffff6e01), fontSize: 18),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 36, top: 5, right: 20),
                                  child: Text(
                                    ali['title'],
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.description,
                                  color: Color(0xffff6e01),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Description'.tr,
                                  style: TextStyle(
                                      color: Color(0xffff6e01), fontSize: 18),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 36, top: 5, right: 20),
                                  child: Text(
                                    ali['description'],
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.language,
                                  color: Color(0xffff6e01),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Language'.tr,
                                  style: TextStyle(
                                      color: Color(0xffff6e01), fontSize: 18),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 36, top: 5, right: 20),
                                  child: Text(
                                    ali['languages'],
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            FutureBuilder(
                              future: get_user_by_id(ali['created_by']),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState==ConnectionState.waiting)
                                  {
                                    return CircularProgressIndicator();
                                  }
                                else
                                  {
                                    return Column(
                                      children: [

                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)),
                                          color: Color(0xffff6e01),
                                          onPressed: () {
                                            get_chatUser_by_id(user_details['data']['id']);
                                            var online=int.parse(user['is_online']??'2');
                                            if(online==1){
                                              print('Profile = 1');
                                              get_receiverId=int.parse(ali['created_by']);
                                              get_octobossName=profile_data;
                                              Get.to(OctobossChatScreen());
                                            }
                                            if(online==0){
                                              Fluttertoast.showToast(msg: 'Turn on Your Status to chat this User');
                                              print('Profile = 0');

                                            }
                                            else{
                                              print('Profile = Else');
                                            }
                                          },
                                          child: Text('Chat'.tr,
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(height: 25),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(height: 25),
                                        CachedNetworkImage(
                                            imageUrl: profile_data['picture'].toString(),
                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  profile_data['picture'].toString()
                                              ),
                                              radius: 50,
                                              backgroundColor: Colors.white,
                                            ),
                                            placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator()),

                                            errorWidget: (context, url, error) =>CircleAvatar(
                                              backgroundImage: AssetImage("assets/images/home_logo_new.jpg"),
                                              radius: 50,

                                              backgroundColor: Colors.white,
                                            )
                                          // Image.asset("assets/images/BigLogo.jpg"),
                                        ),
                                        SizedBox(height: 25),
                                        Text(profile_data['full_name']??'Name Not Given'),
                                        SizedBox(height: 20),
                                        Center(
                                            child: SmoothStarRating(
                                                allowHalfRating: false,
                                                onRated: (v) {},
                                                starCount: 5,
                                                rating: double.parse(profile_data['rating']??0.toString()),
                                                size: 40.0,
                                                isReadOnly: true,
                                                color: Colors.yellow,
                                                borderColor: Colors.yellow,
                                                spacing: 0.0)),
                                        SizedBox(height: 35),

                                      ],);
                                  }
                            },),

                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    )));
  }
}
