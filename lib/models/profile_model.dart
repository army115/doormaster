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
  String? email;
  String? image;

  Data(
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
      this.email,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
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
    email = json['email'];
    image = json['image'];
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
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
