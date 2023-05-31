class getLogsToday {
  int? status;
  List<Data>? data;

  getLogsToday({this.status, this.data});

  getLogsToday.fromJson(Map<String, dynamic> json) {
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
  Null createdBy;
  String? createdAt;
  String? updatedBy;
  bool? checked;
  double? checkpointLat;
  double? checkpointLng;
  List<LogsToday>? logsToday;

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
      this.checked,
      this.checkpointLat,
      this.checkpointLng,
      this.logsToday});

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
    checked = json['checked'];
    checkpointLat = json['checkpoint_lat'];
    checkpointLng = json['checkpoint_lng'];
    if (json['logsToday'] != null) {
      logsToday = <LogsToday>[];
      json['logsToday'].forEach((v) {
        logsToday!.add(new LogsToday.fromJson(v));
      });
    }
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
    if (this.logsToday != null) {
      data['logsToday'] = this.logsToday!.map((v) => v.toJson()).toList();
    }
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

class LogsToday {
  String? sId;
  String? chekpointUUid;
  String? companyId;
  String? roundUuid;
  String? empID;
  String? checkTime;
  double? lat;
  double? lng;
  String? status;
  String? event;
  String? desciption;
  String? checktimeReal;
  String? date;
  String? mouth;

  LogsToday(
      {this.sId,
      this.chekpointUUid,
      this.companyId,
      this.roundUuid,
      this.empID,
      this.checkTime,
      this.lat,
      this.lng,
      this.status,
      this.event,
      this.desciption,
      this.checktimeReal,
      this.date,
      this.mouth});

  LogsToday.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chekpointUUid = json['ChekpointUUid'];
    companyId = json['company_id'];
    roundUuid = json['Round_uuid'];
    empID = json['EmpID'];
    checkTime = json['CheckTime'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['Status'];
    event = json['Event'];
    desciption = json['Desciption'];
    checktimeReal = json['checktime_real'];
    date = json['Date'];
    mouth = json['Mouth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ChekpointUUid'] = this.chekpointUUid;
    data['company_id'] = this.companyId;
    data['Round_uuid'] = this.roundUuid;
    data['EmpID'] = this.empID;
    data['CheckTime'] = this.checkTime;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['Status'] = this.status;
    data['Event'] = this.event;
    data['Desciption'] = this.desciption;
    data['checktime_real'] = this.checktimeReal;
    data['Date'] = this.date;
    data['Mouth'] = this.mouth;
    return data;
  }
}
