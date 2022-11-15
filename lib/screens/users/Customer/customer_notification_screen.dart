import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomerNotificationScreen extends StatelessWidget {
  const CustomerNotificationScreen({Key? key}) : super(key: key);

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
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Text(
                        'notifications'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'You have ',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: '3 Notifications ',
                          style: TextStyle(
                            color: Color(0xffff6e01),
                          )),
                      TextSpan(
                          text: 'today',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: fontSize * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            //list
            ListView(
              shrinkWrap: true,
              children: [
                _buildListItem(screenWidth),
                Divider(),
                _buildListItem(screenWidth),
                Divider(),
                _buildListItem(screenWidth)
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.11, vertical: screenWidth * 0.01),
              child: Text(
                'This Week',
                style: TextStyle(
                  fontSize: fontSize * 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //
            ListView(
              shrinkWrap: true,
              children: [
                _buildThisWeekListItem(screenWidth),
                Divider(),
                _buildThisWeekListItem(screenWidth),
                Divider(),
                _buildThisWeekListItem(screenWidth),
                Divider(),
                _buildThisWeekListItem(screenWidth),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildThisWeekListItem(double screenWidth) {
    return Container(
      margin:
          EdgeInsets.only(right: screenWidth * 0.1, left: screenWidth * 0.17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Image.asset('assets/images/user1.png'),
          ),
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 130,
              ),
              child: RichText(
                // overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'Amira ',
                      style: TextStyle(
                        color: Color(0xffff6e01),
                      ),
                    ),
                    TextSpan(
                      text: 'Lorem Ipsum dummy text \nCommented 2h ago',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Image.asset('assets/icons/logo2.png')
        ],
      ),
    );
  }

  Container _buildListItem(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Color(0xffff6e01),
                shape: BoxShape.circle,
              )),
          Container(
            child: Image.asset('assets/images/user1.png'),
          ),
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 130,
              ),
              child: RichText(
                // overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'Amira ',
                      style: TextStyle(
                        color: Color(0xffff6e01),
                      ),
                    ),
                    TextSpan(
                      text: 'Lorem Ipsum dummy text \nCommented 2h ago',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Image.asset('assets/icons/logo2.png')
        ],
      ),
    );
  }
}
