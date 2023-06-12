class GetProfile {
  int? status;
  List<Data>? data;

  GetProfile({this.status, this.data});

  GetProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userName;
  String? firstName;
  String? email;
  String? surName;
  String? createdBy;
  String? role;
  String? createdAt;
  String? companyId;
  int? restPassword;
  String? userPassword;
  bool? permission;
  bool? permission2;
  bool? permission3;
  bool? permission4;
  bool? qrcode;
  bool? keycard;
  bool? bluetooth;
  bool? pin;
  int? inactive;
  int? mobile;
  String? userUuid;
  String? devicegroupUuid;
  String? image;
  String? weigangroupUuid;
  int? block;

  Data(
      {this.sId,
      this.userName,
      this.firstName,
      this.email,
      this.surName,
      this.createdBy,
      this.role,
      this.createdAt,
      this.companyId,
      this.restPassword,
      this.userPassword,
      this.permission,
      this.permission2,
      this.permission3,
      this.permission4,
      this.qrcode,
      this.keycard,
      this.bluetooth,
      this.pin,
      this.inactive,
      this.mobile,
      this.userUuid,
      this.devicegroupUuid,
      this.image,
      this.weigangroupUuid,
      this.block});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    email = json['email'];
    surName = json['sur_name'];
    createdBy = json['created_by'];
    role = json['role'];
    createdAt = json['created_at'];
    companyId = json['company_id'];
    restPassword = json['rest_password'];
    userPassword = json['user_password'];
    permission = json['permission'];
    permission2 = json['permission2'];
    permission3 = json['permission3'];
    permission4 = json['permission4'];
    qrcode = json['qrcode'];
    keycard = json['keycard'];
    bluetooth = json['bluetooth'];
    pin = json['pin'];
    inactive = json['inactive'];
    mobile = json['mobile'];
    userUuid = json['user_uuid'];
    devicegroupUuid = json['devicegroup_uuid'];
    image = json['image'];
    weigangroupUuid = json['weigangroup_uuid'];
    block = json['Block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['sur_name'] = this.surName;
    data['created_by'] = this.createdBy;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['company_id'] = this.companyId;
    data['rest_password'] = this.restPassword;
    data['user_password'] = this.userPassword;
    data['permission'] = this.permission;
    data['permission2'] = this.permission2;
    data['permission3'] = this.permission3;
    data['permission4'] = this.permission4;
    data['qrcode'] = this.qrcode;
    data['keycard'] = this.keycard;
    data['bluetooth'] = this.bluetooth;
    data['pin'] = this.pin;
    data['inactive'] = this.inactive;
    data['mobile'] = this.mobile;
    data['user_uuid'] = this.userUuid;
    data['devicegroup_uuid'] = this.devicegroupUuid;
    data['image'] = this.image;
    data['weigangroup_uuid'] = this.weigangroupUuid;
    data['Block'] = this.block;
    return data;
  }
}
