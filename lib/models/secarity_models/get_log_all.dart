class getLogs_All {
  List<logAll>? data;

  getLogs_All({this.data});

  getLogs_All.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <logAll>[];
      json['data'].forEach((v) {
        data!.add(new logAll.fromJson(v));
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

class logAll {
  String? inspectId;
  String? inspectName;
  String? startDate;
  String? endDate;
  String? companyId;
  List<Logs>? logs;

  logAll(
      {this.inspectId,
      this.inspectName,
      this.startDate,
      this.endDate,
      this.companyId,
      this.logs});

  logAll.fromJson(Map<String, dynamic> json) {
    inspectId = json['inspect_id'];
    inspectName = json['inspect_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    companyId = json['company_id'];
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inspect_id'] = this.inspectId;
    data['inspect_name'] = this.inspectName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['company_id'] = this.companyId;
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Logs {
  String? checkpointId;
  String? guardLogId;
  String? status;
  String? event;
  String? lat;
  String? lng;
  String? description;
  String? createDate;
  String? radius;
  String? locationName;
  List<CheckpointList>? checkpointList;

  Logs(
      {this.checkpointId,
      this.guardLogId,
      this.status,
      this.event,
      this.lat,
      this.lng,
      this.description,
      this.createDate,
      this.radius,
      this.locationName,
      this.checkpointList});

  Logs.fromJson(Map<String, dynamic> json) {
    checkpointId = json['checkpoint_id'];
    guardLogId = json['guard_log_id'];
    status = json['status'];
    event = json['event'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    createDate = json['create_date'];
    radius = json['radius'];
    locationName = json['location_name'];
    if (json['Checkpoint_List'] != null) {
      checkpointList = <CheckpointList>[];
      json['Checkpoint_List'].forEach((v) {
        checkpointList!.add(new CheckpointList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_id'] = this.checkpointId;
    data['guard_log_id'] = this.guardLogId;
    data['status'] = this.status;
    data['event'] = this.event;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['description'] = this.description;
    data['create_date'] = this.createDate;
    data['radius'] = this.radius;
    data['location_name'] = this.locationName;
    if (this.checkpointList != null) {
      data['Checkpoint_List'] =
          this.checkpointList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckpointList {
  String? checkpointName;
  String? checkpointListId;

  CheckpointList({this.checkpointName, this.checkpointListId});

  CheckpointList.fromJson(Map<String, dynamic> json) {
    checkpointName = json['checkpoint_name'];
    checkpointListId = json['checkpoint_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_name'] = this.checkpointName;
    data['checkpoint_list_id'] = this.checkpointListId;
    return data;
  }
}
