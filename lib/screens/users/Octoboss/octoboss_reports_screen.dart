import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/routes/circular_reveal_clipper.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
// import 'package:fl_chart/fl_chart.dart';

class OctobossReportsScreen extends StatefulWidget {
  const OctobossReportsScreen({Key? key}) : super(key: key);

  @override
  State<OctobossReportsScreen> createState() => _OctobossReportsScreenState();
}

class _OctobossReportsScreenState extends State<OctobossReportsScreen> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  late Future getDone;
  var jobdone_data;
  var jobsdone;
  var revenue=0;
  var totalhours=0;
  var totalrating=0.0;

  getJobsDone(String receiverId) async{

    try{

      var data={'reciever_id':receiverId};
      revenue=0;
      totalhours=0;
      totalrating=0.0;
      var rating=0.0;

      //It is used for raw data;
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetJobDone.php'),
          body: data1
      );
      if(response.statusCode==201){
        var data2=jsonDecode(response.body.toString());
        jobsdone=data2;
        jobdone_data=data2['data'];
        var len=jobdone_data.length;
        for(int i=0;i<len;i++){
          var price=int.parse(jobdone_data[i]['price']);
          if(jobdone_data[i]['duration']==""){
            totalhours +=0;
          }
          if(jobdone_data[i]['duration']!=""){
            var duration=int.parse(jobdone_data[i]['duration']);
            totalhours +=duration;
          }
          if(jobdone_data[i]['rating']==""){
            totalrating +=0.0;
          }
          if(jobdone_data[i]['rating']!=""){
            var rating=double.parse(jobdone_data[i]['rating']);
            totalrating +=rating;
          }
          revenue +=price;
        }
        totalrating /=len;
        totalrating=double.parse(totalrating.toStringAsFixed(2));
        return true;
      }
      else if(response.statusCode==200){
        var data2=jsonDecode(response.body.toString());
        jobdone_data=null;
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

    getDone=getJobsDone(user_details['data']['id']);
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    bool showAvg = false;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: FutureBuilder(
              future: getDone,
              builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Align(
                  alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }
              else{
                return (jobdone_data==null)?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Card(
                      child: SizedBox(
                          height: screenHeight * 0.08,
                          width: double.infinity,
                          child: Center(
                              child: Text(
                                'Reports'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 20,
                                ),
                              ))),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rating'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '0',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Hours'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '0 hrs',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Revenue'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '\$ 0',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Done Jobs'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '0',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                  ],
                ):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Card(
                      child: SizedBox(
                          height: screenHeight * 0.08,
                          width: double.infinity,
                          child: Center(
                              child: Text(
                                'Reports'.tr,
                                style: TextStyle(
                                  fontSize: fontSize * 20,
                                ),
                              ))),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rating'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        totalrating.toString(),
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total hours'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '$totalhours hrs',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total revenue'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '\$$revenue',
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Done jobs'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        jobdone_data.length.toString(),
                        style: TextStyle(
                            fontSize: fontSize * 90, color: Color(0xffff6e01)),
                      ),
                    ),
                  ],
                );
              }
            },),
          ),
        ),
      ),
    );
  }

}

class InfoWidget extends StatelessWidget {
  InfoWidget({Key? key, required this.title, required this.details})
      : super(key: key);

  String title, details;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Card(
      child: SizedBox(
          height: screenHeight * 0.1,
          width: double.infinity,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize * 20,
                  ),
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: fontSize * 20,
                ),
              ),
            ],
          ))),
    );
  }
}

//dropdwon widget
class MonthsDropDown extends StatefulWidget {
  const MonthsDropDown({Key? key}) : super(key: key);

  @override
  _MonthsDropDownState createState() => _MonthsDropDownState();
}

class _MonthsDropDownState extends State<MonthsDropDown> {
  List<String> _locations = [
    'January',
    'Feburary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]; // Option 2
  String? _selectedLocation; // Option 2
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        hint: Text('Filter by month'), // Not necessary for Option 1
        value: _selectedLocation,
        onChanged: (newValue) {
          setState(() {
            _selectedLocation = newValue as String?;
          });
        },
        items: _locations.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
    );
  }
}
