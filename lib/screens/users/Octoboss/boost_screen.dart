import 'package:flutter/material.dart';

class BoostScreen extends StatelessWidget {
  const BoostScreen({Key? key}) : super(key: key);

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
            //
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Boost your Account',
                    ),
                  ),
                ],
              ),
            ),
            //
            Expanded(
              child: Card(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Boost Type'),
                            Text('Price'),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(screenHeight * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Be on top for 1 day',
                                    ),
                                    Text(
                                      '\$5',
                                      style: TextStyle(
                                        fontSize: fontSize * 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              //
                              Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Be on top for 3 days',
                                      style: TextStyle(
                                        fontSize: fontSize * 20,
                                      ),
                                    ),
                                    //
                                    Text(
                                      '\$10',
                                      style: TextStyle(
                                        fontSize: fontSize * 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //
                              SizedBox(height: screenHeight * 0.03),
                              Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Be on top for 7 days',
                                      style: TextStyle(
                                        fontSize: fontSize * 20,
                                      ),
                                    ),
                                    //
                                    Text(
                                      '\$14',
                                      style: TextStyle(
                                        fontSize: fontSize * 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
