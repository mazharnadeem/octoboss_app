import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';

class NameBottomSheet extends StatefulWidget {
  @override
  _NameBottomSheetState createState() => _NameBottomSheetState();
}

class _NameBottomSheetState extends State<NameBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var serviceController=TextEditingController();
  String? serviceName;
  var users_data_by_id;

  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      print('Service offered : 201');

      var data1 = jsonDecode(response.body.toString());
      users_data_by_id = data1['data'];
      var x=users_data_by_id['category'];
      var serviceslist = x.toString().split(',');
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              cursorColor: Color(0xffff6e01),
              onSaved: (input) => serviceName = input,
              controller: serviceController,
              decoration: InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.wrench,
                  color: Color(0xffff6e01),
                ),
                labelText: 'Service Name',
                labelStyle: TextStyle(color: Color(0xffff6e01)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffff6e01)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xffff6e01)),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await get_user_by_id(user_details['data']['id']);
                  var addService=users_data_by_id['category'].toString().split(',');
                  addService.add(serviceController.text.toString());
                  if(serviceController.text.toString()!=''){
                    ApiServices().AddOctobossPictureandData(
                      fname: user_details['data']['first_name'].toString(),
                      lname: user_details['data']['last_name'].toString(),
                      dob: user_details['data']['date_of_birth'].toString(),
                      fullAddress: user_details['data']['address'].toString(),
                      email: user_details['data']['email'].toString(),
                      streetname: user_details['data']['street_name'].toString(),
                      streetAddress: user_details['data']['street_address'].toString(),
                      unitNumber: user_details['data']['unit_number'].toString(),
                      city: user_details['data']['city'].toString(),
                      phoneNumber: user_details['data']['phone'].toString(),
                      jobInfo: user_details['data']['job_info'].toString(),
                      tagsServices: user_details['data']['tag_of_services'].toString(),
                      // tagsServices: '',
                      jobTitle: user_details['data']['job_title'].toString(),
                      detailedDescription: user_details['data']['detail_description'].toString(),
                      country: user_details['data']['country'].toString(),
                      postalCode: user_details['data']['postal_code'].toString(),
                      category: addService.join(','),
                      language: user_details['data']['language'].toString(),
                      streetnumber:user_details['data']['street_no'].toString(),
                      // image: File(user_details['data']['picture'].toString()).path,
                      // certficate: user_details['data']['street_no'],
                      // work_picture: user_details['data']['street_no'],
                    );
                  }

                  Navigator.pop(context);

                },
                child: Text(
                  "Add Service",
                  style: TextStyle(color: Color(0xffff6e01)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> AddService() async {
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        Navigator.pop(context);
      } catch (e) {}
    }
  }
}
