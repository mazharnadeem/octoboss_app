/// response : 1
/// code : 200
/// message : "Octoboss Profile Data!!!"
/// data : {"picture":"NULL","first_name":"NULL","last_name":"NULL","date_of_birth":"NULL","full_address":"","email":"NULL","street_no":"NULL","street_name":"NULL","street_address":"NULL","unit_number":"NULL","city":"NULL","phone_number":"NULL","job_info":"NULL","tag_of_services":"NULL","job_title":"NULL","detail_description":"NULL","country":"NULL","postal_code":"NULL","certificate":"NULL","work_picture":"NULL","language":"NULL","category":"NULL"}

class Profilemodel {
  Profilemodel({
      int? response, 
      int? code, 
      String? message, 
      Data? data,}){
    _response = response;
    _code = code;
    _message = message;
    _data = data;
}

  Profilemodel.fromJson(dynamic json) {
    _response = json['response'];
    _code = json['code'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? _response;
  int? _code;
  String? _message;
  Data? _data;

  int? get response => _response;
  int? get code => _code;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = _response;
    map['code'] = _code;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// picture : "NULL"
/// first_name : "NULL"
/// last_name : "NULL"
/// date_of_birth : "NULL"
/// full_address : ""
/// email : "NULL"
/// street_no : "NULL"
/// street_name : "NULL"
/// street_address : "NULL"
/// unit_number : "NULL"
/// city : "NULL"
/// phone_number : "NULL"
/// job_info : "NULL"
/// tag_of_services : "NULL"
/// job_title : "NULL"
/// detail_description : "NULL"
/// country : "NULL"
/// postal_code : "NULL"
/// certificate : "NULL"
/// work_picture : "NULL"
/// language : "NULL"
/// category : "NULL"

class Data {
  Data({
      String? picture, 
      String? firstName, 
      String? lastName, 
      String? dateOfBirth, 
      String? fullAddress, 
      String? email, 
      String? streetNo, 
      String? streetName, 
      String? streetAddress, 
      String? unitNumber, 
      String? city, 
      String? phoneNumber, 
      String? jobInfo, 
      String? tagOfServices, 
      String? jobTitle, 
      String? detailDescription, 
      String? country, 
      String? postalCode, 
      String? certificate, 
      String? workPicture, 
      String? language, 
      String? category,}){
    _picture = picture;
    _firstName = firstName;
    _lastName = lastName;
    _dateOfBirth = dateOfBirth;
    _fullAddress = fullAddress;
    _email = email;
    _streetNo = streetNo;
    _streetName = streetName;
    _streetAddress = streetAddress;
    _unitNumber = unitNumber;
    _city = city;
    _phoneNumber = phoneNumber;
    _jobInfo = jobInfo;
    _tagOfServices = tagOfServices;
    _jobTitle = jobTitle;
    _detailDescription = detailDescription;
    _country = country;
    _postalCode = postalCode;
    _certificate = certificate;
    _workPicture = workPicture;
    _language = language;
    _category = category;
}

  Data.fromJson(dynamic json) {
    _picture = json['picture'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _dateOfBirth = json['date_of_birth'];
    _fullAddress = json['full_address'];
    _email = json['email'];
    _streetNo = json['street_no'];
    _streetName = json['street_name'];
    _streetAddress = json['street_address'];
    _unitNumber = json['unit_number'];
    _city = json['city'];
    _phoneNumber = json['phone_number'];
    _jobInfo = json['job_info'];
    _tagOfServices = json['tag_of_services'];
    _jobTitle = json['job_title'];
    _detailDescription = json['detail_description'];
    _country = json['country'];
    _postalCode = json['postal_code'];
    _certificate = json['certificate'];
    _workPicture = json['work_picture'];
    _language = json['language'];
    _category = json['category'];
  }
  String? _picture;
  String? _firstName;
  String? _lastName;
  String? _dateOfBirth;
  String? _fullAddress;
  String? _email;
  String? _streetNo;
  String? _streetName;
  String? _streetAddress;
  String? _unitNumber;
  String? _city;
  String? _phoneNumber;
  String? _jobInfo;
  String? _tagOfServices;
  String? _jobTitle;
  String? _detailDescription;
  String? _country;
  String? _postalCode;
  String? _certificate;
  String? _workPicture;
  String? _language;
  String? _category;

  String? get picture => _picture;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get dateOfBirth => _dateOfBirth;
  String? get fullAddress => _fullAddress;
  String? get email => _email;
  String? get streetNo => _streetNo;
  String? get streetName => _streetName;
  String? get streetAddress => _streetAddress;
  String? get unitNumber => _unitNumber;
  String? get city => _city;
  String? get phoneNumber => _phoneNumber;
  String? get jobInfo => _jobInfo;
  String? get tagOfServices => _tagOfServices;
  String? get jobTitle => _jobTitle;
  String? get detailDescription => _detailDescription;
  String? get country => _country;
  String? get postalCode => _postalCode;
  String? get certificate => _certificate;
  String? get workPicture => _workPicture;
  String? get language => _language;
  String? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['picture'] = _picture;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['date_of_birth'] = _dateOfBirth;
    map['full_address'] = _fullAddress;
    map['email'] = _email;
    map['street_no'] = _streetNo;
    map['street_name'] = _streetName;
    map['street_address'] = _streetAddress;
    map['unit_number'] = _unitNumber;
    map['city'] = _city;
    map['phone_number'] = _phoneNumber;
    map['job_info'] = _jobInfo;
    map['tag_of_services'] = _tagOfServices;
    map['job_title'] = _jobTitle;
    map['detail_description'] = _detailDescription;
    map['country'] = _country;
    map['postal_code'] = _postalCode;
    map['certificate'] = _certificate;
    map['work_picture'] = _workPicture;
    map['language'] = _language;
    map['category'] = _category;
    return map;
  }

}