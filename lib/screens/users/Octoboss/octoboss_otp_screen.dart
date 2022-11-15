import 'package:flutter/material.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';

class OctoBossOTPScreen extends StatelessWidget {
  const OctoBossOTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                        size: screenHeight * 0.02,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification OTP',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: fontSize * 25,
                            // fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              // flex: 2,
              fit: FlexFit.loose,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/Logo_NameSlogan_Map.png',
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(height: screenHeight * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: '|'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: '|'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: '|'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: '|'),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Center(
              child: Container(
                width: screenWidth * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => OctoBossBottomNavBar()));
                  },
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: fontSize * 17,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xffff6e01),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
