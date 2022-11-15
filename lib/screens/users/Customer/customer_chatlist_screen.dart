import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';
import 'package:octbs_ui/controller/notification_api.dart';
import 'package:octbs_ui/screens/users/Customer/chat_list.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/emoji.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'customer_issue_list_screen_api.dart';
import 'package:timezone/timezone.dart' as tz;


class CustomerChatListScreen extends StatefulWidget {
  const CustomerChatListScreen({Key? key}) : super(key: key);

  @override
  _CustomerChatListScreenState createState() => _CustomerChatListScreenState();
}

class _CustomerChatListScreenState extends State<CustomerChatListScreen> {
  String? chatID;
  var messageController=TextEditingController();
  var messages=[];
  var unOrder=[];
  var sort_messages=[];
  File? imageLink;

  bool visibility_attach=true;
  bool visibility_timer=false;
  var offerdata;

  //Audio player
  final audioPlayer=AudioPlayer();
  bool isPlaying=false;
  bool downloading=false;

  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  String? status;
  TimeOfDay? pickedTime;
  var timeController=TextEditingController();
  var dateController=TextEditingController();
  var priceController=TextEditingController();
  var durationController=TextEditingController();


  //Audio Record
  final recorder=FlutterSoundRecorder();
  DateTime dateTime = DateTime.now();
  var sender;
  var receiver;
  String? selectedSpinnerItem;
  var offerissue;
  var canceloffer;


  var progressString = "";
  var remvalue;
  var totvalue;

