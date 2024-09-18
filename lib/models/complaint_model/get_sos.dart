class get_sos {
  List<Data>? data;

  get_sos({this.data});

  get_sos.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? rowId;
  String? docId;
  String? docName;
  double? latitude;
  double? longitude;
  String? employeeNo;
  String? description;
  String? imgPath;
  String? status;
  String? createDate;
  int? statusId;

  Data(
      {this.rowId,
      this.docId,
      this.docName,
      this.latitude,
      this.longitude,
      this.employeeNo,
      this.description,
      this.imgPath,
      this.status,
      this.createDate,
      this.statusId});

  Data.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    docId = json['doc_id'];
    docName = json['doc_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    employeeNo = json['employee_no'];
    description = json['description'];
    imgPath = json['imgPath'];
    status = json['status'];
    createDate = json['create_date'];
    statusId = json['status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['doc_id'] = this.docId;
    data['doc_name'] = this.docName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['employee_no'] = this.employeeNo;
    data['description'] = this.description;
    data['imgPath'] = this.imgPath;
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['status_id'] = this.statusId;
    return data;
  }
}
