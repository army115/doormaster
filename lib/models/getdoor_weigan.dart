class getDoorWeigan {
  List<DataWeigan>? data;

  getDoorWeigan({this.data});

  getDoorWeigan.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataWeigan>[];
      json['data'].forEach((v) {
        data!.add(new DataWeigan.fromJson(v));
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

class DataWeigan {
  String? sId;
  String? weigangroupUuid;
  String? companyId;
  String? weigangroupDevice;
  String? weigangroupName;
  String? createdBy;
  String? createdAt;
  List<Det>? det;

  DataWeigan(
      {this.sId,
      this.weigangroupUuid,
      this.companyId,
      this.weigangroupDevice,
      this.weigangroupName,
      this.createdBy,
      this.createdAt,
      this.det});

  DataWeigan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    weigangroupUuid = json['weigangroup_uuid'];
    companyId = json['company_id'];
    weigangroupDevice = json['weigangroup_device'];
    weigangroupName = json['weigangroup_name'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    if (json['det'] != null) {
      det = <Det>[];
      json['det'].forEach((v) {
        det!.add(new Det.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['weigangroup_uuid'] = this.weigangroupUuid;
    data['company_id'] = this.companyId;
    data['weigangroup_device'] = this.weigangroupDevice;
    data['weigangroup_name'] = this.weigangroupName;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    if (this.det != null) {
      data['det'] = this.det!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Det {
  String? doorId;
  int? doorNum;
  String? doorName;

  Det({this.doorId, this.doorNum, this.doorName});

  Det.fromJson(Map<String, dynamic> json) {
    doorId = json['door_id'];
    doorNum = json['door_num'];
    doorName = json['door_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['door_id'] = this.doorId;
    data['door_num'] = this.doorNum;
    data['door_name'] = this.doorName;
    return data;
  }
}
