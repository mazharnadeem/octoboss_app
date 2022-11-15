import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OctoBossPublicProfile extends StatefulWidget {
  const OctoBossPublicProfile({
    required this.UID,
    required this.isFav,
    Key? key,
  }) : super(key: key);

  final String UID;
  final bool isFav;

  @override
  _OctoBossPublicProfileState createState() => _OctoBossPublicProfileState();
}

class _OctoBossPublicProfileState extends State<OctoBossPublicProfile> {
  bool isFavourite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isFavourite = widget.isFav;
    });
  }

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
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Container(
                      width: 130,
                      height: 130,
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
                          image: NetworkImage(''
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: fontSize * 18,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isFavourite = !isFavourite;
                              });
                            },
                            icon: isFavourite
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  InkWell(
                    onTap: () {
                    },
                    child: Center(
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffff6e01),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Card(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: fontSize * 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text('5 years'),
                        ],
                      ),
                    ),
                  ),
                  //
                  Card(
                    child: Container(
                      height: screenHeight * 0.2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Services',
                              style: TextStyle(
                                fontSize: fontSize * 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          CircleAvatar(
                            radius: 60,
                            child: Text('Certificate 1'),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          CircleAvatar(
                            radius: 60,
                            child: Text('Certificate 2'),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          CircleAvatar(
                            radius: 60,
                            child: Text('Certificate 3'),
                          ),
                          CircleAvatar(
                            radius: 60,
                            child: Text(
                              'Upload Certificate +',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //
                  Card(
                    child: Container(
                      height: screenHeight * 0.1,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: fontSize * 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text('\$18/hour'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: fontSize * 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 7,
                            leading: Icon(
                              Icons.circle_outlined,
                              size: 10,
                            ),
                            title: Text(
                              '1st service: Free issue diagnosis & cost estimate by our experts on whatsapp video call.',
                              style: TextStyle(
                                fontSize: fontSize * 13,
                              ),
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 7,
                            leading: Icon(
                              Icons.circle_outlined,
                              size: 10,
                            ),
                            title: Text(
                              '1st service: Free issue diagnosis & cost estimate by our experts on whatsapp video call.',
                              style: TextStyle(
                                fontSize: fontSize * 13,
                              ),
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 7,
                            leading: Icon(
                              Icons.circle_outlined,
                              size: 10,
                            ),
                            title: Text(
                              '1st service: Free issue diagnosis & cost estimate by our experts on whatsapp video call.',
                              style: TextStyle(
                                fontSize: fontSize * 13,
                              ),
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 7,
                            leading: Icon(
                              Icons.circle_outlined,
                              size: 10,
                            ),
                            title: Text(
                              '1st service: Free issue diagnosis & cost estimate by our experts on whatsapp video call.',
                              style: TextStyle(
                                fontSize: fontSize * 13,
                              ),
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 7,
                            leading: Icon(
                              Icons.circle_outlined,
                              size: 10,
                            ),
                            title: Text(
                              '1st service: Free issue diagnosis & cost estimate by our experts on whatsapp video call.',
                              style: TextStyle(
                                fontSize: fontSize * 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //location
                  Card(
                      child: Container(
                          height: screenHeight * 0.1,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Location Service',
                                style: TextStyle(
                                  fontSize: fontSize * 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Currently offering services in London 3432',
                                style: TextStyle(
                                  fontSize: fontSize * 12,
                                  // fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ))),
                  Text(
                    'What our Customers say',
                    style: TextStyle(
                      fontSize: fontSize * 18,
                      color: Color(0xffff6e01),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Image.asset(
                                    'assets/images/qailah_profile.png'),
                                title: Text(
                                  'Waadi Khan',
                                  style: TextStyle(
                                    color: Color(0xffff6e01),
                                    fontSize: fontSize * 18,
                                  ),
                                ),
                                subtitle: Text('Dubai 16th july 2021'),
                                trailing: Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.black)),
                                  width: screenWidth * 0.15,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star),
                                      Text('5.0'),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.2,
                                    vertical: screenWidth * 0.02),
                                child: Text('Amazing experience of getting'
                                    'service done through OctoBoss'
                                    'the technician Ebadaah did his '
                                    'job really well and also explained'
                                    'the whole repairing  and replacement '
                                    'part very nicely.'),
                              )
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
