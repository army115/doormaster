class getLogs_Round {
  List<logRound>? data;

  getLogs_Round({this.data});

  getLogs_Round.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <logRound>[];
      json['data'].forEach((v) {
        data!.add(new logRound.fromJson(v));
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

class logRound {
  String? checkpointId;
  String? locationName;
  var lat;
  var lng;
  int? radius;
  int? verify;
  List<CheckpointList>? checkpointList;
  List<Logs>? logs;

  logRound(
      {this.checkpointId,
      this.locationName,
      this.lat,
      this.lng,
      this.radius,
      this.verify,
      this.checkpointList,
      this.logs});

  logRound.fromJson(Map<String, dynamic> json) {
    checkpointId = json['checkpoint_id'];
    locationName = json['location_name'];
    lat = json['lat'];
    lng = json['lng'];
    radius = json['radius'];
    verify = json['verify'];
    if (json['Checkpoint_List'] != null) {
      checkpointList = <CheckpointList>[];
      json['Checkpoint_List'].forEach((v) {
        checkpointList!.add(new CheckpointList.fromJson(v));
      });
    }
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_id'] = this.checkpointId;
    data['location_name'] = this.locationName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['radius'] = this.radius;
    data['verify'] = this.verify;
    if (this.checkpointList != null) {
      data['Checkpoint_List'] =
          this.checkpointList!.map((v) => v.toJson()).toList();
    }
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckpointList {
  String? checkpointListId;
  String? checkpointName;

  CheckpointList({this.checkpointListId, this.checkpointName});

  CheckpointList.fromJson(Map<String, dynamic> json) {
    checkpointListId = json['checkpoint_list_id'];
    checkpointName = json['checkpoint_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_list_id'] = this.checkpointListId;
    data['checkpoint_name'] = this.checkpointName;
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

  Logs(
      {this.checkpointId,
      this.guardLogId,
      this.status,
      this.event,
      this.lat,
      this.lng,
      this.description,
      this.createDate});

  Logs.fromJson(Map<String, dynamic> json) {
    checkpointId = json['checkpoint_id'];
    guardLogId = json['guard_log_id'];
    status = json['status'];
    event = json['event'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    createDate = json['create_date'];
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
    return data;
  }
}
