import 'dart:convert';
import 'package:http/http.dart';
import 'package:octbs_ui/controller/api/userDetails.dart';

class MembershipApi{


  purchaseMembership(int plainId ,var transaction) async{
    try{

      var userId=int.parse(user_details['data']['id']);

      var data={'user_id':userId.toString(),'plan_id':plainId.toString(),'transaction':transaction};

      //It is used for raw data;
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/AddMemberShipPayment.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Membership Purchased : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Membership Purchased : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Membership Purchased : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
  purchaseBoost(var boostId ,var transaction) async{
    try{

      var userId=int.parse(user_details['data']['id']);
      var data={'user_id':userId.toString(),'boost_id':boostId.toString(),'transaction':transaction};

      //It is used for raw data;
      var data1=json.encode(data);
      var response=await post(Uri.parse('https://admin.octo-boss.com/API/BostPlanBuy.php'),
          body: data1
      );
      if(response.statusCode==201){
        print('Boost Purchased : 201');
        var data2=jsonDecode(response.body.toString());
        return true;
      }
      else if(response.statusCode==200){
        print('Boost Purchased : 200');
        var data2=jsonDecode(response.body.toString());
        return false;
      }
      else{
        print('Boost Purchased : else');
        var data2=jsonDecode(response.body.toString());
        return false;
      }

    }catch(e){
      // Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

}