import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class OctoBossRegisteraionForm extends StatelessWidget {
  const OctoBossRegisteraionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Building OctoBoss',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize * 25,
                            ),
                          ),
                          Text(
                            'Profile Page',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize * 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/Logo_NameSlogan_Map.png',
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Personal Info',
                      style: TextStyle(
                        fontSize: fontSize * 18,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'First Name'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Last Name'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: 'Job Title Optional'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Date Of Birth'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Full address',
                      style: TextStyle(
                        fontSize: fontSize * 18,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Street no'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'City'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Country'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Postal Code'),
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Job Info',
                      style: TextStyle(
                        fontSize: fontSize * 18,
                      ),
                    ),
                    //checkbox
                    DynamicallyCheckbox(),
                    AddTagsWidget(myLabel: 'add category'),
                    SizedBox(height: screenHeight * 0.02),
                    // TxtFomrField(txt: 'Job Descriptions'),
                    _buildJobDescriptionField(),
                    SizedBox(height: screenHeight * 0.02),
                    LanguagesCheckBox(),
                    AddTagsWidget(myLabel: 'add Language'),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
              //
              Center(
                child: Container(
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: fontSize * 17,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xffff6e01),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDescriptionField() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        minLines: 1,
        maxLines: 8,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: 'Add description of the Job',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

///checkbox widget
class DynamicallyCheckbox extends StatefulWidget {
  @override
  DynamicallyCheckboxState createState() => new DynamicallyCheckboxState();
}

class DynamicallyCheckboxState extends State {
  Map<String, bool> List = {
    'Mobile': false,
    'AC': false,
    'Elevator': false,
    'Refrigerator Repair Services': false,
    'Plumbing': false,
  };

  var holder_1 = [];

  getItems() {
    List.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });
    // Printing all selected items on Terminal screen.
    print(holder_1);

    // Here you will get all your selected Checkbox items.
    // Clear array after use.

    holder_1.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            'Select Categories',
            style: TextStyle(
              fontSize: 17,
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
      ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: List[key],
            activeColor: Color(0xffff6e01),
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                List[key] = value!;
              });
            },
          );
        }).toList(),
      ),
    ]);
  }
}

//languges
class LanguagesCheckBox extends StatefulWidget {
  @override
  LanguagesCheckBoxState createState() => new LanguagesCheckBoxState();
}

class LanguagesCheckBoxState extends State {
  Map<String, bool> List = {
    'English': false,
    'German': false,
    'Spanish': false,
    'French': false,
    'Arabic': false,
  };

  var holder_1 = [];

  getItems() {
    List.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(holder_1);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    holder_1.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: ElevatedButton(
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (ctx) => CustomerNavBar()));
          },
          child: Text(
            'Select Language',
            style: TextStyle(
              fontSize: 17,
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
      ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: List[key],
            activeColor: Color(0xffff6e01),
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                List[key] = value!;
              });
            },
          );
        }).toList(),
      ),
    ]);
  }
}

///tags
class AddTagsWidget extends StatefulWidget {
  String myLabel;
  AddTagsWidget({Key? key, required this.myLabel}) : super(key: key);

  @override
  _AddTagsWidgetState createState() => _AddTagsWidgetState();
}

class _AddTagsWidgetState extends State<AddTagsWidget> {
  final List? tags = [];
  final _globalKey = GlobalKey<TagsState>();
  @override
  Widget build(BuildContext context) {
    return Tags(
      key: _globalKey,
      itemCount: tags!.length,
      columns: 6,
      textField: TagsTextField(
          autofocus: false,
          hintText: widget.myLabel,
          textStyle: TextStyle(fontSize: 14),
          onSubmitted: (string) {
            setState(() {
              tags!.add(Item(title: string));
            });
          }),
      itemBuilder: (index) {
        final Item currentItem = tags![index];
        return ItemTags(
          index: index,
          title: currentItem.title!,
          customData: currentItem.customData,
          textStyle: TextStyle(fontSize: 14),
          combine: ItemTagsCombine.withTextBefore,
          removeButton: ItemTagsRemoveButton(onRemoved: () {
            setState(() {
              tags!.removeAt(index);
            });
            return true;
          }),
        );
      },
    );
  }
}
