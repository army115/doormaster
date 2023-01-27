class DeviceGroup {
  int? count;
  List<Device>? device;

  DeviceGroup({this.count, this.device});

  DeviceGroup.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['device'] != null) {
      device = <Device>[];
      json['device'].forEach((v) {
        device!.add(new Device.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.device != null) {
      data['device'] = this.device!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Device {
  String? sId;
  String? devicegroupUuid;
  String? companyId;
  String? devicegroupDevice;
  String? devicegroupName;
  String? createdBy;
  String? createdAt;

  Device(
      {this.sId,
      this.devicegroupUuid,
      this.companyId,
      this.devicegroupDevice,
      this.devicegroupName,
      this.createdBy,
      this.createdAt});

  Device.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    devicegroupUuid = json['devicegroup_uuid'];
    companyId = json['company_id'];
    devicegroupDevice = json['devicegroup_device'];
    devicegroupName = json['devicegroup_name'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['devicegroup_uuid'] = this.devicegroupUuid;
    data['company_id'] = this.companyId;
    data['devicegroup_device'] = this.devicegroupDevice;
    data['devicegroup_name'] = this.devicegroupName;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
