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
  String? roundName;
  String? companyId;
  List<FileList>? fileList;
  String? sId;
  String? roundStart;
  String? roundStartFull;
  String? roundEnd;
  String? roundEndFull;
  String? createdBy;
  String? roundUuid;
  String? createdAt;

  DataLog(
      {this.roundName,
      this.companyId,
      this.fileList,
      this.sId,
      this.roundStart,
      this.roundStartFull,
      this.roundEnd,
      this.roundEndFull,
      this.createdBy,
      this.roundUuid,
      this.createdAt});

  DataLog.fromJson(Map<String, dynamic> json) {
    roundName = json['round_name'];
    companyId = json['company_id'];
    if (json['fileList'] != null) {
      fileList = <FileList>[];
      json['fileList'].forEach((v) {
        fileList!.add(new FileList.fromJson(v));
      });
    }
    sId = json['_id'];
    roundStart = json['round_start'];
    roundStartFull = json['round_start_full'];
    roundEnd = json['round_end'];
    roundEndFull = json['round_end_full'];
    createdBy = json['created_by'];
    roundUuid = json['Round_uuid'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['round_name'] = this.roundName;
    data['company_id'] = this.companyId;
    if (this.fileList != null) {
      data['fileList'] = this.fileList!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['round_start'] = this.roundStart;
    data['round_start_full'] = this.roundStartFull;
    data['round_end'] = this.roundEnd;
    data['round_end_full'] = this.roundEndFull;
    data['created_by'] = this.createdBy;
    data['Round_uuid'] = this.roundUuid;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class FileList {
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
  List<Checkpoint>? checkpoint;
  String? checkpointName;
  List<String>? checkList;

  FileList(
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
      this.mouth,
      this.checkpoint,
      this.checkpointName,
      this.checkList});

  FileList.fromJson(Map<String, dynamic> json) {
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
    if (json['checkpoint'] != null) {
      checkpoint = <Checkpoint>[];
      json['checkpoint'].forEach((v) {
        checkpoint!.add(new Checkpoint.fromJson(v));
      });
    }
    checkpointName = json['checkpoint_name'];
    if (json['CheckList'] != null) {
      checkList = json['CheckList'].cast<String>();
    }
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
    if (this.checkpoint != null) {
      data['checkpoint'] = this.checkpoint!.map((v) => v.toJson()).toList();
    }
    data['checkpoint_name'] = this.checkpointName;
    data['CheckList'] = this.checkList;
    return data;
  }
}

class Checkpoint {
  String? sId;
  String? checkpointName;
  String? checkpointUuid;
  String? companyId;
  double? checkpointLat;
  double? checkpointLng;
  List<String>? checklist;

  Checkpoint(
      {this.sId,
      this.checkpointName,
      this.checkpointUuid,
      this.companyId,
      this.checkpointLat,
      this.checkpointLng,
      this.checklist});

  Checkpoint.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    checkpointName = json['checkpoint_name'];
    checkpointUuid = json['checkpoint_uuid'];
    companyId = json['company_id'];
    checkpointLat = json['checkpoint_lat'];
    checkpointLng = json['checkpoint_lng'];
    checklist = json['checklist'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['checkpoint_name'] = this.checkpointName;
    data['checkpoint_uuid'] = this.checkpointUuid;
    data['company_id'] = this.companyId;
    data['checkpoint_lat'] = this.checkpointLat;
    data['checkpoint_lng'] = this.checkpointLng;
    data['checklist'] = this.checklist;
    return data;
  }
}
