

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:octbs_ui/screens/users/Octoboss/settings_screen.dart';
import 'package:http/http.dart' as http;

class OctobossAboutUs extends StatefulWidget {
  OctobossAboutUs({Key? key}) : super(key: key);

  @override
  State<OctobossAboutUs> createState() => _OctobossAboutUsState();
}

class _OctobossAboutUsState extends State<OctobossAboutUs> {

  Future<SettingsModel> getPostApi() async {
    final response = await http
        .get(Uri.parse("https://admin.octo-boss.com/API/Settings.php"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      return SettingsModel.fromJson(data);
    } else {
      return SettingsModel.fromJson(data);
    }
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
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.04),
                    // alignment: Alignment.center,
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
                ],
              ),
              Expanded(
                child: FutureBuilder<SettingsModel>(
                    future: getPostApi(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data!.data!.aboutOctoboss.toString(),
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ));
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              )
            ],
          )),
    );
  }
}
