class get_complaint {
  List<Data>? data;

  get_complaint({this.data});

  get_complaint.fromJson(Map<String, dynamic> json) {
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
  String? complaintType;
  String? status;
  String? createDate;
  String? complaintImg;
  String? description;
  int? statusId;

  Data(
      {this.rowId,
      this.docId,
      this.docName,
      this.complaintType,
      this.status,
      this.createDate,
      this.complaintImg,
      this.description,
      this.statusId});

  Data.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    docId = json['doc_id'];
    docName = json['doc_name'];
    complaintType = json['complaint_type'];
    status = json['status'];
    createDate = json['create_date'];
    complaintImg = json['complaintImg'];
    description = json['description'];
    statusId = json['status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['doc_id'] = this.docId;
    data['doc_name'] = this.docName;
    data['complaint_type'] = this.complaintType;
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['complaintImg'] = this.complaintImg;
    data['description'] = this.description;
    data['status_id'] = this.statusId;
    return data;
  }
}
