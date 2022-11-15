import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_screen_api.dart';
import 'package:octbs_ui/screens/users/Customer/customer_signin_screen.dart';
import 'package:octbs_ui/screens/users/Customer/sign_up/customer_sign_up_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Octoboss/octoboss_services_offered_screen_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octbs_ui/screens/users/Octoboss/select_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

var user_id=''.obs;
class ApiServices {
  var createIssueApi = "https://admin.octo-boss.com/API/CreateIssues.php";
  var verify_code='https://admin.octo-boss.com/API/VerifyUser.php';
  var register='https://admin.octo-boss.com/API/Signup.php';
  var ddd;

  createissue(String location, String description,String tags, String status,
      String language, String public_issue, var problem, var image) async {
    try {
      var uri = Uri.parse('https://admin.octo-boss.com/API/CreateIssues.php');
      var request = http.MultipartRequest("POST", uri);
      request.fields["title"] = location;
      request.fields["description"] = description;
      request.fields["tags"] = tags;
      request.fields["status"] = status;
      request.fields["languages"] = language;
      request.fields["issue_type"] = public_issue;
      request.fields["created_by"] = user_details['data']['id'];
      request.fields["problem"] = problem;

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'image',
        image.toString(),
      );
      request.files.add(multipartFile);
      var response = await request.send();
      if (response.statusCode == 201) {
        print('Create Issue = 201');
      } else {
        print('Create Issue = else');
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> customer_register(String firstname ,String lastname ,String date_of_birth ,String address ,String appartment_no ,String email ,String password ,String phone ,String street_address ,String country ,String postal_code ,String city ,String age  ,String type) async{

    try{
      var data={'first_name':firstname,'last_name':lastname,'email':email,'password':password,'phone':phone,'address':address,'country':country,'date_of_birth':date_of_birth,'appartment_no':appartment_no,'street_address':street_address,'city':city,'age':age,'postal_code':postal_code,'type':type};
      var data1=json.encode(data);
      var response=await post(Uri.parse(register),
          body: data1

      );
      if(response.statusCode==201){

        print('Register code : 201');
        var data2=jsonDecode(response.body.toString());
        user_id.value=data2['user_id'].toString();
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return false;
      }
      else{
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  giveValue(){
    checkProfileStatus='201';
  }

  Future<bool> octoboss_register(
      String firstname ,
      String lastname ,
      String email ,
      String password ,
      String phone,
      String age,
      String address,
      String country,
      String date_of_birth,
      String postal_code,
      String type) async{
    try{
      var data={'first_name':firstname,'last_name':lastname,'email':email,'password':password,'phone':phone,'age':age,'address':address,'country':country,'date_of_birth':date_of_birth,'postal_code':postal_code,'type':type};

      var data1=json.encode(data);
      var response=await post(Uri.parse(register),
          body: data1

      );
      if(response.statusCode==201){
        print('Register code : 201');
        var data2=jsonDecode(response.body.toString());
        user_id.value=data2['user_id'].toString();
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return false;
      }
      else{
        print('Register code : else');
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  verifyCode(String id,String code) async{
    try{
      var data={'user_id': id,'verification_code':code};
      var data1=json.encode(data);
      var response=await post(Uri.parse(verify_code),
          body: data1
      );
      if(response.statusCode==201){

        print('Verify Code : 201');
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: 'Verified');
        Get.offAll(CustomerSignInScreen());
        return true;
      }
      else{
        print('Verify Code : else');
        var data2=jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: '${data2['message'].toString()}');
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  custmrprofile(
      String name,
      String email,
      String phonenumber,
      String streetAddress,
      // String country,
      String postalCode,
      String rating,
      var img
      ) async {
    var customerprofile =
        "https://admin.octo-boss.com/API/AddCustomerProfile.php";

    var request = http.MultipartRequest("POST", Uri.parse(customerprofile));
    request.fields["user_id"] = user_details['data']['id'];
    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["phone_number"] = phonenumber;
    request.fields["street_address"] = streetAddress;
    request.fields["postal_code"] = postalCode;
    request.fields["rating"] = rating;

    if(img!=null) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'picture',
        img,
      );
      request.files.add(multipartFile);
    }
    var response = await request.send();
    if (response.statusCode == 201) {
      checkProfileStatus='201';
      print('I am in Customer Response (201)');
    }
    else {
      print('I am in Customer Response (200)');
    }

  }

  //apioctobossprofile
  var octobossprofile =
      "https://admin.octo-boss.com/API/AddOctobossProfile.php";

  octbossprofile(
      String fname,
      String lname,
      var dob,
      String fullAddress,
      String email,
      String streetnumber,
      String streetname,
      String streetAddress,
      String unitNumber,
      String city,
      String phoneNumber,
      String jobInfo,
      String tagsServices,
      String jobTitle,
      String detailedDescription,
      String country,
      String postalCode,
      ) async {
    var issuedata = {
      'first_name': fname,
      'last_name': lname,
      'date_of_birth': dob,
      'full_address': fullAddress,
      'email': email,
      'street_no': streetnumber,
      'street_name': streetname,
      'street_address': streetAddress,
      'unit_number': unitNumber,
      'city': city,
      'phone_number': phoneNumber,
      'job_info': jobInfo,
      'tag_of_services': tagsServices,
      'job_title': jobTitle,
      'detail_description': detailedDescription,
      'country': country,
      'email': email,
      'postal_code': postalCode
    };
    var issue_encode = json.encode(issuedata);
    final response = await post(Uri.parse(octobossprofile), body: issue_encode);

    if (response.statusCode == 201) {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response['message']);
    } else {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response);
    }
  }


   var StatusActive="https://admin.octo-boss.com/API/StatusUpdate.php";
  statusActive(String Status) async {
    var issuedata = {
      'status': Status,
    };
    var issue_encode = json.encode(issuedata);
    final response = await post(Uri.parse(StatusActive), body: issue_encode);

    if (response.statusCode == 200) {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response['message']);
    } else {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response);
    }
  }
  makeOnline(var userId,var status) async {
    var issuedata = {
      'user_id': userId,
      'status': status,
    };
    var issue_encode = json.encode(issuedata);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/UserLastSeen.php'),
        body: issue_encode);

    if (response.statusCode == 201) {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response['message']);
    } else {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response);
    }
  }

