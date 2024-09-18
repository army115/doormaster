class getProfile {
  Data? data;

  getProfile({this.data});

  getProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? employeeNo;
  String? profileImg;
  String? firstName;
  String? lastName;
  String? sex;
  String? phone;
  String? email;
  int? roleId;

  Data(
      {this.employeeNo,
      this.profileImg,
      this.firstName,
      this.lastName,
      this.sex,
      this.phone,
      this.email,
      this.roleId});

  Data.fromJson(Map<String, dynamic> json) {
    employeeNo = json['employee_no'];
    profileImg = json['profileImg'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    sex = json['sex'];
    phone = json['phone'];
    email = json['email'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_no'] = employeeNo;
    data['profileImg'] = profileImg;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['sex'] = sex;
    data['phone'] = phone;
    data['email'] = email;
    data['role_id'] = roleId;
    return data;
  }
}
