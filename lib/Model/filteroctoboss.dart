/// response : 1
/// data : [{"image":"https://admin.octo-boss.com/images/avatar/1.jpg","name":"fakhar abbas","service":"Cleaner","experience":"9 Years of expreience over all","likes":"53 %","chats":"144","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/4.jpg","name":"fakhar abbas","service":"Plumber","experience":"9 Years of expreience over all","likes":"66 %","chats":"62","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/3.jpg","name":"fakhar abbas","service":"Home Repair","experience":"7 Years of expreience over all","likes":"70 %","chats":"141","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/2.jpg","name":"fakhar abbas","service":"Plumber","experience":"5 Years of expreience over all","likes":"58 %","chats":"48","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/1.jpg","name":"fakhar abbas","service":"Carpanter","experience":"8 Years of expreience over all","likes":"89 %","chats":"182","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/1.jpg","name":"mahajj bsbjs","service":"Carpanter","experience":"5 Years of expreience over all","likes":"77 %","chats":"108","last_seen":"5:25 PM","is_active":"No"},{"image":"https://admin.octo-boss.com/images/avatar/1.jpg","name":"bshdh hdhh","service":"Electicion","experience":"1 Years of expreience over all","likes":"76 %","chats":"187","last_seen":"5:25 PM","is_active":"Yes"},{"image":"https://admin.octo-boss.com/images/avatar/2.jpg","name":"yasir Basheer","service":"Plumber","experience":"3 Years of expreience over all","likes":"62 %","chats":"150","last_seen":"5:25 PM","is_active":"Yes"},{"image":"https://admin.octo-boss.com/images/avatar/1.jpg","name":"mazhar nadeem","service":"Plumber","experience":"5 Years of expreience over all","likes":"56 %","chats":"46","last_seen":"5:25 PM","is_active":"No"}]

class Filteroctoboss {
  Filteroctoboss({
      int? response, 
      List<Data>? data,}){
    _response = response;
    _data = data;
}

  Filteroctoboss.fromJson(dynamic json) {
    _response = json['response'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  int? _response;
  List<Data>? _data;

  int? get response => _response;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = _response;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image : "https://admin.octo-boss.com/images/avatar/1.jpg"
/// name : "fakhar abbas"
/// service : "Cleaner"
/// experience : "9 Years of expreience over all"
/// likes : "53 %"
/// chats : "144"
/// last_seen : "5:25 PM"
/// is_active : "No"

class Data {
  Data({
      String? image, 
      String? name, 
      String? service, 
      String? experience, 
      String? likes, 
      String? chats, 
      String? lastSeen, 
      String? isActive,}){
    _image = image;
    _name = name;
    _service = service;
    _experience = experience;
    _likes = likes;
    _chats = chats;
    _lastSeen = lastSeen;
    _isActive = isActive;
}

  Data.fromJson(dynamic json) {
    _image = json['image'];
    _name = json['name'];
    _service = json['service'];
    _experience = json['experience'];
    _likes = json['likes'];
    _chats = json['chats'];
    _lastSeen = json['last_seen'];
    _isActive = json['is_active'];
  }
  String? _image;
  String? _name;
  String? _service;
  String? _experience;
  String? _likes;
  String? _chats;
  String? _lastSeen;
  String? _isActive;

  String? get image => _image;
  String? get name => _name;
  String? get service => _service;
  String? get experience => _experience;
  String? get likes => _likes;
  String? get chats => _chats;
  String? get lastSeen => _lastSeen;
  String? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['name'] = _name;
    map['service'] = _service;
    map['experience'] = _experience;
    map['likes'] = _likes;
    map['chats'] = _chats;
    map['last_seen'] = _lastSeen;
    map['is_active'] = _isActive;
    return map;
  }

}