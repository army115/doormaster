class getLogsAll {
  int? status;
  List<Data>? data;

  getLogsAll({this.status, this.data});

  getLogsAll.fromJson(Map<String, dynamic> json) {
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
  String? chekpointUUid;
  String? companyId;
  String? shift;
  String? roundUuid;
  String? empID;
  String? checkTime;
  List<String>? pic;
  String? timeInvalid;
  double? lat;
  double? lng;
  String? status;
  String? event;
  String? desciption;
  String? checktimeReal;
  String? date;
  String? mouth;

  Data(
      {this.sId,
      this.chekpointUUid,
      this.companyId,
      this.shift,
      this.roundUuid,
      this.empID,
      this.checkTime,
      this.pic,
      this.timeInvalid,
      this.lat,
      this.lng,
      this.status,
      this.event,
      this.desciption,
      this.checktimeReal,
      this.date,
      this.mouth});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chekpointUUid = json['ChekpointUUid'];
    companyId = json['company_id'];
    shift = json['Shift'];
    roundUuid = json['Round_uuid'];
    empID = json['EmpID'];
    checkTime = json['CheckTime'];
    pic = json['pic'].cast<String>();
    timeInvalid = json['TimeInvalid'];
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
    data['Shift'] = this.shift;
    data['Round_uuid'] = this.roundUuid;
    data['EmpID'] = this.empID;
    data['CheckTime'] = this.checkTime;
    data['pic'] = this.pic;
    data['TimeInvalid'] = this.timeInvalid;
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
