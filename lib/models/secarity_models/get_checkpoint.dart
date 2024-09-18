class getCheckPoint {
  List<checkPoint>? data;

  getCheckPoint({this.data});

  getCheckPoint.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <checkPoint>[];
      json['data'].forEach((v) {
        data!.add(new checkPoint.fromJson(v));
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

class checkPoint {
  String? checkpointId;
  String? locationName;
  var lat;
  var lng;
  int? radius;
  int? verify;
  String? createDate;
  String? createBy;
  List<CheckpointList>? checkpointList;

  checkPoint(
      {this.checkpointId,
      this.locationName,
      this.lat,
      this.lng,
      this.radius,
      this.verify,
      this.createDate,
      this.createBy,
      this.checkpointList});

  checkPoint.fromJson(Map<String, dynamic> json) {
    checkpointId = json['checkpoint_id'];
    locationName = json['location_name'];
    lat = json['lat'];
    lng = json['lng'];
    radius = json['radius'];
    verify = json['verify'];
    createDate = json['create_date'];
    createBy = json['create_by'];
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
    data['location_name'] = this.locationName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['radius'] = this.radius;
    data['verify'] = this.verify;
    data['create_date'] = this.createDate;
    data['create_by'] = this.createBy;
    if (this.checkpointList != null) {
      data['Checkpoint_List'] =
          this.checkpointList!.map((v) => v.toJson()).toList();
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
