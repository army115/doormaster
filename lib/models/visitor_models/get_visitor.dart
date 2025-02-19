class GetVisitor {
  Data? data;

  GetVisitor({this.data});

  GetVisitor.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? houseId;
  String? visitorName;
  String? meetName;
  String? startDate;
  String? endDate;
  String? phone;
  String? description;
  String? branchId;
  int? qrcodeNo;
  String? plateNum;

  Data(
      {this.id,
      this.houseId,
      this.visitorName,
      this.meetName,
      this.startDate,
      this.endDate,
      this.phone,
      this.description,
      this.branchId,
      this.qrcodeNo,
      this.plateNum});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseId = json['house_id'];
    visitorName = json['visitor_name'];
    meetName = json['meet_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    phone = json['phone'];
    description = json['description'];
    branchId = json['branch_id'];
    qrcodeNo = json['qrcode_no'];
    plateNum = json['plate_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['house_id'] = this.houseId;
    data['visitor_name'] = this.visitorName;
    data['meet_name'] = this.meetName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['phone'] = this.phone;
    data['description'] = this.description;
    data['branch_id'] = this.branchId;
    data['qrcode_no'] = this.qrcodeNo;
    data['plate_num'] = this.plateNum;
    return data;
  }
}
