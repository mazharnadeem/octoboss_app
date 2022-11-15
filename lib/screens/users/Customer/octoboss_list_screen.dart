import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OctoBossList extends StatelessWidget {
  const OctoBossList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                              Navigator.of(context).pop();
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
                          'OctoBoss',
                          style: TextStyle(
                            fontSize: fontSize * 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LanguageDropDown(),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(''),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      title: Text(''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Home Repair from ${''}'),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableOctobossWidget extends StatelessWidget {
  const AvailableOctobossWidget({
    Key? key,
    required this.fontSize,
    required this.screenWidth,
    required this.chatted,
    required this.isBoosted,
  }) : super(key: key);

  final double fontSize;
  final double screenWidth;
  final bool chatted;
  final bool isBoosted;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          trailing: Icon(
            Icons.check_circle,
            color: chatted ? Colors.green : Colors.grey,
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/qailah_profile.png'),
          ),
          title: Text('Qailah Jahan'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home Repair'),
              Text('10 years experience over call'),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_sharp,
                    color: Color(0xffFF5A01),
                  ),
                  Text('98%'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('5 km'),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'LOCATION',
                          style: TextStyle(
                            fontSize: fontSize * 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: screenWidth * 0.1),
                  Row(
                    children: [
                      Icon(
                        Icons.chat,
                        color: Color(0xffFF5A01),
                      ),
                      Text('Chats')
                    ],
                  ),
                  isBoosted
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xffFF5A01),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Boosted'),
                          ),
                        )
                      : Container(),
                ],
              )
            ],
          )),
    );
  }
}

///
//dropdwon widget
class SelectIssueDropDown extends StatefulWidget {
  const SelectIssueDropDown({Key? key}) : super(key: key);

  @override
  _SelectIssueDropDownState createState() => _SelectIssueDropDownState();
}

class _SelectIssueDropDownState extends State<SelectIssueDropDown> {
  List<String> _locations = [
    'Issue 1',
    'Issue 2',
    'Issue 3',
    'Issue 4',
    'Issue 5',
  ]; // Option 2
  String? _selectedLocation; // Option 2
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        style: TextStyle(
          color: Color(0xffFF5A01),
        ),
        borderRadius: BorderRadius.circular(15),
        hint: Text('Select your issue'),
        // Not necessary for Option 1
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

//dropdwon widget
class LanguageDropDown extends StatefulWidget {
  const LanguageDropDown({Key? key}) : super(key: key);

  @override
  _LanguageDropDownState createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  List<String> _locations = [
    'English',
    'Arabic',
    'Italian',
    'Turkish',
    'Urdo',
    'more',
  ]; // Option 2
  String? _selectedLocation; // Option 2
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        hint: Text('Filter by Language'), // Not necessary for Option 1
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
