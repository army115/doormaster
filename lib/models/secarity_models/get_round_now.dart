class getRound_Now {
  List<roundNow>? data;

  getRound_Now({this.data});

  getRound_Now.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <roundNow>[];
      json['data'].forEach((v) {
        data!.add(new roundNow.fromJson(v));
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

class roundNow {
  String? inspectId;
  String? inspectName;
  String? startDate;
  String? endDate;
  List<InspectDetail>? inspectDetail;
  List<Logs>? logs;

  roundNow(
      {this.inspectId,
      this.inspectName,
      this.startDate,
      this.endDate,
      this.inspectDetail,
      this.logs});

  roundNow.fromJson(Map<String, dynamic> json) {
    inspectId = json['inspect_id'];
    inspectName = json['inspect_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['Inspect_detail'] != null) {
      inspectDetail = <InspectDetail>[];
      json['Inspect_detail'].forEach((v) {
        inspectDetail!.add(new InspectDetail.fromJson(v));
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
    data['inspect_id'] = this.inspectId;
    data['inspect_name'] = this.inspectName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.inspectDetail != null) {
      data['Inspect_detail'] =
          this.inspectDetail!.map((v) => v.toJson()).toList();
    }
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InspectDetail {
  String? checkpointId;
  int? radius;
  String? locationName;
  var lat;
  var long;
  int? verify;
  bool? isOther;

  InspectDetail(
      {this.checkpointId,
      this.radius,
      this.locationName,
      this.lat,
      this.long,
      this.verify,
      this.isOther});

  InspectDetail.fromJson(Map<String, dynamic> json) {
    checkpointId = json['checkpoint_id'];
    radius = json['radius'];
    locationName = json['location_name'];
    lat = json['lat'];
    long = json['long'];
    verify = json['verify'];
    isOther = json['is_other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_id'] = this.checkpointId;
    data['radius'] = this.radius;
    data['location_name'] = this.locationName;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['verify'] = this.verify;
    data['is_other'] = this.isOther;
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
