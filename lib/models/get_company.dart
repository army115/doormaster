class getCompany {
  int? status;
  List<Data>? data;

  getCompany({this.status, this.data});

  getCompany.fromJson(Map<String, dynamic> json) {
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
  String? companyPic;
  String? createdBy;
  String? createdAt;
  int? beforeTimeRemain;
  int? afterTimeRemain;
  String? updatedBy;
  int? companyActive;
  String? companyUuid;
  bool? isTest;

  Data(
      {this.sId,
      this.companyName,
      this.companyPic,
      this.createdBy,
      this.createdAt,
      this.beforeTimeRemain,
      this.afterTimeRemain,
      this.updatedBy,
      this.companyActive,
      this.companyUuid,
      this.isTest});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['company_name'];
    companyPic = json['company_pic'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    beforeTimeRemain = json['before_time_remain'];
    afterTimeRemain = json['after_time_remain'];
    updatedBy = json['updated_by'];
    companyActive = json['company_active'];
    companyUuid = json['company_uuid'];
    isTest = json['isTest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['company_name'] = this.companyName;
    data['company_pic'] = this.companyPic;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['before_time_remain'] = this.beforeTimeRemain;
    data['after_time_remain'] = this.afterTimeRemain;
    data['updated_by'] = this.updatedBy;
    data['company_active'] = this.companyActive;
    data['company_uuid'] = this.companyUuid;
    data['isTest'] = this.isTest;
    return data;
  }
}
