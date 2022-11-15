import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/add_issue_screen.dart';

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


class IssueListDone extends StatefulWidget {
  IssueListDone({Key? key}) : super(key: key);

  @override
  State<IssueListDone> createState() => _IssueListDoneState();
}

class _IssueListDoneState extends State<IssueListDone> {
  Future<issueList> getPostApi_processing() async {

    final response = await http.get(
        Uri.parse("https://admin.octo-boss.com/API/IssuesList.php"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      print('Issue List : 201');
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
      print('Issue List : 200');
      return issueList.fromJson(data);
    }
  }

  var status;
  var baseurl = 'https://admin.octo-boss.com';

  late Future<issueList> futureList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<issueList>(
                  future: getPostApi_processing(),
                  builder: (context,AsyncSnapshot snapshot) {
                    if(snapshot.data!=null){
                      return ListView.builder(
                        itemCount: abc_done.length,
                        itemBuilder: (context, index) {
                          status=checkValue(abc_done[index]['issue_type']);

                          if(snapshot.hasData){
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 8),
                              child: Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize:MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      '${baseurl + '/' + abc_done[index]['image']}'),
                                                  radius: 35,
                                                  backgroundColor: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(abc_done[index]['title']),
                                                  Text(abc_done[index]['status']),
                                                  Text(abc_done[index]['description']),
                                                  Text(abc_done[index]['languages']),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Column(
                                              children: [
                                                Text('Public Issue'),
                                                Container(
                                                  child: FlutterSwitch(
                                                    width: 105.0,
                                                    height: 35.0,
                                                    valueFontSize: 15.0,
                                                    toggleSize: 45.0,
                                                    value: status,
                                                    borderRadius: 30.0,
                                                    padding: 8.0,
                                                    activeColor: Colors.orange,
                                                    showOnOff: true,
                                                    onToggle: (val) {
                                                      setState(() {
                                                        if(val){
                                                          status=val;
                                                        }
                                                        else{
                                                          status=true;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          }
                          else{
                            return CircularProgressIndicator();
                          }

                        },
                      );
                    }
                    else{
                      return Center(child: CircularProgressIndicator());
                    }

                  })),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CustomerAddIssueScreen()));
            },
            child: Card(
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  Spacer(),
                  Text(
                    'Add new issue'.tr,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
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
