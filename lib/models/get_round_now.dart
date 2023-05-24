class getRoundNow {
  int? status;
  List<Data>? data;

  getRoundNow({this.status, this.data});

  getRoundNow.fromJson(Map<String, dynamic> json) {
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
  List<LogsList>? logsList;

  Data(
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
      this.logsList});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (json['logsList'] != null) {
      logsList = <LogsList>[];
      json['logsList'].forEach((v) {
        logsList!.add(new LogsList.fromJson(v));
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
    if (this.logsList != null) {
      data['logsList'] = this.logsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LogsList {
  String? sId;
  String? chekpointUUid;
  String? companyId;
  String? roundUuid;
  String? empID;
  String? checkTime;
  String? event;
  String? desciption;
  String? date;
  List<Checkpoint>? checkpoint;

  LogsList(
      {this.sId,
      this.chekpointUUid,
      this.companyId,
      this.roundUuid,
      this.empID,
      this.checkTime,
      this.event,
      this.desciption,
      this.date,
      this.checkpoint});

  LogsList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chekpointUUid = json['ChekpointUUid'];
    companyId = json['company_id'];
    roundUuid = json['Round_uuid'];
    empID = json['EmpID'];
    checkTime = json['CheckTime'];
    event = json['Event'];
    desciption = json['Desciption'];
    date = json['Date'];
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
    data['Round_uuid'] = this.roundUuid;
    data['EmpID'] = this.empID;
    data['CheckTime'] = this.checkTime;
    data['Event'] = this.event;
    data['Desciption'] = this.desciption;
    data['Date'] = this.date;
    if (this.checkpoint != null) {
      data['checkpoint'] = this.checkpoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Checkpoint {
  String? sId;
  String? checkpointName;
  String? checkpointUuid;
  int? verify;
  String? companyId;

  Checkpoint(
      {this.sId,
      this.checkpointName,
      this.checkpointUuid,
      this.verify,
      this.companyId});

  Checkpoint.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    checkpointName = json['checkpoint_name'];
    checkpointUuid = json['checkpoint_uuid'];
    verify = json['verify'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['checkpoint_name'] = this.checkpointName;
    data['checkpoint_uuid'] = this.checkpointUuid;
    data['verify'] = this.verify;
    data['company_id'] = this.companyId;
    return data;
  }
}
