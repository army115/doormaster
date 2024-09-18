class createCompany {
  int? status;
  String? companyId;
  String? sId;

  createCompany({this.status, this.companyId, this.sId});

  createCompany.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    companyId = json['company_id'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['company_id'] = this.companyId;
    data['_id'] = this.sId;
    return data;
  }
}
