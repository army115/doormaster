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
      this.devicegroupUuid});

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
    return data;
  }
}
