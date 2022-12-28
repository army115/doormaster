class DoorsDeviece {
  List<Lists>? lists;

  DoorsDeviece({this.lists});

  DoorsDeviece.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  int? id;
  String? devSn;
  String? name;
  String? deviceModelName;
  int? deviceModelValue;
  int? screenType;
  int? communityId;
  int? positionType;
  int? positionId;
  String? positionUuid;
  String? positionFullName;
  int? connectionStatus;
  int? isSupportNetwork;
  int? category;
  String? ipAddress;
  int? accDoorNo;

  Lists(
      {this.id,
      this.devSn,
      this.name,
      this.deviceModelName,
      this.deviceModelValue,
      this.screenType,
      this.communityId,
      this.positionType,
      this.positionId,
      this.positionUuid,
      this.positionFullName,
      this.connectionStatus,
      this.isSupportNetwork,
      this.category,
      this.ipAddress,
      this.accDoorNo});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    devSn = json['devSn'];
    name = json['name'];
    deviceModelName = json['deviceModelName'];
    deviceModelValue = json['deviceModelValue'];
    screenType = json['screenType'];
    communityId = json['communityId'];
    positionType = json['positionType'];
    positionId = json['positionId'];
    positionUuid = json['positionUuid'];
    positionFullName = json['positionFullName'];
    connectionStatus = json['connectionStatus'];
    isSupportNetwork = json['isSupportNetwork'];
    category = json['category'];
    ipAddress = json['ipAddress'];
    accDoorNo = json['accDoorNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['devSn'] = this.devSn;
    data['name'] = this.name;
    data['deviceModelName'] = this.deviceModelName;
    data['deviceModelValue'] = this.deviceModelValue;
    data['screenType'] = this.screenType;
    data['communityId'] = this.communityId;
    data['positionType'] = this.positionType;
    data['positionId'] = this.positionId;
    data['positionUuid'] = this.positionUuid;
    data['positionFullName'] = this.positionFullName;
    data['connectionStatus'] = this.connectionStatus;
    data['isSupportNetwork'] = this.isSupportNetwork;
    data['category'] = this.category;
    data['ipAddress'] = this.ipAddress;
    data['accDoorNo'] = this.accDoorNo;
    return data;
  }
}
