import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:octbs_ui/controller/ServicesResponse.dart';
import 'package:octbs_ui/controller/api/apiservices.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/sign_up/customer_sign_up_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/created_profile_login.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_membership_screen.dart';
import 'package:octbs_ui/screens/users/services_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}
bool isEdit = false;

class _EditProfilePageState extends State<EditProfilePage> {
  List selectedServices = [];




  var pickedDate;
  DateTime dateTime = DateTime.now();
  TextEditingController AgeController = TextEditingController();
  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      pickedDate=picked;
      //assign the chosen date to the controller
      AgeController.text = DateFormat.yMd().format(dateTime);
    }
  }

  var country_code = '';
  var country_name = '';
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController countryController = TextEditingController();
  String? selectedSpinnerItem;

  List date = [];
  Future? myFuture;
  final String uri = 'https://admin.octo-boss.com/API/Services.php';
  Future<ServicesResponse> getPostServiceApi() async {
    final response = await http.get(Uri.parse(uri));
    var data = jsonDecode(response.body.toString());

    setState(() {
      date = data['data'];
      var xx = {'product_name': 'Others'};
      date.add(xx);
    });

    if (response.statusCode == 201) {
      return ServicesResponse.fromJson(date);
    } else {
      return ServicesResponse.fromJson(date);
    }
  }

  @override
  void initState() {

    setState(() {
      profile_data;
      checkProfileStatus;
    });
    super.initState();
  }


  final ImagePicker _Pickerr = ImagePicker();
  List<XFile>? imageFileList = [];
  List<XFile>? imageFileList_work = [];
  dynamic pickImageError;
  dynamic pickImageError_work;
  List<Asset> images = <Asset>[];
  List<Asset> image1 = <Asset>[];
  String _error = 'No Error Dectected';
  bool change = false;

  Widget buildGridView1() {
    if(isEdit==false){
      return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,

        children: List.generate(profile_data['certificate'].length, (index) {
          var asset = profile_data['certificate']![index]['image'];
          return Container(
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned(
                child: Image.network(
                  profile_data['certificate'][index]['image'].toString(),
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
            ]),
          );
        }),
      );
    }
    if(isEdit==true && imageFileList!=null){
      return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        children: List.generate(imageFileList!.length??0, (index) {
          var asset = imageFileList![index];
          return Container(
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned(
                child: Image.file(
                  File(imageFileList![index]!.path).absolute,
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 2,
                  left: 80,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          imageFileList!.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.red))),
            ]),
          );
        }),
      );
    }
    else{
      return Text('');
    }


  }
  Widget buildGridView() {
    if(isEdit==false){
     return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        children: List.generate(profile_data['work_picture'].length, (index) {
          var asset = profile_data['work_picture']![index]['image'];
          return Container(
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned(
                child:  Image.network(
                  profile_data['work_picture'][index]['image'].toString(),
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
            ]),
          );
        }),
      );
    }
    if(isEdit==true && imageFileList!=null){
      return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        children: List.generate(imageFileList_work!.length, (index) {
          var asset = imageFileList_work![index];
          return Container(
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned(
                child: Image.file(
                  File(imageFileList_work![index]!.path).absolute,
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 2,
                  left: 80,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          imageFileList_work!.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.red))),
            ]),
          );
        }),
      );
    }
    else{
      return Text('');
    }
  }

  Future<void> loadAssets1() async {
    List<Asset> resultList1 = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList1 = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: image1,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      image1 = resultList1;
      _error = error;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),

        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });

  }

  PickedFile? _imagefile;


  final ImagePicker _picker = ImagePicker();

  String? problem;
  bool showPassword = false;

  final ImagePicker picker = ImagePicker();

  File? imageLink;
  String imageUrl = '';
  String name = '';
  String lname = '';
  String phone = '';
  String streetAddress = '';
  String postalCode = '';
  String country = '';
  String street_number = '';
  String street_name = '';
  String unit_number = '';
  String city = '';
  String job_info = '';
  String language = '';
  String tags_services = '';
  String job_title = '';
  String detailed_description_of_services = '';
  String add_certificate = '';
  String add_work_pic = '';
  String dob = '';
  final ImagePicker multi_picker = ImagePicker();
  final ImagePicker multi_picker_work = ImagePicker();
  TextEditingController firstname = TextEditingController(text: profile_data['first_name'].toString());
  TextEditingController lastname = TextEditingController(text: profile_data['last_name'].toString());
  TextEditingController datebirth = TextEditingController();
  TextEditingController fullAddress = TextEditingController(text: profile_data['address'].toString());
  TextEditingController? emaill = TextEditingController(text: profile_data['email'].toString());
  TextEditingController streetno = TextEditingController(text: profile_data['street_no'].toString());
  TextEditingController streetname = TextEditingController(text: profile_data['street_name'].toString());
  TextEditingController streetaddress = TextEditingController(text: profile_data['street_address'].toString());
  TextEditingController unitno = TextEditingController(text: profile_data['unit_number'].toString());
  TextEditingController cityy = TextEditingController(text: profile_data['city'].toString());
  TextEditingController fname = TextEditingController();
  TextEditingController phoneno = TextEditingController(text: profile_data['phone'].toString());
  TextEditingController jobInfo = TextEditingController(text: profile_data['job_info'].toString());
  TextEditingController tagservices = TextEditingController(text: profile_data['tag_of_services'].toString());
  TextEditingController jobtitle = TextEditingController(text: profile_data['job_title'].toString());
  TextEditingController detaileddescription = TextEditingController(text: profile_data['detail_description'].toString());
  TextEditingController countryy = TextEditingController(text: profile_data['country'].toString());
  TextEditingController postalCodee = TextEditingController(text: profile_data['postal_code'].toString());
  TextEditingController countrycode = TextEditingController(text: profile_data['country'].toString());
  TextEditingController dobController = TextEditingController(text: profile_data['date_of_birth'].toString().split(' ').first);

  List servicesApi = profile_data['category'].toString().split(',');
  var languageApi = profile_data['language'].toString().split(',').toList();

  @override
  Widget build(BuildContext context) {

    bool selected = false;
    if (showPassword) {}
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Row(
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
                            print('Date ===$dateTime');
                            setState(() {
                              isEdit=false;
                            });
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
                  Center(
                    child: GestureDetector(
                      onTap: isEdit == false
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => Bottomsheet()),
                              );
                            },
                      child: Container(
                          height: 130,
                          width: 150,
                          child: imageLink == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(profile_data['picture'].toString(),fit: BoxFit.fill,)
                                  ),
                                )
                              : CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.file(
                                      File(imageLink!.path),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle)),
                    ),
                  ),
                  SizedBox(height: 35),
                  Visibility(
                    visible: isEdit ? false : true,
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEdit = !isEdit;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    child: FutureBuilder(
                      future: get_user_by_id(user_details['data']['id']),
                      builder: (context, snapshot) {
                      if(profile_data==null){
                        return CircularProgressIndicator();
                      }
                      else{
                        return Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              controller: firstname,
                              decoration: InputDecoration(
                                enabled: isEdit,
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'First Name'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  lname = value;
                                });
                              },
                              controller: lastname,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Last Name'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),

                            SizedBox(height: 35),
                            Visibility(
                              visible: !isEdit,
                              child: TextField(
                                enabled: false,
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: dobController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: 'Date of birth'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isEdit,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: AgeController,
                                decoration: InputDecoration(hintText: 'Date of Birth'.tr),
                                onTap: () => _selectDate(),
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: false,
                              controller: emaill,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Email'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),

                            SizedBox(
                              height: 35,
                            ),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              controller: fullAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Full Address'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  city = value;
                                });
                              },
                              controller: cityy,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'City'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),

                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  street_name = value;
                                });
                              },
                              controller: streetname,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Street Name'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  streetAddress = value;
                                });
                              },
                              controller: streetaddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Street Address'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  street_number = value;
                                });
                              },
                              controller: streetno,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Street Number'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),

                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  unit_number = value;
                                });
                              },
                              controller: unitno,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Unit Number'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            Visibility(
                              visible: isEdit,
                              child: TextFormField(
                                controller: countryController,
                                decoration: InputDecoration(
                                  prefixIcon: CountryListPick(
                                    initialSelection: '+1',
                                    theme: CountryTheme(
                                        labelColor: Colors.black,
                                        alphabetTextColor: Colors.black,
                                        alphabetSelectedTextColor: Colors.black,
                                        alphabetSelectedBackgroundColor: Colors.black,
                                        isShowFlag: true, //show flag on dropdown
                                        isShowTitle: false, //show title on dropdown
                                        isShowCode: true, //show code on dropdown
                                        isDownIcon: true),
                                    onChanged: (c) {
                                      setState(() {
                                        country_code = c.toString();
                                      });
                                    },
                                  ),
                                  hintText: 'Phone Number',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Visibility(
                              visible: !isEdit,
                              child: TextFormField(
                                enabled: false,
                                controller: phoneno,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: 'Phone Number'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              controller: jobtitle,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Job Title'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  job_info = value;
                                });
                              },
                              controller: jobInfo,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Job Info'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  detailed_description_of_services = value;
                                });
                              },
                              controller: detaileddescription,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Detailed Description'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            Visibility(
                              visible: !isEdit,
                              child: TextFormField(
                                enabled: isEdit,
                                controller: countrycode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: 'Country Code'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isEdit,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: CountryListPick(
                                  initialSelection: '+1',

                                  theme: CountryTheme(
                                      isShowFlag: true, //show flag on dropdown
                                      isShowTitle: true, //show title on dropdown
                                      isShowCode: false, //show code on dropdown
                                      isDownIcon: true),
                                  onChanged: (con) {
                                    setState(() {
                                      country_name = con.toString();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              enabled: isEdit,
                              onChanged: (value) {
                                setState(() {
                                  postalCode = value;
                                });
                              },
                              controller: postalCodee,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Postal Code'.tr,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 35),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    isEdit==false?'Certificates'.tr:'Add Certificates'.tr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: isEdit,
                                  child: IconButton(
                                      onPressed: () {
                                        addCertificates();
                                      },
                                      icon: Icon(
                                        Icons.file_upload_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                height: 130,
                                width: double.infinity,
                                child: SizedBox(height: 200, child: buildGridView1()),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade100,
                                )),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    isEdit==false?'Work Pictures'.tr:'Add work pictures'.tr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: isEdit,
                                  child: IconButton(
                                      onPressed: () {
                                         addWork();
                                      },
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.grey,
                                        size: 30,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                height: 130,
                                width: double.infinity,
                                child: SizedBox(height: 200, child: buildGridView()),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade100,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(
                                  isEdit==false?'Languages'.tr:'Select Language'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            isEdit==false?Wrap(
                              children: languageApi
                                  .map((e) => Chip(
                                label: Text(e),
                              ))
                                  .toList(),
                            ):Center(
                              child: Column(
                                children: [
                                  // use this button to open the multi-select dialog
                                  Container(
                                    decoration: BoxDecoration(border: Border.all()),
                                    child: TextButton(
                                      child: Text(
                                        'Please choose a language'.tr,
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                      onPressed: (){
                                        _showMultiSelect();
                                      },
                                    ),
                                  ),

                                  // display selected items
                                  Wrap(
                                    children: languageApi
                                        .map((e) => InkWell(
                                      onTap: (){
                                        languageApi.remove(e.toString());
                                      },
                                          child: Chip(
                                      label: Text(e),
                                    ),
                                        ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 35),
                            Row(
                              children: [
                                Text(
                                  isEdit==false?'Services Offered'.tr:'Please select services'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            isEdit==false?Wrap(
                              children: servicesApi
                                  .map((e) => Chip(
                                label: Text(e),
                              ))
                                  .toList(),
                            ):Center(
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
                                                    "Choose Services".tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  onChanged: (newVal) {

                                                    setState(() {
                                                      setState(() {
                                                        selectedSpinnerItem = newVal.toString();
                                                        selectedServices.add(selectedSpinnerItem);
                                                        servicesApi.add(selectedSpinnerItem);

                                                        selectedServices=selectedServices.toSet().toList();
                                                        servicesApi=servicesApi.toSet().toList();
                                                      });

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
                                                                    child: NameBottomSheet(),
                                                                  ),
                                                                )));
                                                      }
                                                    });
                                                  },
                                                  value: selectedSpinnerItem,
                                                ),
                                                Wrap(
                                                  children: servicesApi.toList()
                                                      .map((e) => InkWell(
                                                    onTap: (){
                                                      servicesApi.remove(e.toString());
                                                    },
                                                        child: Chip(
                                                    label: Text(e),
                                                  ),
                                                      ))
                                                      .toList(),
                                                )
                                              ]));
                                    })),

                          ],
                        );
                      }

                    },),
                  ),



                  SizedBox(
                    height: 35,
                  ),
                  Visibility(
                    visible: isEdit,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {

                          ApiServices().AddOctobossPictureandData(
                            fname: firstname.text.toString(),
                            lname: lastname.text.toString(),
                            dob: AgeController.text==''?dobController.text:dateTime.toString(),
                            fullAddress: fullAddress.text.toString(),
                            email: emaill!.text.toString(),
                            streetname: streetname.text.toString(),
                            streetAddress: streetaddress.text.toString(),
                            unitNumber: unitno.text.toString(),
                            city: cityy.text==''?profile_data['city'].toString():cityy.text.toString(),
                            phoneNumber: countryController.text.toString(),
                            jobInfo: jobInfo.text.toString(),
                            // tagsServices: tagservices.text.toString(),
                            tagsServices: '',
                            jobTitle: jobtitle.text.toString(),
                            detailedDescription: detaileddescription.text.toString(),
                            country: country_name==''?profile_data['country'].toString():country_name.toString(),
                            postalCode: postalCodee.text.toString(),
                            category: servicesApi.join(',').toString(),
                            language: languageApi.join(',').toString(),
                            streetnumber:streetno.text.toString(),
                            image: imageLink?.path,
                            certficate: imageFileList,
                            work_picture: imageFileList_work,
                          );
                          get_user_by_id(user_details['data']['id']);

                          if(checkProfile==true){
                            setState(() {
                              checkProfile=false;
                            });

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => OctoBossBottomNavBar()),
                                    (route) => false);
                          }
                          else{
                            setState(() {
                              isEdit=false;
                            });
                            Navigator.of(context).pop();

                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffff6e01)),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50)),
                            elevation: MaterialStateProperty.all(2),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)))

                        ),
                        child: Text(
                          "Submit".tr,
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );

  }
  addCertificates() async {
    try {
      final List<XFile>? pickedFileList = await multi_picker.pickMultiImage(
        imageQuality: 30,
      );
      setState(() {
        imageFileList = pickedFileList;
      });
    } catch (e) {
      setState(() {
        pickImageError = e;
      });
    }
  }

  addWork() async {
    try {
      final List<XFile>? pickedFileList = await multi_picker_work.pickMultiImage(
        imageQuality: 30,
      );
      setState(() {
        imageFileList_work = pickedFileList;
      });
    } catch (e) {
      setState(() {
        pickImageError_work = e;
      });
    }
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

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
        languageApi.addAll(results);
      });
    }
  }

  void getGalleryImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );
    setState(() {
      imageLink = File(image!.path);
    });
  }

  void getCameraImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      imageLink = File(image!.path);
    });
  }

  Widget Bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Chose profile photo",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    getCameraImage();
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera ")),
              ElevatedButton.icon(
                  onPressed: () {
                    getGalleryImage();
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery ")),
            ],
          ),
        ],
      ),
    );
  }



  get_user_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserById.php"),
        body: data2);
    if (response.statusCode == 201) {
      var resData=response.body.toString();
      var data1 = jsonDecode(resData);
      user_details=data1;

      final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setString('data', resData);

      profile_data = data1['data'];
      return profile_data;

    } else {
      return false;
    }
  }
}

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
