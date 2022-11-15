import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:http/http.dart' as http;


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




class OctobossIssuesListScreen extends StatefulWidget {
  const OctobossIssuesListScreen({Key? key}) : super(key: key);

  @override
  State<OctobossIssuesListScreen> createState() => _OctobossIssuesListScreenState();
}

class _OctobossIssuesListScreenState extends State<OctobossIssuesListScreen> {
  var donejobs;

  Future<issueList> getPostApi_processing() async {

    final response = await http.get(
        Uri.parse("https://admin.octo-boss.com/API/IssuesList.php"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      issue_details=data['data'];
      var x=user_details['data']['id'];
      var len=data['data'].length-1;
      var y;
      var ind=0;
      var ls=[];
      abc_done.clear();
      for(int i=0;len>=i;i++){
        var che=data['data'][i]['status'];
        setState(() {});
        if(che=='done')
            {
          if (i <= len) {
            if (x == data['data'][i]['created_by']) {
              y = data['data'][i];
              abc_done.add(y);
            }
          }
        }
      }
      return issueList.fromJson(data);
    } else {
      return issueList.fromJson(data);
    }
  }
  get_Jobsdone(var id) async {
    var data = {'reciever_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetJobDone.php"),
        body: data2);
    if (response.statusCode == 201) {
      var data1 = jsonDecode(response.body.toString());
      donejobs = data1['data'];
    } else {
      donejobs=null;
      return false;
    }
  }

  var status;
  late Future<issueList> futureList;

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
                          Navigator.pop(context);
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
                      'jobs'.tr,
                      style: TextStyle(
                        fontSize: fontSize * 22,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder(
                future: get_Jobsdone(user_details['data']['id']),
                builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                else{
                  return donejobs==null?Align(
                    alignment: Alignment.center,
                      child: Text('No Jobs Done')):Expanded(
                    child: ListView.builder(
                      itemCount: donejobs.length,
                      itemBuilder: (context, index) {
                        var jobindex=index+1;
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8),
                          child: Card(
                            elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Job'.tr+'$jobindex',
                                      style: TextStyle(
                                        fontSize: fontSize * 22,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize:MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Problem'.tr),
                                                  Divider(height: 30,),
                                                  Text('Description'.tr),
                                                  Divider(height: 30,),
                                                  Text('Location'.tr),
                                                  Divider(height: 30,),
                                                  Text('Language'.tr),
                                                  Divider(height: 30,),
                                                  Text('On date'.tr),
                                                  Divider(height: 30,),
                                                  Text('Price'.tr),
                                                  Divider(height: 30,),
                                                  Text('Duration'.tr),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(donejobs[index]['problem'].toString()),
                                                  Divider(height: 30,),
                                                  Text(donejobs[index]['description'].toString()),
                                                  Divider(height: 30,),
                                                  Text(donejobs[index]['location'].toString()),
                                                  Divider(height: 30,),
                                                  Text(donejobs[index]['languages'].toString()),
                                                  Divider(height: 30,),
                                                  Text(donejobs[index]['date'].toString()),
                                                  Divider(height: 30,),
                                                  Text('\$ ${donejobs[index]['price'].toString()}'),
                                                  Divider(height: 30,),
                                                  Text('${donejobs[index]['duration'].toString()} hours'),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );

                      },
                    ),
                  );
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
  checkValue(var value) {
    if(value=='public'){
      return true;
    }
    else{
      return false;
    }
  }
}
