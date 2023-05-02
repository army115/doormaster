class LoginModel {
  int? status;
  int? data;
  String? name;
  String? email;
  String? accessToken;
  List<User>? user;

  LoginModel(
      {this.status,
      this.data,
      this.name,
      this.email,
      this.accessToken,
      this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    name = json['name'];
    email = json['email'];
    accessToken = json['accessToken'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['name'] = this.name;
    data['email'] = this.email;
    data['accessToken'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? sId;
  String? userName;
  String? firstName;
  String? surName;
  String? role;
  String? createdBy;
  String? createdAt;
  String? companyId;
  String? userPassword;
  int? restPassword;
  String? oldPassword;
  int? inactive;
  int? mobile;
  String? devicegroupUuid;
  String? department;
  bool? permission;
  bool? permission2;
  bool? permission3;
  bool? permission4;
  bool? qrcode;
  bool? keycard;
  bool? bluetooth;
  bool? pin;
  String? email;
  String? userUuid;
  String? weigangroupUuid;
  bool? isSecurity;
  String? image;
  int? block;

  User(
      {this.sId,
      this.userName,
      this.firstName,
      this.surName,
      this.role,
      this.createdBy,
      this.createdAt,
      this.companyId,
      this.userPassword,
      this.restPassword,
      this.oldPassword,
      this.inactive,
      this.mobile,
      this.devicegroupUuid,
      this.department,
      this.permission,
      this.permission2,
      this.permission3,
      this.permission4,
      this.qrcode,
      this.keycard,
      this.bluetooth,
      this.pin,
      this.email,
      this.userUuid,
      this.weigangroupUuid,
      this.isSecurity,
      this.image,
      this.block});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    surName = json['sur_name'];
    role = json['role'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    companyId = json['company_id'];
    userPassword = json['user_password'];
    restPassword = json['rest_password'];
    oldPassword = json['old_password'];
    inactive = json['inactive'];
    mobile = json['mobile'];
    devicegroupUuid = json['devicegroup_uuid'];
    department = json['department'];
    permission = json['permission'];
    permission2 = json['permission2'];
    permission3 = json['permission3'];
    permission4 = json['permission4'];
    qrcode = json['qrcode'];
    keycard = json['keycard'];
    bluetooth = json['bluetooth'];
    pin = json['pin'];
    email = json['email'];
    userUuid = json['user_uuid'];
    weigangroupUuid = json['weigangroup_uuid'];
    isSecurity = json['isSecurity'];
    image = json['image'];
    block = json['Block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['sur_name'] = this.surName;
    data['role'] = this.role;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['company_id'] = this.companyId;
    data['user_password'] = this.userPassword;
    data['rest_password'] = this.restPassword;
    data['old_password'] = this.oldPassword;
    data['inactive'] = this.inactive;
    data['mobile'] = this.mobile;
    data['devicegroup_uuid'] = this.devicegroupUuid;
    data['department'] = this.department;
    data['permission'] = this.permission;
    data['permission2'] = this.permission2;
    data['permission3'] = this.permission3;
    data['permission4'] = this.permission4;
    data['qrcode'] = this.qrcode;
    data['keycard'] = this.keycard;
    data['bluetooth'] = this.bluetooth;
    data['pin'] = this.pin;
    data['email'] = this.email;
    data['user_uuid'] = this.userUuid;
    data['weigangroup_uuid'] = this.weigangroupUuid;
    data['isSecurity'] = this.isSecurity;
    data['image'] = this.image;
    data['Block'] = this.block;
    return data;
  }
}
