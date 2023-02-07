class getMultiCompany {
  int? status;
  List<Data>? data;

  getMultiCompany({this.status, this.data});

  getMultiCompany.fromJson(Map<String, dynamic> json) {
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
  String? companyName;
  String? companyUuid;
  String? userName;
  String? firstName;
  String? surName;
  String? companyId;

  Data(
      {this.sId,
      this.companyName,
      this.companyUuid,
      this.userName,
      this.firstName,
      this.surName,
      this.companyId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['company_name'];
    companyUuid = json['company_uuid'];
    userName = json['user_name'];
    firstName = json['first_name'];
    surName = json['sur_name'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['company_name'] = this.companyName;
    data['company_uuid'] = this.companyUuid;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['sur_name'] = this.surName;
    data['company_id'] = this.companyId;
    return data;
  }
}
