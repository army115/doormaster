class LoginModel {
  int? status;
  String? token;
  List<User>? user;

  LoginModel({this.status, this.token, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
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
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? userId;
  String? username;
  String? firstName;
  String? devicegroupUuid;
  String? lastName;
  String? password;
  String? email;
  int? department;
  int? position;
  int? companyId;
  int? role;
  int? mobile;
  int? qrcode;
  int? keycard;
  int? bluetooth;
  int? pin;

  User(
      {this.userId,
      this.username,
      this.firstName,
      this.devicegroupUuid,
      this.lastName,
      this.password,
      this.email,
      this.department,
      this.position,
      this.companyId,
      this.role,
      this.mobile,
      this.qrcode,
      this.keycard,
      this.bluetooth,
      this.pin});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    firstName = json['first_name'];
    devicegroupUuid = json['devicegroup_uuid'];
    lastName = json['last_name'];
    password = json['password'];
    email = json['email'];
    department = json['department'];
    position = json['position'];
    companyId = json['company_id'];
    role = json['role'];
    mobile = json['mobile'];
    qrcode = json['qrcode'];
    keycard = json['keycard'];
    bluetooth = json['bluetooth'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['devicegroup_uuid'] = this.devicegroupUuid;
    data['last_name'] = this.lastName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['department'] = this.department;
    data['position'] = this.position;
    data['company_id'] = this.companyId;
    data['role'] = this.role;
    data['mobile'] = this.mobile;
    data['qrcode'] = this.qrcode;
    data['keycard'] = this.keycard;
    data['bluetooth'] = this.bluetooth;
    data['pin'] = this.pin;
    return data;
  }
}
