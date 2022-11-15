import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:octbs_ui/Model/servicesModel.dart';
import 'package:octbs_ui/controller/ServicesResponse.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_screen_api.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_topbar.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issues_list_screen.dart';
import 'package:octbs_ui/screens/users/services_bottom_sheet.dart';

var problem_list = [];
Future<AddIssue> createIssues(
    String location,
    String description,
    String tag,
    String status,
    String problem,
    String language,
    String image,
    String review,
    String addrating) async {
  final response = await http.post(
    Uri.parse('https://admin.octo-boss.com/API/CreateIssues.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'location': location,
      'description': description,
      'tags': tag,
      'status': status,
      'problem': problem,
      'language': language,
      'image': image,
      'review': review,
      'addrating': addrating
    }),
  );
  if (response.statusCode == 200) {
    return AddIssue.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Issues.');
  }
}

class AddIssue {
  final String location;
  final String description;
  final String tags;
  final String status;
  final String problem;
  final String language;
  final String image;
  final String review;
  final int addrating;

  const AddIssue(
      {required this.location,
      required this.description,
      required this.tags,
      required this.status,
      required this.problem,
      required this.language,
      required this.image,
      required this.review,
      required this.addrating});

  factory AddIssue.fromJson(Map<String, dynamic> json) {
    return AddIssue(
        location: json['location'],
        description: json['description'],
        tags: json['tags'],
        status: json['status'],
        problem: json['problem'],
        language: json['language'],
        image: json['image'],
        review: json['review'],
        addrating: json['addrating']);
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

class CustomerAddIssueScreen extends StatefulWidget {
  const CustomerAddIssueScreen({Key? key}) : super(key: key);

  @override
  _CustomerAddIssueScreenState createState() => _CustomerAddIssueScreenState();
}

class _CustomerAddIssueScreenState extends State<CustomerAddIssueScreen> {
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  double rate = 0;
  File? imageLink;
  var pro = problem_list.toString();

  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> _items = [
      "Afrikaans",
      "Afrikaans (South Africa)",
      "Arabic",
      "Arabic (U.A.E.)",
      "Arabic (Bahrain)",
      "Arabic (Algeria)",
      "Arabic (Egypt)",
      "Arabic (Iraq)",
      "Arabic (Jordan)",
      "Arabic (Kuwait)",
      "Arabic (Lebanon)",
      "Arabic (Libya)",
      "Arabic (Morocco)",
      "Arabic (Oman)",
      "Arabic (Qatar)",
      "Arabic (Saudi Arabia)",
      "Arabic (Syria)",
      "Arabic (Tunisia)",
      "Arabic (Yemen)",
      "Azeri (Latin)",
      "Azeri (Latin) (Azerbaijan)",
      "Azeri (Cyrillic) (Azerbaijan)",
      "Belarusian",
      "Belarusian (Belarus)",
      "Bulgarian",
      "Bulgarian (Bulgaria)",
      "Bosnian (Bosnia and Herzegovina)",
      "Catalan",
      "Catalan (Spain)",
      "Czech",
      "Czech (Czech Republic)",
      "Welsh",
      "Welsh (United Kingdom)",
      "Danish",
      "Danish (Denmark)",
      "German",
      "German (Austria)",
      "German (Switzerland)",
      "German (Germany)",
      "German (Liechtenstein)",
      "German (Luxembourg)",
      "Divehi",
      "Divehi (Maldives)",
      "Greek",
      "Greek (Greece)",
      "English",
      "English (Australia)",
      "English (Belize)",
      "English (Canada)",
      "English (Caribbean)",
      "English (United Kingdom)",
      "English (Ireland)",
      "English (Jamaica)",
      "English (New Zealand)",
      "English (Philippines)",
      "English (Trinidad and Tobago)",
      "English (United States)",
      "English (South Africa)",
      "English (Zimbabwe)",
      "Esperanto",
      "Spanish",
      "Spanish (Argentina)",
      "Spanish (Bolivia)",
      "Spanish (Chile)",
      "Spanish (Colombia)",
      "Spanish (Costa Rica)",
      "Spanish (Dominican Republic)",
      "Spanish (Ecuador)",
      "Spanish (Castilian)",
      "Spanish (Spain)",
      "Spanish (Guatemala)",
      "Spanish (Honduras)",
      "Spanish (Mexico)",
      "Spanish (Nicaragua)",
      "Spanish (Panama)",
      "Spanish (Peru)",
      "Spanish (Puerto Rico)",
      "Spanish (Paraguay)",
      "Spanish (El Salvador)",
      "Spanish (Uruguay)",
      "Spanish (Venezuela)",
      "Estonian",
      "Estonian (Estonia)",
      "Basque",
      "Basque (Spain)",
      "Farsi",
      "Farsi (Iran)",
      "Finnish",
      "Finnish (Finland)",
      "Faroese",
      "Faroese (Faroe Islands)",
      "French",
      "French (Belgium)",
      "French (Canada)",
      "French (Switzerland)",
      "French (France)",
      "French (Luxembourg)",
      "French (Principality of Monaco)",
      "Galician",
      "Galician (Spain)",
      "Gujarati",
      "Gujarati (India)",
      "Hebrew",
      "Hebrew (Israel)",
      "Hindi",
      "Hindi (India)",
      "Croatian",
      "Croatian ()",
      "Croatian (Croatia)",
      "Hungarian",
      "Hungarian (Hungary)",
      "Armenian",
      "Armenian (Armenia)",
      "Indonesian",
      "Indonesian (Indonesia)",
      "Icelandic",
      "Icelandic (Iceland)",
      "Italian",
      "Italian (Switzerland)",
      "Italian (Italy)",
      "Japanese",
      "Japanese (Japan)",
      "Georgian",
      "Georgian (Georgia)",
      "Kazakh",
      "Kazakh (Kazakhstan)",
      "Kannada",
      "Kannada (India)",
      "Korean",
      "Korean (Korea)",
      "Konkani",
      "Konkani (India)",
      "Kyrgyz",
      "Kyrgyz (Kyrgyzstan)",
      "Lithuanian",
      "Lithuanian (Lithuania)",
      "Latvian",
      "Latvian (Latvia)",
      "Maori",
      "Maori (New Zealand)",
      "FYRO Macedonian",
      "FYRO Macedonian (Macedonia)",
      "Mongolian",
      "Mongolian (Mongolia)",
      "Marathi",
      "Marathi (India)",
      "Malay",
      "Malay (Brunei Darussalam)",
      "Malay (Malaysia)",
      "Maltese",
      "Maltese (Malta)",
      "Norwegian (Bokm?l)",
      "Norwegian (Bokm?l) (Norway)",
      "Dutch",
      "Dutch (Belgium)",
      "Dutch (Netherlands)",
      "Norwegian (Nynorsk) (Norway)",
      "Northern Sotho",
      "Northern Sotho (South Africa)",
      "Punjabi",
      "Punjabi (India)",
      "Polish",
      "Polish (Poland)",
      "Pashto",
      "Pashto (Afghanistan)",
      "Portuguese",
      "Portuguese (Brazil)",
      "Portuguese (Portugal)",
      "Quechua",
      "Quechua (Bolivia)",
      "Quechua (Ecuador)",
      "Quechua (Peru)",
      "Romanian",
      "Romanian (Romania)",
      "Russian",
      "Russian (Russia)",
      "Sanskrit",
      "Sanskrit (India)",
      "Sami (Northern)",
      "Sami (Northern) (Finland)",
      "Sami (Skolt) (Finland)",
      "Sami (Inari) (Finland)",
      "Sami (Northern) (Norway)",
      "Sami (Lule) (Norway)",
      "Sami (Southern) (Norway)",
      "Sami (Northern) (Sweden)",
      "Sami (Lule) (Sweden)",
      "Sami (Southern) (Sweden)",
      "Slovak",
      "Slovak (Slovakia)",
      "Slovenian",
      "Slovenian (Slovenia)",
      "Albanian",
      "Albanian (Albania)",
      "Serbian (Latin) ()",
      "Serbian (Cyrillic) ()",
      "Serbian (Latin) ()",
      "Serbian (Cyrillic) ()",
      "Swedish",
      "Swedish (Finland)",
      "Swedish (Sweden)",
      "Swahili",
      "Swahili (Kenya)",
      "Syriac",
      "Syriac (Syria)",
      "Tamil",
      "Tamil (India)",
      "Telugu",
      "Telugu (India)",
      "Thai",
      "Thai (Thailand)",
      "Tagalog",
      "Tagalog (Philippines)",
      "Tswana",
      "Tswana (South Africa)",
      "Turkish",
      "Turkish (Turkey)",
      "Tatar",
      "Tatar (Russia)",
      "Tsonga",
      "Ukrainian",
      "Ukrainian (Ukraine)",
      "Urdu",
      "Urdu (Islamic Republic of Pakistan)",
      "Uzbek (Latin)",
      "Uzbek (Latin) (Uzbekistan)",
      "Uzbek (Cyrillic) (Uzbekistan)",
      "Vietnamese",
      "Vietnamese (Viet Nam)",
      "Xhosa",
      "Xhosa (South Africa)",
      "Chinese",
      "Chinese (S)",
      "Chinese (Hong Kong)",
      "Chinese (Macau)",
      "Chinese (Singapore)",
      "Chinese (T)",
      "Zulu",
      "Zulu (South Africa)"
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: _items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  Future<AddIssue>? _futureIssues;

  TextEditingController reviewController = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tags = TextEditingController();
  TextEditingController statusController = TextEditingController(text: 'pending'.tr);
  String? problem;
  String? language;
  String imageUrl = '';
  var lll = ['hllo', 'sdf', 'sdf', '23'];
  var status = true;
  var public_issue = 'public';

  List selectedServices = [];
  String? selectedSpinnerItem;
  List date = [];
  final String uri = 'https://admin.octo-boss.com/API/Services.php';
  Future<ServicesResponse> getPostServiceApi() async {
    final response = await http.get(Uri.parse(uri));
    var data = jsonDecode(response.body.toString());

    setState(() {
      date = data['data'];
      var xx = {'product_name': 'Others'};
    });

    if (response.statusCode == 201) {
      return ServicesResponse.fromJson(date);
    } else {
      return ServicesResponse.fromJson(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),

              Text(
                'Add Issue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
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
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: location,
                keyboardType: TextInputType.streetAddress,
                cursorColor: Color(0xffff6e01),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.location_on,
                    color: Color(0xffff6e01),
                  ),
                  labelText: 'Location'.tr,
                  labelStyle: TextStyle(color: Color(0xffff6e01)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff6e01)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: description,
                maxLines: 2,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xffff6e01),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xffff6e01),
                  ),
                  labelText: 'Description'.tr,
                  labelStyle: TextStyle(color: Color(0xffff6e01)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff6e01)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: tags,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xffff6e01),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.tag,
                    color: Color(0xffff6e01),
                  ),
                  labelText: 'Tags'.tr,
                  hintText: 'phone, camera, painting',
                  counterText: 'Enter tags separated by comma ( , )'.tr,
                  labelStyle: TextStyle(color: Color(0xffff6e01)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff6e01)),
                  ),
                ),
              ),
              // SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: statusController,
                enabled: false,
                maxLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xffff6e01),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.toggle_off,
                    color: Color(0xffff6e01),
                  ),
                  labelText: 'Status'.tr,
                  labelStyle: TextStyle(color: Color(0xffff6e01)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff6e01)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text('Public issue'.tr),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: FlutterSwitch(
                        width: 105.0,
                        height: 35.0,
                        valueFontSize: 15.0,
                        toggleSize: 45.0,
                        value: status,
                        activeColor: Colors.orange,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                            if (status) {
                              public_issue = 'public';
                            } else {
                              public_issue = 'private';
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                  child: FutureBuilder(
                      future: getPostServiceApi(),
                      builder: (context, snapshot) {
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              DropdownButton(
                                items: date.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['product_name']),
                                    value: item['product_name'],
                                  );
                                }).toList(),
                                hint: Text(
                                  'Choose problem'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (newVal) {
                                  setState(() {
                                      selectedSpinnerItem = newVal.toString();

                                      if (selectedSpinnerItem != 'Others') {
                                        selectedServices.add(selectedSpinnerItem);
                                        selectedServices=selectedServices.toSet().toList();
                                        print('Selected Services : $selectedServices');
                                      }

                                    if (selectedSpinnerItem == 'Others') {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          context: context,
                                          builder: ((context) =>
                                              SingleChildScrollView(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: NameBottomSheet1(),
                                                ),
                                              )));
                                    }
                                  });
                                },
                                value: selectedSpinnerItem,
                              ),
                              Wrap(
                                children: selectedServices.toSet().toList()
                                    .map((e) => InkWell(
                                  onTap: (){
                                    selectedServices.remove(e.toString());
                                  },
                                      child: Chip(
                                            label: Text(e),
                                          ),
                                    ))
                                    .toList(),
                              )
                            ]));
                      })),

              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Column(
                  children: [
                    // use this button to open the multi-select dialog
                    TextButton(
                      child: Text('Please choose a language'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: _showMultiSelect,
                    ),
                    const Divider(
                      height: 30,
                    ),
                    // display selected items
                    Wrap(
                      children: _selectedItems
                          .map((e) => Chip(
                                label: Text(e),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(height: screenHeight * 0.03),
              imageLink == null
                  ? TextButton(
                      style: TextButton.styleFrom(primary: Colors.grey),
                      onPressed: () {
                        showImagePicker(context);
                      },
                      child: Text('Choose image'.tr),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        File(imageLink!.path).absolute,
                        fit: BoxFit.cover,
                      ),
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
                          image: NetworkImage(''),
                        ),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    ApiServices().createissue(
                        location.text.toString(),
                        description.text.toString(),
                        tags.text.toString(),
                        statusController.text.toString(),
                        _selectedItems.join(',').toString(),
                        public_issue,
                        selectedServices.join(',').toString(),
                        imageLink!.path);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerIssuesTopBar()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffff6e01)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))

                  ),
                  child: Text(
                    "Save".tr,
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                      'Photo library',
                      // 'Гэрэл зургийн номын сан'
                    ),
                    onTap: () {
                      getImageGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'Camera',
                    // 'Камер'
                  ),
                  onTap: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void getImageCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    setState(() {
      imageLink = File(image!.path);
    });
  }

  void getImageGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    setState(() {
      imageLink = File(image!.path);
    });
  }

  openCameraImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.camera);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string = base64.encode(imagebytes); //convert bytes to base64 string
        Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes

        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }
Widget NameBottomSheet1(){
  String? serviceName;
  var serviceController=TextEditingController();
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Form(
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              cursorColor: Color(0xffff6e01),
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
                onPressed: () {
                  if(serviceController!=''){
                    selectedServices.add(serviceController.text);
                    Navigator.pop(context);
                  }
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
}
