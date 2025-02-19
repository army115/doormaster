class getParking {
  String? parkingId;
  String? start;
  String? end;
  int? amount;
  int? netAmount;
  int? amountPaid;
  int? minute;
  int? discount;
  String? plateNum;
  List<EstampAvail>? estampAvail;

  getParking(
      {this.parkingId,
      this.start,
      this.end,
      this.amount,
      this.netAmount,
      this.amountPaid,
      this.minute,
      this.discount,
      this.plateNum,
      this.estampAvail});

  getParking.fromJson(Map<String, dynamic> json) {
    parkingId = json['parking_id'];
    start = json['start'];
    end = json['end'];
    amount = json['amount'];
    netAmount = json['net_amount'];
    amountPaid = json['amount_paid'];
    minute = json['minute'];
    discount = json['discount'];
    plateNum = json['plate_num'];
    if (json['estamp_avail'] != null) {
      estampAvail = <EstampAvail>[];
      json['estamp_avail'].forEach((v) {
        estampAvail!.add(new EstampAvail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_id'] = this.parkingId;
    data['start'] = this.start;
    data['end'] = this.end;
    data['amount'] = this.amount;
    data['net_amount'] = this.netAmount;
    data['amount_paid'] = this.amountPaid;
    data['minute'] = this.minute;
    data['discount'] = this.discount;
    data['plate_num'] = this.plateNum;
    if (this.estampAvail != null) {
      data['estamp_avail'] = this.estampAvail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EstampAvail {
  String? estampName;
  String? estampId;
  int? availAmount;

  EstampAvail({this.estampName, this.estampId, this.availAmount});

  EstampAvail.fromJson(Map<String, dynamic> json) {
    estampName = json['estamp_name'];
    estampId = json['estamp_id'];
    availAmount = json['avail_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estamp_name'] = this.estampName;
    data['estamp_id'] = this.estampId;
    data['avail_amount'] = this.availAmount;
    return data;
  }
}
