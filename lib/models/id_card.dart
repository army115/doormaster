class ID_Card {
  String? address;
  double? detectionScore;
  String? district;
  String? enDob;
  String? enExpire;
  String? enFname;
  String? enInit;
  String? enIssue;
  String? enLname;
  String? enName;
  String? errorMessage;
  String? face;
  String? gender;
  String? homeAddress;
  String? idNumber;
  String? postalCode;
  double? processTime;
  String? province;
  String? religion;
  String? requestId;
  String? subDistrict;
  String? thDob;
  String? thExpire;
  String? thFname;
  String? thInit;
  String? thIssue;
  String? thLname;
  String? thName;

  ID_Card(
      {this.address,
      this.detectionScore,
      this.district,
      this.enDob,
      this.enExpire,
      this.enFname,
      this.enInit,
      this.enIssue,
      this.enLname,
      this.enName,
      this.errorMessage,
      this.face,
      this.gender,
      this.homeAddress,
      this.idNumber,
      this.postalCode,
      this.processTime,
      this.province,
      this.religion,
      this.requestId,
      this.subDistrict,
      this.thDob,
      this.thExpire,
      this.thFname,
      this.thInit,
      this.thIssue,
      this.thLname,
      this.thName});

  ID_Card.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    detectionScore = json['detection_score'];
    district = json['district'];
    enDob = json['en_dob'];
    enExpire = json['en_expire'];
    enFname = json['en_fname'];
    enInit = json['en_init'];
    enIssue = json['en_issue'];
    enLname = json['en_lname'];
    enName = json['en_name'];
    errorMessage = json['error_message'];
    face = json['face'];
    gender = json['gender'];
    homeAddress = json['home_address'];
    idNumber = json['id_number'];
    postalCode = json['postal_code'];
    processTime = json['process_time'];
    province = json['province'];
    religion = json['religion'];
    requestId = json['request_id'];
    subDistrict = json['sub_district'];
    thDob = json['th_dob'];
    thExpire = json['th_expire'];
    thFname = json['th_fname'];
    thInit = json['th_init'];
    thIssue = json['th_issue'];
    thLname = json['th_lname'];
    thName = json['th_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['detection_score'] = this.detectionScore;
    data['district'] = this.district;
    data['en_dob'] = this.enDob;
    data['en_expire'] = this.enExpire;
    data['en_fname'] = this.enFname;
    data['en_init'] = this.enInit;
    data['en_issue'] = this.enIssue;
    data['en_lname'] = this.enLname;
    data['en_name'] = this.enName;
    data['error_message'] = this.errorMessage;
    data['face'] = this.face;
    data['gender'] = this.gender;
    data['home_address'] = this.homeAddress;
    data['id_number'] = this.idNumber;
    data['postal_code'] = this.postalCode;
    data['process_time'] = this.processTime;
    data['province'] = this.province;
    data['religion'] = this.religion;
    data['request_id'] = this.requestId;
    data['sub_district'] = this.subDistrict;
    data['th_dob'] = this.thDob;
    data['th_expire'] = this.thExpire;
    data['th_fname'] = this.thFname;
    data['th_init'] = this.thInit;
    data['th_issue'] = this.thIssue;
    data['th_lname'] = this.thLname;
    data['th_name'] = this.thName;
    return data;
  }
}

class Error {
  double? detectionScore;
  String? errorMessage;
  String? face;
  double? processTime;
  String? requestId;

  Error(
      {this.detectionScore,
      this.errorMessage,
      this.face,
      this.processTime,
      this.requestId});

  Error.fromJson(Map<String, dynamic> json) {
    detectionScore = json['detection_score'];
    errorMessage = json['error_message'];
    face = json['face'];
    processTime = json['process_time'];
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detection_score'] = this.detectionScore;
    data['error_message'] = this.errorMessage;
    data['face'] = this.face;
    data['process_time'] = this.processTime;
    data['request_id'] = this.requestId;
    return data;
  }
}
