/// response : 1
/// code : 200
/// data : [{"id":"2","status":"0","product_image":"https://admin.noqta-market.com/new/admin/assest/img/services/1632739658_Services.png","product_name":"Apple Phone"},{"id":"3","status":"1","product_image":"https://admin.noqta-market.com/new/admin/assest/img/services/1632740503_Services.jpg","product_name":"tes2"},{"id":"4","status":"","product_image":"https://admin.noqta-market.com/new/admin/assest/img/services/1632746528_Services.jpg","product_name":"Plumber "},{"id":"5","status":"0","product_image":"https://admin.noqta-market.com/new/admin/","product_name":"Default servics"},{"id":"6","status":"1","product_image":"https://admin.noqta-market.com/new/admin/assest/octbosss.png","product_name":"test"},{"id":"7","status":"1","product_image":"https://admin.noqta-market.com/new/admin/assest/img/services/1633235566_Services.jpg","product_name":"Carpenter"}]

class ServicesResponse {
  ServicesResponse({
      int? response, 
      int? code, 
      List<Data>? data,}){
    _response = response;
    _code = code;
    _data = data;
}

  ServicesResponse.fromJson(dynamic json) {
    _response = json['response'];
    _code = json['code'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  int? _response;
  int? _code;
  List<Data>? _data;

  int? get response => _response;
  int? get code => _code;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = _response;
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// status : "0"
/// product_image : "https://admin.noqta-market.com/new/admin/assest/img/services/1632739658_Services.png"
/// product_name : "Apple Phone"

class Data {
  Data({
      String? id, 
      String? status, 
      String? productImage, 
      String? productName,}){
    _id = id;
    _status = status;
    _productImage = productImage;
    _productName = productName;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _productImage = json['product_image'];
    _productName = json['product_name'];
  }
  String? _id;
  String? _status;
  String? _productImage;
  String? _productName;

  String? get id => _id;
  String? get status => _status;
  String? get productImage => _productImage;
  String? get productName => _productName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['product_image'] = _productImage;
    map['product_name'] = _productName;
    return map;
  }

}