  sendMessage(String senderId ,String receiverId ,String message) async{
     try{

      var data={'sender_id':senderId,'receiver_id':receiverId,'message':message,'message_type':'message'};

      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  updateOfferStatus(var offerId ,var status,{var issueId,var offercancel,var time,var date}) async{
     try{

      var data={'chat_id':offerId,'status':status};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/UpdateChatStatus.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Offer Successfully Updated : 201');
        var data2=jsonDecode(response.body.toString());
        if(data2['data']['approved'].toString().toLowerCase()=='approved'){
          offer_details=data2['data'];
          updateIssueStatus(issueId, 'processing');
          updateApprovedOffers('approved', offerId,time: time,date: date);
        }
        if(data2['data']['approved'].toString().toLowerCase()=='cancel'){
          if(offercancel=='canceloffer'){
            updateIssueStatus(issueId, 'pending');
            deleteoffer(canceloffer['id']);
          }
        }
        return true;
      }
      else if(response.statusCode==200){
        print('Offer Updated Failed: 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  deleteoffer(var offerId) async{
    try{

      var data={'offer_id':offerId};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/DeleteOfferById.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Offer Deleted : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Offer Deleted : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Offer Deleted : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  updateIssueStatus(var issueId ,var status) async{
    try{
      var data={'id':issueId,'user_id':user_details['data']['id'],'status':status};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/UpdateIssueStatus.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Issue Successfully Updated : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Issue Updated Failed: 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Issue Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  updateApprovedOffers(var status ,var chatId,{var time,var date}) async{
    try{
      var data={
        'sender_id':user_details['data']['id'],
        'receiver_id':get_receiverId.toString(),
        'approved':status,
        'offer_id':chatId,
        'date':date,
        'time':time

      };
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ApprovedOffers.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Approved Offer Updated : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Approved Offer Updated: 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Approved Offer Updated : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  sendIssue(String senderId ,String receiverId ,var problem,var description,var location,var language) async{
     try{

      var data={
        'sender_id':senderId,
        'receiver_id':receiverId,
        'message_type':'issue',
        'problem':problem,
        'description':description,
        'location':location,
        'language':language
      };

      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  sendOffer(String senderId ,String receiverId ,var time,var date,var price,var duration) async{
     try{

      var data={
        'sender_id':senderId,
        'receiver_id':receiverId,
        'message_type':'offer',
        'time':time,
        'date':date,
        'price':price,
        'duration':duration,
        'approved':'pending',
        'issue_id':offerissue['id'],
        'problem':offerissue['problem'],
        'language':offerissue['languages'],
        'description':offerissue['description'],
        'location':offerissue['title'],
      };
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  sendContact(String senderId ,String receiverId ,String contactName,String contactNo) async{
     try{
      var data={
        'sender_id':senderId,
        'receiver_id':receiverId,
        'message_type':'contact',
        'contact_name':contactName,
        'contact_no':contactNo
      };

      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  sendVoice(String senderId ,String receiverId ,var voice) async{
    try{
      var data={'sender_id':senderId,
        'receiver_id':receiverId,
        'message':'voice','message_type':'audio','image':voice};
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  sendPhoto(String senderId ,String receiverId ,var image) async{
    try{
      var image2=image.readAsBytesSync();
      var data={'sender_id':senderId,'receiver_id':receiverId,'message_type':'image', 'file':await image2.toString(),};
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/SendMessage.php'),
          body: data
      );
      if(response.statusCode==201){
        print('Message Send Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  sendPicture(String senderId ,String receiverId ,var image) async{
    try{
      var uri=Uri.parse('https://admin.octo-boss.com/API/SendMessage.php');
      var request = http.MultipartRequest("POST", uri);
          //add text fields
      request.fields["sender_id"] = senderId;
      request.fields["receiver_id"] = receiverId;
      request.fields["message_type"] = 'image';

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'file', image);

      request.files.add(multipartFile);
      var response = await request.send();

    }catch(e){
      return false;
    }
  }

  sendAudio(String senderId ,String receiverId ,var audio) async{
    try{
      var uri=Uri.parse('https://admin.octo-boss.com/API/SendMessage.php');
      var request = http.MultipartRequest("POST", uri);
      //add text fields
      request.fields["sender_id"] = senderId;
      request.fields["receiver_id"] = receiverId;
      request.fields["message_type"] = 'audio';

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'file', audio);
      request.files.add(multipartFile);
      var response = await request.send();
    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  sendDocument(String senderId ,String receiverId ,var document) async{
    try{
      var uri=Uri.parse('https://admin.octo-boss.com/API/SendMessage.php');
      var request = http.MultipartRequest("POST", uri);
      //add text fields
      request.fields["sender_id"] = senderId;
      request.fields["receiver_id"] = receiverId;
      request.fields["message_type"] = 'document';

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'file', document);

      request.files.add(multipartFile);
      var response = await request.send();

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  readChat(var senderId,var receiverId) async{
    try{
      var data={'sender_id':senderId,'receiver_id':receiverId,};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ReadChat.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Message Read : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Message Read : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Read : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  deleteChat(var senderId,var receiverId) async{
    try{
      var data={'sender_id':senderId,'receiver_id':receiverId,};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/DeleteChatByUserId.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Messages Deleted : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Messages Deleted : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Messages Deleted : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future<File?> downloadFile(String url,String name) async {

    try{
      Dio dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final file=File('${dir.path}/$name');
      final response=await Dio().get(
          url,
          onReceiveProgress: ((count, total) {
            setState(() {
              downloading = true;
              progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
            });
          }
          ),
          options: Options(responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      final raf=file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      setState(() {
        downloading=false;
      });
      return file;

    }
    catch(e)
    {  print(e.toString());
    return null; }
  }

  Future<File?> openFile(String url,String fileName) async {
    final file=await downloadFile(url, fileName);
    if(file==null){
      return null;
    }
    else{
      OpenFile.open(file.path);
    }
    try{}
    catch(e)
    {  print(e.toString());
    return null; }
  }

  messageList(String receiverId) async{
    try{
      var data={'receiver_id':receiverId};

      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ChatList.php'),
          body: data1
      );
      if(response.statusCode==201){
        sort_messages.clear();
        print('Message List Successfully : 201');
        var data2=jsonDecode(response.body.toString());
        unOrder=data2['data'];
        var chhh=unOrder;
        var len=unOrder.length;

        for(int m=0;len>m;m++){
          if(m<chhh.length){
            if((chhh[m]['receiver_id']==get_receiverId.toString() && chhh[m]['sender_id']==user_details['data']['id']) || (chhh[m]['receiver_id']==user_details['data']['id'] && chhh[m]['sender_id']==get_receiverId.toString()))
            {
              sort_messages.add(chhh[m]);
            }
          }
        }

        messages=sort_messages.reversed.toList();
        setState(() {});
        return true;
      }
      else if(response.statusCode==200){
        print('Register code : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Message Send Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }
  offerList(String receiverId,var chatId) async{
    try{
      var data={'receiver_id':receiverId};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/ChatList.php'),
          body: data1
      );
      if(response.statusCode==201){

        print('Offer List : 201');
        var data2=jsonDecode(response.body.toString());
        var offer1=data2['data'];
        for(int m=0;offer1.length>m;m++){
          if(m<offer1.length){
            if(offer1[m]['id']==chatId)
            {
              offerdata=offer1[m];
            }
          }
        }

        return true;
      }
      else if(response.statusCode==200){
        print('Offer List : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Offer List Failed  : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  approvedOfferList(String receiverId,{var onlyforOffer}) async{
    try{
      var data={'receiver_id':receiverId};
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/GetApprovedOffers.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Get Approved Offer : 201');
        var data2=jsonDecode(response.body.toString());
        var chhh=data2['data'];
        if(chhh.isEmpty){
          approved_offers=null;
          offerdata=null;
          setState(() {
            approved_offers;
            offerdata;
          });
          return;
        }
        else{
          for(int m=0;m<chhh.length;m++){
            if((chhh[m]['receiver_id']==get_receiverId.toString() && chhh[m]['sender_id']==user_details['data']['id']) || (chhh[m]['receiver_id']==user_details['data']['id'] && chhh[m]['sender_id']==get_receiverId.toString()))
            {
              approved_offers=chhh[m];
            }
          }
          setState(() {
            approved_offers;
          });
          canceloffer=approved_offers;
          if(onlyforOffer=='offer'){
            offerList(user_details['data']['id'], approved_offers['offer_id']);
          }
        }
        return true;
      }
      else if(response.statusCode==200){
        print('Get Approved Offer : 200');
        approved_offers=null;
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Get Approved Offer  : else');
        approved_offers=null;
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }

  }

  mess(){
    messageList(user_details['data']['id']);
    // messages;
  }
  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }
  checkVisibilty_Make(){
    print('Approved Switch Make : $approved_offers');
        if(approved_offers==null || approved_offers==[]){
          print('Offer_Make : approved_offers==null || approved_offers==[]');
          setState(() {
            approved_offers;
          });
          return true;
        }
        if(approved_offers['approved']=='approved' && approved_offers['sender_id']==user_details['data']['id'] && approved_offers['receiver_id']==get_receiverId.toString()){
          print('Offer_Make : Approved');
          setState(() {
            approved_offers;
          });
          return false;
        }
        else{
          print('Offer_Make : Else');
          setState(() {
            approved_offers;
          });
          return true;
        }
  }
  checkVisibilty_Details(){
    print('Approved Switch Details : $approved_offers');
    if(approved_offers==null || approved_offers==[]){
      print('Offer_Details : approved_offers==null || approved_offers==[]');
      setState(() {
        approved_offers;
      });
      return false;
    }
    if(approved_offers['approved']=='approved' && approved_offers['sender_id']==user_details['data']['id'] && approved_offers['receiver_id']==get_receiverId.toString()){
      print('Offer_Details : Approved');
      setState(() {
        approved_offers;
      });
      return true;
    }
    else{
      print('Offer_Details : Else');
      setState(() {
        approved_offers;
      });
      return false;
    }
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }
@override
  void dispose() {
    audioPlayer.dispose();
    recorder.closeRecorder();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    initRecorder();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state==PlayerState.PLAYING;

      });

    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration=newDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;
      });

    });

    // TODO: implement initState
    super.initState();
  }
  var containerHeight=90.0;

  checkOfferButton(var x,{var onlyforOffer}) async {
   await approvedOfferList(x,onlyforOffer: '${onlyforOffer}');
   setState(() {
     approved_offers;
   });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).textScaleFactor;
    checkOfferButton(get_receiverId.toString(),onlyforOffer: 'offer');

    readChat(get_receiverId, user_details['data']['id']);
    var lines=(messageController.text.length/20).truncate();
    var numberLines=lines>7?7:lines;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        tab_controller.jumpToTab(3);
                        tab_controller.notifyListeners();
                        Get.back();
                        setState(() { });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                        size: screenHeight * 0.02,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Text(
                        'Messages'.tr,
                        style: TextStyle(
                          fontSize: fontSize * 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                  Get.defaultDialog(
                    title: 'Delete Messages',
                    titleStyle: TextStyle(color:Colors.deepOrangeAccent),
                    content: Column(children: [
                      Text('Are you sure to delete all chat of this user'),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        ElevatedButton(
                            onPressed: () {
                              deleteChat(get_receiverId, user_details['data']['id']);
                              deleteChat( user_details['data']['id'],get_receiverId);
                              Get.back();

                        }, child: Text('Confirm')),
                        ElevatedButton(onPressed: () {
                          Get.back();
                        }, child: Text('Cancel')),
                      ],)
                    ],)
                  );

                  }, icon: Icon(Icons.delete_sweep_rounded))
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                backgroundImage: AssetImage("assets/images/home_logo_new.jpg"),

                radius: 30,
                backgroundColor: Colors.white,
              ):CircleAvatar(
                    backgroundImage: NetworkImage(get_octobossName['picture'].toString()),
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),

                  Text(get_octobossName['full_name'].toString()),
                  Visibility(
                    visible: approved_offers==null?true:false,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.orange,
                      onPressed: () {
                          getPostApi();
                          _showMyDialogTraining();
                      },
                      child: Text(
                        'Make an offer'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: approved_offers==null?false:true,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.orange,
                      onPressed: () {
                        if(offerdata==null){
                        }
                        else{
                        _showMyOfferDialog();}
                      },
                      child: Text(
                        'SEE OFFER DETAILS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 15,
              child:StreamBuilder(
                stream: mess(),
                builder: (BuildContext context,AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var x=messages[index]['receiver_id'];
                      var y=user_details['data']['id'];
                      var ind=messages[index];

                      if(messages[index]['message_type']=='image'){
                        return x==y? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Column(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  messages[index]['image']),
                                              fit: BoxFit.contain)),
                                      width: Get.size.width*0.6,
                                      height: Get.size.height*0.35,
                                    ),
                                    SizedBox(height: 5,),
                                    Row(children: [
                                      Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                      SizedBox(width: 5,),
                                      Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                    ],)
                                  ]),

                                )),

                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Container(

                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  messages[index]['image']),
                                              fit: BoxFit.contain)),
                                      width: Get.size.width*0.6,
                                      height: Get.size.height*0.35,

                                    ),
                                    SizedBox(height: 5,),
                                    Row(children: [

                                      Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                      SizedBox(width: 5,),
                                      Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),

                                    ],)
                                  ]),
                                )),

                            SizedBox(width: 10),

                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        );
                      }
                      if(messages[index]['message_type']=='audio'){
                        return x==y?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),


                            SizedBox(width: 10),
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,

                                      children: [
                                        Row(children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: IconButton(
                                              icon: Icon((isPlaying && audioClick==messages[index]['id'])?Icons.pause:Icons.play_arrow),
                                              onPressed: () async {
                                                Fluttertoast.showToast(msg: messages[index]['id'].toString());
                                                // var yy=messages[index]['id'];
                                                audioClick=messages[index]['id'];


                                                if(isPlaying){
                                                  await audioPlayer.pause();

                                                }
                                                else{
                                                  String url=messages[index]['image'].toString();
                                                  print('URl of Audio : $url');
                                                  await audioPlayer.play(url);

                                                }
                                              },
                                            ),
                                          ),
                                          (audioClick==messages[index]['id'])?Slider(
                                              min:0,
                                              max:duration.inSeconds.toDouble(),
                                              value: position.inSeconds.toDouble(),

                                              onChanged: (value) async{
                                                final position=Duration(seconds: value.toInt());
                                                await audioPlayer.seek(position);
                                                await audioPlayer.resume();
                                              }
                                          ):Slider(
                                              min:0,
                                              max:duration.inSeconds.toDouble(),
                                              value: 0.0,

                                              onChanged: (value) async{
                                                // final position=Duration(seconds: value.toInt());
                                                // await audioPlayer.seek(position);
                                                // await audioPlayer.resume();
                                              }
                                          )
                                        ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          // crossAxisAlignment: CrossAxisAlignment,
                                          mainAxisSize: MainAxisSize.max,

                                          children: [
                                            (audioClick==messages[index]['id'])?Text('${position.inSeconds.toString()} : ${position.inMinutes.toString()}'):Text('0 : 0'),
                                          SizedBox(width: Get.size.width*0.25 ,),

                                            (audioClick==messages[index]['id'])?Text('${(duration-position).inSeconds} : ${position.inMinutes.toString()}'):Text('0 : 0'),

                                        ],),
                                        SizedBox(height: 5,),
                                        Row(children: [

                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          SizedBox(width: 5,),
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),

                                        ],)
                                      ],
                                    ),

                                  ),
                                )),

                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: IconButton(
                                              icon: Icon((isPlaying && audioClick==messages[index]['id'])?Icons.pause:Icons.play_arrow),
                                              onPressed: () async {
                                                audioClick=messages[index]['id'];
                                                if(isPlaying){
                                                  await audioPlayer.pause();
                                                }
                                                else{
                                                  String url=messages[index]['image'].toString();
                                                  await audioPlayer.play(url);

                                                }
                                              },
                                            ),
                                          ),
                                          (audioClick==messages[index]['id'])?Slider(
                                              min:0,
                                              max:duration.inSeconds.toDouble(),
                                              value: position.inSeconds.toDouble(),

                                              onChanged: (value) async{
                                                final position=Duration(seconds: value.toInt());
                                                await audioPlayer.seek(position);
                                                await audioPlayer.resume();
                                              }
                                          ):Slider(
                                              min:0,
                                              max:duration.inSeconds.toDouble(),
                                              value: 0.0,

                                              onChanged: (value) async{
                                                final position=Duration(seconds: value.toInt());
                                                await audioPlayer.seek(position);
                                                await audioPlayer.resume();
                                              }
                                          ),
                                        ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,

                                          children: [
                                            (audioClick==messages[index]['id'])?Text('${position.inSeconds.toString()} : ${position.inMinutes.toString()}'):Text('0 : 0'),
                                            SizedBox(width: Get.size.width*0.25 ,),
                                            (audioClick==messages[index]['id'])?Text('${(duration-position).inSeconds} : ${position.inMinutes.toString()}'):Text('0 : 0'),

                                          ],),
                                        SizedBox(height: 5,),
                                        Row(children: [

                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),

                                        ],)
                                      ],
                                    ),

                                  ),
                                )),
                            SizedBox(width: 10),

                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        );
                      }
                      if(messages[index]['message_type']=='document'){
                        var url=messages[index]['image'];
                        String fileName = url.split('/').last;

                        return x==y?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),

                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                docClick=messages[index]['id'];
                                openFile(url, fileName).whenComplete(() {
                                  setState(() {
                                    docClick=-1;
                                  });
                                },);
                              },
                              child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Document',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  width: Get.size.width*0.4,
                                                  child: Text('$fileName')),
                                              SizedBox(width: 30,),
                                              (downloading==false && docClick==messages[index]['id'])?Column(children: [
                                                CircularProgressIndicator(),

                                                SizedBox(height: 10,),
                                                Text('$progressString'),
                                              ]):CircleAvatar(
                                              radius: 20,
                                              child: IconButton(
                                                icon: Icon(Icons.download_rounded),
                                                onPressed: () async {
                                                  docClick=messages[index]['id'];
                                                  openFile(url, fileName).whenComplete(() {
                                                    setState(() {
                                                      docClick=-1;
                                                    });
                                                  },);

                                                },
                                              ),
                                            ),
                                          ],
                                          ),
                                          Row(children: [
                                            Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                            SizedBox(width: 5,),
                                            Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          ],)
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                docClick=messages[index]['id'];
                                  openFile(url, fileName).whenComplete(() {
                                    setState(() {
                                      docClick=-1;
                                    });
                                  },);

                              },
                              child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Document',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                            ],
                                          ),
                                          Row(children: [
                                            (downloading==false && docClick==messages[index]['id'])?Column(children: [
                                              CircularProgressIndicator(),

                                              SizedBox(height: 10,),
                                              Text('$progressString'),
                                            ]):CircleAvatar(
                                              radius: 20,
                                              child: IconButton(
                                                icon: Icon(Icons.download_rounded),
                                                onPressed: () async {
                                                  docClick=messages[index]['id'];
                                                  openFile(url, fileName).whenComplete(() {
                                                    setState(() {
                                                      docClick=-1;
                                                    });
                                                  },);
                                                },
                                              ),
                                            ),

                                            SizedBox(width: 30,),
                                            Container(
                                              width: Get.size.width*0.4,
                                                child: Text('$fileName')),
                                          ],),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                            ],),
                                          Row(children: [
                                            Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                            SizedBox(width: 5,),
                                            Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          ],)
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 10),

                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        );
                      }
                      if(messages[index]['message_type']=='contact'){
                        return x==y?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),



                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Name'),
                                            Text('Contact No'),
                                          ],),
                                        SizedBox(width: 15,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(messages[index]['contact_name']),
                                            SelectableText(messages[index]['contact_no']),
                                          ],),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                        SizedBox(width: 5,),
                                        Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),

                                      ],)
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text('Name'),
                                          Text('Contact No'),
                                        ],),
                                        SizedBox(width: 15,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text(messages[index]['contact_name']),
                                          SelectableText(messages[index]['contact_no']),
                                        ],),
                                      ],
                                    ),
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                      Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                      SizedBox(width: 5,),
                                      Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                    ],)
                                  ],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),

                          ],
                        );
                      }
                      if(messages[index]['message_type']=='issue'){
                        return x==y?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),

                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {},
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.size.width*0.6,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                child: Text('Issue Shared',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.orange),))
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Problem'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['problem'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Description'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['description'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Location'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['location'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Languages'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['language'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                            SizedBox(width: 5,),
                                            Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),

                                          ],)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            InkWell(
                              onTap: () {
                                _showMyDialog(messages[index]);
                                },
                              child: Card(
                                 elevation: 10,

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.size.width*0.6,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                child: Text('Issue Shared',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.orange),))
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                          Text('Problem'),
                                          SizedBox(width: 5,),
                                          Expanded(child: Text(messages[index]['problem'])),

                                        ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Description'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['description'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Location'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['location'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Languages'),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(messages[index]['language'])),

                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                            SizedBox(width: 5,),
                                            Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          ],)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),

                          ],
                        );

                      }
                      if(messages[index]['message_type']=='offer'){
                        if(messages[index]['approved']=='cancel'){
                          return x==y? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/home_logo_new.jpg',
                                ),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ):CircleAvatar(
                                backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                                radius: 30,
                                backgroundColor: Colors.white,
                              ),

                              SizedBox(width: 10),
                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Cancelled',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                        ],)

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Cancelled',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          SizedBox(width: 5,),
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                        ],)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage: NetworkImage(user_details['data']['picture']??''),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ),
                            ],
                          );
                        }
                        if(messages[index]['approved']=='completed'){
                          return x==y? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/home_logo_new.jpg',
                                ),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ):CircleAvatar(
                                backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                                radius: 30,
                                backgroundColor: Colors.white,
                              ),

                              SizedBox(width: 10),
                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Completed',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                        ],)

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Completed',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          SizedBox(width: 5,),
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                        ],)

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage: NetworkImage(user_details['data']['picture']??''),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ),
                            ],
                          );
                        }
                        if(messages[index]['approved'].toString().toLowerCase()=='approved'){
                          return x==y? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/home_logo_new.jpg',
                                ),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ):CircleAvatar(
                                backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                                radius: 30,
                                backgroundColor: Colors.white,
                              ),

                              SizedBox(width: 10),
                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Approved',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                        ],)

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Card(
                                elevation: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TIME'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['time'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('DATE'),
                                            Container(width: Get.size.width*0.6,
                                              child: TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  hintText: messages[index]['dates'],
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 20.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.grey, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('PRICE'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['price']} \$',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Get.size.width*0.06,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('DURATION'),
                                                Container(width: Get.size.width*0.27,
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      hintText: '${messages[index]['duration']} hrs',
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(height: Get.size.height*0.02,),
                                      Row(

                                        children: [
                                          Text('Approved',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: Get.size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          SizedBox(width: 5,),
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                        ],)

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              CircleAvatar(
                                  backgroundImage: NetworkImage(user_details['data']['picture']??''),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ),
                            ],
                          );
                        }
                        else{
                        return x==y?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),

                            SizedBox(width: 10),
                            Card(
                              elevation: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                      ],
                                    ),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('TIME'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['time'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('DATE'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['dates'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ISSUE PROBLEM'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['problem'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: Get.size.height*0.01,),
                                          Text('ISSUE DESCRIPTION'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['description'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('PRICE'),
                                              Container(width: Get.size.width*0.27,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${messages[index]['price']} \$',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: Get.size.width*0.06,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('DURATION'),
                                              Container(width: Get.size.width*0.27,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${messages[index]['duration']} hrs',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Visibility(
                                      visible: messages[index]['sender_id']==user_details['data']['id']?false:true,
                                      child: Row(

                                        children: [
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            color: Colors.orange,
                                            onPressed: () {
                                              updateOfferStatus(messages[index]['id'], 'approved',issueId: messages[index]['issue_id'],time: messages[index]['time'],date: messages[index]['dates']);
                                            },
                                            child: Text(
                                              'Accept offer',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: Get.size.width*0.06,),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            color: Colors.orange,
                                            onPressed: () {
                                              updateOfferStatus(messages[index]['id'], 'cancel');
                                            },
                                            child: Text(
                                              'Refuse',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Visibility(
                                      visible: messages[index]['sender_id']==user_details['data']['id']?true:false,
                                      child: Row(
                                        children: [
                                          Text('Offer Sent',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.size.height*0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                        SizedBox(width: 5,),
                                        Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                      ],),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Card(
                              elevation: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('New Offer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20)),
                                      ],
                                    ),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('TIME'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['time'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('DATE'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['dates'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ISSUE PROBLEM'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['problem'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: Get.size.height*0.01,),
                                          Text('ISSUE DESCRIPTION'),
                                          Container(width: Get.size.width*0.6,
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: messages[index]['description'],
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 1.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('PRICE'),
                                              Container(width: Get.size.width*0.27,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${messages[index]['price']} \$',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: Get.size.width*0.06,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('DURATION'),
                                              Container(width: Get.size.width*0.27,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    hintText: '${messages[index]['duration']} hrs',
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 2.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Visibility(
                                        visible: messages[index]['sender_id']==user_details['data']['id']?false:true,
                                      child: Row(

                                        children: [
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            color: Colors.orange,
                                            onPressed: () {
                                              updateOfferStatus(messages[index]['id'], 'approved',issueId: messages[index]['issue_id'],time: messages[index]['time'],date: messages[index]['dates']);

                                            },
                                            child: Text(
                                              'Accept offer',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: Get.size.width*0.06,),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            color: Colors.orange,
                                            onPressed: () {
                                              // Fluttertoast.showToast(msg: '${int.parse(messages[index]['id'])}: ${messages[index]['id'].runtimeType}');
                                              updateOfferStatus(messages[index]['id'], 'cancel');

                                            },
                                            child: Text(
                                              'Refuse',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.size.height*0.02,),
                                    Visibility(
                                      visible: messages[index]['sender_id']==user_details['data']['id']?true:false,
                                      child: Row(
                                        children: [
                                          Text('Offer Sent',style: TextStyle(fontSize: 15,color: Colors.orange,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.size.height*0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                        SizedBox(width: 5,),
                                        Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                      ],)

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        );}
                      }
                      else{
                        return x==y? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (get_octobossName['picture']==null || get_octobossName['picture']=="")?CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/home_logo_new.jpg',
                              ),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ):CircleAvatar(
                              backgroundImage: NetworkImage(get_octobossName['picture'].toString()),

                              radius: 30,
                              backgroundColor: Colors.white,
                            ),


                            SizedBox(width: 10),
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.size.width*0.5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(messages[index]['message']),
                                        SizedBox(height: 5,),
                                        Row(children: [

                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                          SizedBox(width: 5,),
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),


                                        ],)

                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.size.width*0.5,

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(messages[index]['message']),
                                        SizedBox(height: 5,),
                                        Row(children: [
                                          Text(messages[index]['sending_time']??'',style: TextStyle(color: Colors.grey)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.done_all_outlined,color: messages[index]['status']=='unread'?Colors.grey:Colors.deepOrangeAccent,size: 18),
                                        ],)

                                      ],
                                    ),
                                  ),
                                )),

                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user_details['data']['picture']??''),
                              radius: 30,
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            // Column(children: [],),
                          ],
                        );
                      }

                    },);
                },
              )
            ),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: 250,
                width: Get.size.width,
                child: EmojiPicker(
                  onEmojiSelected: (Category? category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
            SizedBox(
              height: Get.size.height*0.13,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: containerHeight+(numberLines*20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 5,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    },
                                    icon: Icon(Icons.emoji_emotions)
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 10,
                                child: Container(
                                  width: Get.size.width*0.5,
                                  child: LayoutBuilder(builder: (context, constraints) {
                                    return TextFormField(
                                      controller: messageController,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 8,
                                      decoration: InputDecoration(
                                          hintText: 'Write Something...',
                                          border: InputBorder.none
                                      ),
                                    );
                                  },),
                                )),
                            Spacer(),
                            Visibility(
                              visible: visibility_attach,
                              child: Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            Bottomsheet()),
                                      );
                                    },
                                    icon: Icon(
                                        Icons.attach_file_sharp)),
                              ),
                            ),
                            Visibility(
                              visible: visibility_timer,
                              child: StreamBuilder<RecordingDisposition>(
                                stream: recorder.onProgress,
                                builder: (context, snapshot) {
                                  final duration=snapshot.hasData?snapshot.data!.duration:Duration.zero;
                                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                                  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                                  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                                  return Text('$twoDigitMinutes : $twoDigitSeconds',style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 0,
                            ),
                            Expanded(
                              flex: 3,
                              child: IconButton(
                                icon: Icon(
                                    recorder.isRecording?Icons.stop:Icons.keyboard_voice_rounded
                                ),
                                onPressed: () async {
                                  if(recorder.isRecording){
                                    setState(() {
                                      visibility_attach=true;
                                      visibility_timer=false;
                                    });
                                    await stop();
                                  }
                                  else{
                                    setState(() {
                                      visibility_attach=false;
                                      visibility_timer=true;
                                    });
                                    await record();
                                  }
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              elevation: 5,
              child: IconButton(
                  onPressed: () {
                    sendMessage(user_details['data']['id'],get_receiverId.toString(), messageController.text.toString());
                    messageController.clear();
                  }, icon: Icon(Icons.send_rounded)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialogTraining() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    offerissue=null;
                                  });
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  size: 35,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                        Text('Time'.tr),
                        TextFormField(
                          onTap: () async {
                            pickedTime =
                            await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              print(pickedTime?.format(
                                  context)); //output 10:51 PM

                              setState(() {
                                timeController.text = pickedTime!.format(
                                    context); //set the value of text field.
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },

                          controller: timeController,

                          decoration: InputDecoration(
                            hintText: '03:30 PM',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Date'.tr),
                        TextFormField(
                          onTap: () => _selectDate(),
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: '12/21/2021',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                            visible: offerissue==null?true:false,
                            child: Text('Choose issue'.tr)),
                        Visibility(
                          visible: offerissue==null?true:false,
                          child: TextFormField(
                            onTap: () async{
                              await showModalBottomSheet(
                                context: context,
                                builder: ((builder) =>
                                    OfferIssue_Bottomsheet()),
                              );
                              setState(() {});
                            },
                            onChanged: (x){
                              setState(() {
                                offerissue;
                              });
                            },

                            decoration: InputDecoration(
                              hintText: 'Select Issue'.tr,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: offerissue==null?false:true,
                            child: Text('SELECTED ISSUE')),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Price'.tr), Text('Duration'.tr)],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(

                                  hintText: '10\$',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: durationController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '3 hrs',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: Colors.orange,
                              onPressed: () {

                                sender=user_details['data']['id'];
                                receiver=get_receiverId.toString();
                                if(timeController.text==''){
                                  Fluttertoast.showToast(msg: 'Kindly, Select Time');
                                }
                                else if(dateController.text==''){
                                  Fluttertoast.showToast(msg: 'Kindly, Select Date');
                                }
                                else if(offerissue==null){
                                  Fluttertoast.showToast(msg: 'Kindly, Choose any Issue');
                                }
                                else if(priceController.text==''){
                                  Fluttertoast.showToast(msg: 'Kindly, Enter Price');
                                }
                                else if(durationController.text==''){
                                  Fluttertoast.showToast(msg: 'Kindly, Enter Duration');
                                }
                                else{
                                  sendOffer(user_details['data']['id'],get_receiverId.toString(), timeController.text, dateController.text, priceController.text, durationController.text);

                                  timeController.clear();
                                  dateController.clear();
                                  priceController.clear();
                                  durationController.clear();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                'Send offer'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },);
      },
    );
  }

  Future<void> _showMyOfferDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.cancel,
                              size: 35,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    Text('TIME'),
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: offerdata['time'],
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('DATE'),
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: offerdata['dates'],
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('PRICE'), Text('DURATION')],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: '${offerdata['price']}\$',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: '${offerdata['duration']} hrs',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.orange,
                          onPressed: () {
                            Navigator.of(context).pop();
                            approved_offers=null;
                            updateOfferStatus(offerdata['id'], 'cancel',issueId: offerdata['issue_id'],offercancel: 'canceloffer');
                          },
                          child: Text(
                            'Cancel offer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget Bottomsheet() {
    return Container(
      height: Get.height*0.2,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getDocument();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.file_copy),
                      radius: 30,
                    ),
                  ),
                  Text('Document')
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      getImageCamera();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.camera_alt),
                      radius: 30,
                    ),
                  ),
                  Text('Camera')
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      getImageGallery();
                        },
                    child: CircleAvatar(
                      child: Icon(Icons.image),
                      radius: 30,
                    ),
                  ),
                  Text('Gallery')
                ],
              )

            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getAudio();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.music_note),
                      radius: 30,
                    ),
                  ),
                  Text('Audio')
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                      final FullContact contact = await FlutterContactPicker.pickFullContact();
                      var name=contact.name!.nickName;
                      var number=contact.phones[1].number;
                      sendContact(user_details['data']['id'],get_receiverId.toString(), name.toString(), number.toString());

                    },
                    child: CircleAvatar(
                      child: Icon(Icons.person),
                      radius: 30,
                    ),
                  ),
                  Text('Contact')
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) =>
                            Issue_Bottomsheet()),
                      );
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.error),
                      radius: 30,
                    ),
                  ),
                  Text('Share Issue')
                ],
              ),

            ],
          )
        ],
      ),
    );
  }
  Widget Issue_Bottomsheet() {
    return FutureBuilder<issueList>(
        future: getPostApi(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.data!=null){
            return ListView.builder(
              itemCount: abc.length,
              itemBuilder: (context, index) {

                if(snapshot.hasData){
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 8),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        sendIssue(user_details['data']['id'],get_receiverId.toString(), 'carpanter', abc[index]['description'], abc[index]['title'], abc[index]['languages']);

                      },
                      child: Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize:MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(abc[index]['image']),
                                          radius: 35,
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(abc[index]['title']),
                                          Text(abc[index]['status']),
                                          Text(abc[index]['description']),
                                          Text(abc[index]['languages']),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  );
                }
                else{
                  return CircularProgressIndicator();
                }
              },
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }

        });
  }
  Widget OfferIssue_Bottomsheet() {
    return FutureBuilder<issueList>(
        future: getPostApi(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.data!=null){
            return ListView.builder(
              itemCount: abc.length,
              itemBuilder: (context, index) {

                if(snapshot.hasData){
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 8),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        setState(() {});
                        offerissue=abc[index];
                      },
                      child: Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize:MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(abc[index]['image']),
                                          radius: 35,
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(abc[index]['title']),
                                          Text(abc[index]['status']),
                                          Text(abc[index]['description']),
                                          Text(abc[index]['languages']),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  );
                }
                else{
                  return CircularProgressIndicator();
                }

              },
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }

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
    sendPicture(user_details['data']['id'],get_receiverId.toString(), imageLink!.path);
  }

  void getImageGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    setState(() {
      imageLink = File(image!.path);
    });
    sendPicture(user_details['data']['id'],get_receiverId.toString(), imageLink!.path);
  }

  Future record() async{
    await recorder.startRecorder(toFile: 'audio');
  }
  Future stop() async{
   final path= await recorder.stopRecorder();
   final audiofile=File(path!);
   sendAudio(user_details['data']['id'],get_receiverId.toString(), audiofile.path);
  }

  Future initRecorder() async{
    final status=await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      throw 'Microphone Permission not granted';
    }
    await recorder.openRecorder();
    
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    var audio = result!.files.first;

    if(result != null) {
      File file = File(result.files.single.path.toString());
      sendAudio(user_details['data']['id'],get_receiverId.toString(), file.path);
    } else {
      // User canceled the picker
    }
  }

  Future<void> getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf','docx','doc','xlsx','xls','pptx','ppt','txt' ]);
    var audio = result!.files.first;

    if(result != null) {
      File file = File(result.files.single.path.toString());
      sendDocument(user_details['data']['id'],get_receiverId.toString(), file.path);
    } else {
      // User canceled the picker
    }
  }

  Future<issueList> getPostApi() async {

    final response = await http.get(
        Uri.parse("https://admin.octo-boss.com/API/IssuesList.php"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 201) {
      issue_details=data['data'];
      var x=user_details['data']['id'];
      var len=data['data'].length-1;

      var y;
      var ind=0;
      var ls=[];
      abc.clear();

      for(int i=0;len>=i;i++){
        print('I value is :$i');
        if(data['data'][i]['status']=='pending')
            {
          if (i <= len) {
            if (x == data['data'][i]['created_by']) {
              y = data['data'][i];
              abc.add(y);
            }
          }
        }
      }
      return issueList.fromJson(data);
    } else {
      return issueList.fromJson(data);
    }
  }
  checkValue(var value) {
    if(value=='public'){
      return true;
    }
    else{
      return false;
    }
  }


  Future<void> _showMyDialog(var msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Color(0xffff6e01),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.report_problem,
                              color: Color(0xffff6e01),
                            ),
                            labelText: msg['problem'],
                            labelStyle: TextStyle(color: Color(0xffff6e01)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffff6e01)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Color(0xffff6e01),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xffff6e01),
                            ),
                            labelText: msg['description'],
                            labelStyle: TextStyle(color: Color(0xffff6e01)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffff6e01)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Color(0xffff6e01),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.location_on,
                              color: Color(0xffff6e01),
                            ),
                            labelText: msg['location'],
                            labelStyle: TextStyle(color: Color(0xffff6e01)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffff6e01)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Color(0xffff6e01),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.language,
                              color: Color(0xffff6e01),
                            ),
                            labelText: msg['language'],
                            hintText: 'ssss',
                            labelStyle: TextStyle(color: Color(0xffff6e01)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffff6e01)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Container(
                          // color: Colors.black,
                            height: 130,
                            width: double.infinity,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(msg['image']),
                              radius: 35,
                              backgroundColor: Colors.white,
                            ),

                            // child: Image.network(msg['image']),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade100,
                            )),
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      dateController.text = DateFormat.yMd().format(dateTime);
    }
  }

}
