class VisitorModel {
  int? status;
  Data? data;
  String? startDate;
  String? endDate;
  String? usableCount;
  String? visitorName;
  String? visitorPeople;
  String? telVisitor;
  Qrcode? qrcode;

  VisitorModel(
      {this.status,
      this.data,
      this.startDate,
      this.endDate,
      this.usableCount,
      this.visitorName,
      this.visitorPeople,
      this.telVisitor,
      this.qrcode});

  VisitorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    usableCount = json['usableCount'];
    visitorName = json['visitor_name'];
    visitorPeople = json['visitor_people'];
    telVisitor = json['tel_visitor'];
    qrcode =
        json['qrcode'] != null ? new Qrcode.fromJson(json['qrcode']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['usableCount'] = this.usableCount;
    data['visitor_name'] = this.visitorName;
    data['visitor_people'] = this.visitorPeople;
    data['tel_visitor'] = this.telVisitor;
    if (this.qrcode != null) {
      data['qrcode'] = this.qrcode!.toJson();
    }
    return data;
  }
}

class Data {
  int? fieldCount;
  int? affectedRows;
  int? insertId;
  String? info;
  int? serverStatus;
  int? warningStatus;

  Data(
      {this.fieldCount,
      this.affectedRows,
      this.insertId,
      this.info,
      this.serverStatus,
      this.warningStatus});

  Data.fromJson(Map<String, dynamic> json) {
    fieldCount = json['fieldCount'];
    affectedRows = json['affectedRows'];
    insertId = json['insertId'];
    info = json['info'];
    serverStatus = json['serverStatus'];
    warningStatus = json['warningStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldCount'] = this.fieldCount;
    data['affectedRows'] = this.affectedRows;
    data['insertId'] = this.insertId;
    data['info'] = this.info;
    data['serverStatus'] = this.serverStatus;
    data['warningStatus'] = this.warningStatus;
    return data;
  }
}

class Qrcode {
  int? id;
  String? tempPwd;
  String? tempCode;
  String? uuid;
  String? qrCode;

  Qrcode({this.id, this.tempPwd, this.tempCode, this.uuid, this.qrCode});

  Qrcode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tempPwd = json['tempPwd'];
    tempCode = json['tempCode'];
    uuid = json['uuid'];
    qrCode = json['qrCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tempPwd'] = this.tempPwd;
    data['tempCode'] = this.tempCode;
    data['uuid'] = this.uuid;
    data['qrCode'] = this.qrCode;
    return data;
  }
}
