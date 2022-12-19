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
  int? devicegroupId;
  int? companyId;
  String? devicegroupName;
  String? devicegroupDevice;
  String? devicegroupUuid;
  int? createdBy;
  String? createdAt;

  Device(
      {this.devicegroupId,
      this.companyId,
      this.devicegroupName,
      this.devicegroupDevice,
      this.devicegroupUuid,
      this.createdBy,
      this.createdAt});

  Device.fromJson(Map<String, dynamic> json) {
    devicegroupId = json['devicegroup_id'];
    companyId = json['company_id'];
    devicegroupName = json['devicegroup_name'];
    devicegroupDevice = json['devicegroup_device'];
    devicegroupUuid = json['devicegroup_uuid'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicegroup_id'] = this.devicegroupId;
    data['company_id'] = this.companyId;
    data['devicegroup_name'] = this.devicegroupName;
    data['devicegroup_device'] = this.devicegroupDevice;
    data['devicegroup_uuid'] = this.devicegroupUuid;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
