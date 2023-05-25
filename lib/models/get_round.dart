class getRound {
  int? status;
  List<Data>? data;

  getRound({this.status, this.data});

  getRound.fromJson(Map<String, dynamic> json) {
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
  String? roundName;
  String? roundStart;
  String? roundStartFull;
  String? roundEnd;
  String? roundEndFull;
  String? companyId;
  String? createdBy;
  String? roundUuid;
  Null checked;
  String? createdAt;

  Data(
      {this.sId,
      this.roundName,
      this.roundStart,
      this.roundStartFull,
      this.roundEnd,
      this.roundEndFull,
      this.companyId,
      this.createdBy,
      this.roundUuid,
      this.checked,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roundName = json['round_name'];
    roundStart = json['round_start'];
    roundStartFull = json['round_start_full'];
    roundEnd = json['round_end'];
    roundEndFull = json['round_end_full'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    roundUuid = json['Round_uuid'];
    checked = json['checked'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['round_name'] = this.roundName;
    data['round_start'] = this.roundStart;
    data['round_start_full'] = this.roundStartFull;
    data['round_end'] = this.roundEnd;
    data['round_end_full'] = this.roundEndFull;
    data['company_id'] = this.companyId;
    data['created_by'] = this.createdBy;
    data['Round_uuid'] = this.roundUuid;
    data['checked'] = this.checked;
    data['created_at'] = this.createdAt;
    return data;
  }
}
