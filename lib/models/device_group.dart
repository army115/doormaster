class DeviceGroup {
  int? status;
  List<DataDrvices>? data;

  DeviceGroup({this.status, this.data});

  DeviceGroup.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataDrvices>[];
      json['data'].forEach((v) {
        data!.add(new DataDrvices.fromJson(v));
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

class DataDrvices {
  String? sId;
  String? deviceDevSn;
  String? deviceName;
  String? companyId;

  DataDrvices({this.sId, this.deviceDevSn, this.deviceName, this.companyId});

  DataDrvices.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deviceDevSn = json['device_devSn'];
    deviceName = json['device_name'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['device_devSn'] = this.deviceDevSn;
    data['device_name'] = this.deviceName;
    data['company_id'] = this.companyId;
    return data;
  }
}
