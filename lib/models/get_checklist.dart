class getChecklist {
  int? status;
  List<Data>? data;

  getChecklist({this.status, this.data});

  getChecklist.fromJson(Map<String, dynamic> json) {
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
  String? checkpointName;
  String? checkpointQrcode;
  List<Checklist>? checklist;
  String? checkpointUuid;
  int? verify;
  String? companyId;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  double? checkpointLat;
  double? checkpointLng;
  bool? checked;

  Data(
      {this.sId,
      this.checkpointName,
      this.checkpointQrcode,
      this.checklist,
      this.checkpointUuid,
      this.verify,
      this.companyId,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.checkpointLat,
      this.checkpointLng,
      this.checked});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    checkpointName = json['checkpoint_name'];
    checkpointQrcode = json['checkpoint_qrcode'];
    if (json['checklist'] != null) {
      checklist = <Checklist>[];
      json['checklist'].forEach((v) {
        checklist!.add(new Checklist.fromJson(v));
      });
    }
    checkpointUuid = json['checkpoint_uuid'];
    verify = json['verify'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    checkpointLat = json['checkpoint_lat'];
    checkpointLng = json['checkpoint_lng'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['checkpoint_name'] = this.checkpointName;
    data['checkpoint_qrcode'] = this.checkpointQrcode;
    if (this.checklist != null) {
      data['checklist'] = this.checklist!.map((v) => v.toJson()).toList();
    }
    data['checkpoint_uuid'] = this.checkpointUuid;
    data['verify'] = this.verify;
    data['company_id'] = this.companyId;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['checkpoint_lat'] = this.checkpointLat;
    data['checkpoint_lng'] = this.checkpointLng;
    data['checked'] = this.checked;
    return data;
  }
}

class Checklist {
  String? checklist;

  Checklist({this.checklist});

  Checklist.fromJson(Map<String, dynamic> json) {
    checklist = json['checklist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checklist'] = this.checklist;
    return data;
  }
}