  user_by_id(var userId) async {
    var issuedata = {
      'user_id': userId,
    };
    var issue_encode = json.encode(issuedata);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/GetUserById.php'),
        body: issue_encode);

    if (response.statusCode == 201) {
      var issue_response = jsonDecode(response.body.toString());
      profile_data=issue_response['data'];
      if(issue_response['data']['block']=='1'){
        Fluttertoast.showToast(msg: 'Your account is blocked');
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.remove('role');
        pref.remove('data');
        user_details=null;
        Get.offAll(SelectPage());
      }
      print(issue_response['message']);
      return issue_response['data'];
    } else {
      var issue_response = jsonDecode(response.body.toString());
      Get.snackbar('Message', '${issue_response['message'].toString()}');
      print(issue_response);
    }
  }

  toggleStatus_userById(var userId) async {
    var issuedata = {
      'user_id': userId,
    };
    var issue_encode = json.encode(issuedata);
    final response = await post(Uri.parse('https://admin.octo-boss.com/API/GetUserById.php'),
        body: issue_encode);

    if (response.statusCode == 201) {
      var issue_response = jsonDecode(response.body.toString());
      var data= issue_response['data']['is_online'];
      if(data=='1'){
        togglemove=true;
        return true;
      }
      else{
        togglemove=false;
        return false;
      }
    } else {
      var issue_response = jsonDecode(response.body.toString());
      togglemove=false;
      return false;
    }
  }



  Membership_by_id(var id) async {
    var data = {'user_id': id};
    var data2 = json.encode(data);
    var response = await post(
        Uri.parse("https://admin.octo-boss.com/API/GetUserPlanById.php"),
        body: data2);
    var data1 = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      print('Membership by Id : 201');
      var data1 = jsonDecode(response.body.toString());
      return data1['data'];
    } else {
      print ('Membership by Id : 200');
      return null;
    }
  }

  AddOctobossPictureandData(
  {var image,
      var fname,
      var lname,
      var dob,
      var fullAddress,
      var email,
      var streetnumber,
      var streetname,
      var streetAddress,
      var unitNumber,
      var city,
      var phoneNumber,
      var jobInfo,
      var tagsServices,
      var jobTitle,
      var detailedDescription,
      var country,
      var postalCode,
      var category,
      var language,
      var certficate,
      var work_picture}
      ) async {
    try {
      var uri =
      Uri.parse('https://admin.octo-boss.com/API/AddOctobossProfile.php');
      var request = http.MultipartRequest("POST", uri);
      //add text fields
      print('I am in Octoboss Profile : ${certficate}\n');
      request.fields["user_id"] = user_details['data']['id'];
      request.fields["first_name"] = fname;
      request.fields["last_name"] = lname;
      request.fields["date_of_birth"] = dob;
      request.fields["full_address"] = fullAddress;
      request.fields["email"] = email;
      request.fields["street_no"] = streetnumber;
      request.fields["street_name"] = streetname;
      request.fields["street_address"] = streetAddress;
      request.fields["unit_number"] = unitNumber;
      request.fields["city"] = city;
      request.fields["phone_number"] = phoneNumber;
      request.fields["job_info"] = jobInfo;
      request.fields["tag_of_services"] = tagsServices;
      request.fields["job_title"] = jobTitle;
      request.fields["detail_description"] = detailedDescription;
      request.fields["country"] = country;
      request.fields["postal_code"] = postalCode;
      request.fields["category"] = category;
      request.fields["language"] = language;
      request.fields["message_type"] = 'image';

      if(image!=null){
        http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
          'picture',
          image,
        );
        request.files.add(multipartFile2);
      }

      if(certficate!=null){
      for(int i=0;certficate.length>i;i++){
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'certificate[]',
          certficate[i].path,
        );
        request.files.add(multipartFile);
      }
      }

      if(work_picture!=null){
      for(int i=0;work_picture.length>i;i++){
        http.MultipartFile multipartFile1 = await http.MultipartFile.fromPath(
          'work_picture[]',
          work_picture[i].path,
        );
        request.files.add(multipartFile1);
      }}

      var response = await request.send();
      if (response.statusCode == 201) {
       checkProfileStatus='201';
        print('I am in Octoboss Response (201)');
      }
      else {
        checkProfileStatus='200';
        print('I am in Octoboss Response (200)');
      }
      print('response : $response');
    } catch (e) {
      print("error=$e");
      return false;
    }
  }

  Future<void> uploadImage(var image) async{

    var stream= await http.ByteStream(image!.openRead());
    stream.cast();
    var length=await image!.length();
    var uri=Uri.parse(createIssueApi);
    var request=http.MultipartRequest('POST',uri);
    request.fields['title']='Mazhar Nadeem';
    var  multiport=http.MultipartFile('picture',stream,length);
    request.files.add(multiport);
    var response=await request.send();
    if(response.statusCode==201){
      print('Image Upload Successfully');
      Fluttertoast.showToast(msg: 'Image Upload Successfully');
    }
    else{
      Fluttertoast.showToast(msg: 'Image Upload Failed');
      print('Image Upload Failed');
    }

  }
}
