class getLog {
  int? status;
  List<DataLog>? data;

  getLog({this.status, this.data});

  getLog.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataLog>[];
      json['data'].forEach((v) {
        data!.add(new DataLog.fromJson(v));
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

class DataLog {
  String? sId;
  String? roundName;
  String? roundStart;
  String? roundStartFull;
  String? roundEnd;
  String? roundEndFull;
  String? companyId;
  String? createdBy;
  String? roundUuid;
  Null? checked;
  String? createdAt;
  List<FileList>? fileList;

  DataLog(
      {this.sId,
      this.roundName,
      this.roundStart,
      this.roundStartFull,
      this.roundEnd,
      this.roundEndFull,
      this.companyId,
      this.createdBy,
      this.roundUuid,
      this.checked,
      this.createdAt,
      this.fileList});

  DataLog.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roundName = json['round_name'];
    roundStart = json['round_start'];
    roundStartFull = json['round_start_full'];
    roundEnd = json['round_end'];
    roundEndFull = json['round_end_full'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    roundUuid = json['Round_uuid'];
    checked = json['checked'];
    createdAt = json['created_at'];
    if (json['fileList'] != null) {
      fileList = <FileList>[];
      json['fileList'].forEach((v) {
        fileList!.add(new FileList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['round_name'] = this.roundName;
    data['round_start'] = this.roundStart;
    data['round_start_full'] = this.roundStartFull;
    data['round_end'] = this.roundEnd;
    data['round_end_full'] = this.roundEndFull;
    data['company_id'] = this.companyId;
    data['created_by'] = this.createdBy;
    data['Round_uuid'] = this.roundUuid;
    data['checked'] = this.checked;
    data['created_at'] = this.createdAt;
    if (this.fileList != null) {
      data['fileList'] = this.fileList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FileList {
  String? sId;
  String? chekpointUUid;
  String? companyId;
  String? shift;
  String? roundUuid;
  String? empID;
  String? checkTime;
  double? lat;
  double? lng;
  // List<String>? pic;
  String? timeInvalid;
  String? status;
  String? event;
  String? desciption;
  String? checktimeReal;
  String? date;
  String? mouth;
  List<Checkpoint>? checkpoint;

  FileList(
      {this.sId,
      this.chekpointUUid,
      this.companyId,
      this.shift,
      this.roundUuid,
      this.empID,
      this.checkTime,
      this.lat,
      this.lng,
      // this.pic,
      this.timeInvalid,
      this.status,
      this.event,
      this.desciption,
      this.checktimeReal,
      this.date,
      this.mouth,
      this.checkpoint});

  FileList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chekpointUUid = json['ChekpointUUid'];
    companyId = json['company_id'];
    shift = json['Shift'];
    roundUuid = json['Round_uuid'];
    empID = json['EmpID'];
    checkTime = json['CheckTime'];
    lat = json['lat'];
    lng = json['lng'];
    // pic = json['pic'].cast<String>();
    timeInvalid = json['TimeInvalid'];
    status = json['Status'];
    event = json['Event'];
    desciption = json['Desciption'];
    checktimeReal = json['checktime_real'];
    date = json['Date'];
    mouth = json['Mouth'];
    if (json['checkpoint'] != null) {
      checkpoint = <Checkpoint>[];
      json['checkpoint'].forEach((v) {
        checkpoint!.add(new Checkpoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ChekpointUUid'] = this.chekpointUUid;
    data['company_id'] = this.companyId;
    data['Shift'] = this.shift;
    data['Round_uuid'] = this.roundUuid;
    data['EmpID'] = this.empID;
    data['CheckTime'] = this.checkTime;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    // data['pic'] = this.pic;
    data['TimeInvalid'] = this.timeInvalid;
    data['Status'] = this.status;
    data['Event'] = this.event;
    data['Desciption'] = this.desciption;
    data['checktime_real'] = this.checktimeReal;
    data['Date'] = this.date;
    data['Mouth'] = this.mouth;
    if (this.checkpoint != null) {
      data['checkpoint'] = this.checkpoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Checkpoint {
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
  bool? checked;
  double? checkpointLat;
  double? checkpointLng;

  Checkpoint(
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
      this.checked,
      this.checkpointLat,
      this.checkpointLng});

  Checkpoint.fromJson(Map<String, dynamic> json) {
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
    checked = json['checked'];
    checkpointLat = json['checkpoint_lat'];
    checkpointLng = json['checkpoint_lng'];
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
    data['checked'] = this.checked;
    data['checkpoint_lat'] = this.checkpointLat;
    data['checkpoint_lng'] = this.checkpointLng;
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
