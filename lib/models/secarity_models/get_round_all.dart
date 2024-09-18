class getRound_All {
  List<roundAll>? data;

  getRound_All({this.data});

  getRound_All.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <roundAll>[];
      json['data'].forEach((v) {
        data!.add(new roundAll.fromJson(v));
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

class roundAll {
  String? inspectId;
  String? inspectName;
  String? startDate;
  String? endDate;
  List<InspectDetail>? inspectDetail;

  roundAll(
      {this.inspectId,
      this.inspectName,
      this.startDate,
      this.endDate,
      this.inspectDetail});

  roundAll.fromJson(Map<String, dynamic> json) {
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
