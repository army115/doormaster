class WiegandModel {
  int? status;
  String? startDate;
  String? endDate;
  String? usableCount;
  String? visitorName;
  String? visitorPeople;
  String? telVisitor;
  String? typeDevices;
  String? qrcode;

  WiegandModel(
      {this.status,
      this.startDate,
      this.endDate,
      this.usableCount,
      this.visitorName,
      this.visitorPeople,
      this.telVisitor,
      this.typeDevices,
      this.qrcode});

  WiegandModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    usableCount = json['usableCount'];
    visitorName = json['visitor_name'];
    visitorPeople = json['visitor_people'];
    telVisitor = json['tel_visitor'];
    typeDevices = json['typeDevices'];
    qrcode = json['qrcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['usableCount'] = this.usableCount;
    data['visitor_name'] = this.visitorName;
    data['visitor_people'] = this.visitorPeople;
    data['tel_visitor'] = this.telVisitor;
    data['typeDevices'] = this.typeDevices;
    data['qrcode'] = this.qrcode;
    return data;
  }
}
