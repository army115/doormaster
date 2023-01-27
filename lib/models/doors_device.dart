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
  bool? screenType;
  int? communityId;
  String? communityUuid;
  int? positionType;
  int? positionId;
  String? positionUuid;
  String? positionFullName;
  String? devMac;
  String? appEkey;
  String? miniEkey;
  int? connectionStatus;
  int? isSupportNetwork;
  int? category;
  int? isSupportSipVideo;
  String? devAccSupperPassword;

  Lists(
      {this.id,
      this.devSn,
      this.name,
      this.deviceModelName,
      this.deviceModelValue,
      this.screenType,
      this.communityId,
      this.communityUuid,
      this.positionType,
      this.positionId,
      this.positionUuid,
      this.positionFullName,
      this.devMac,
      this.appEkey,
      this.miniEkey,
      this.connectionStatus,
      this.isSupportNetwork,
      this.category,
      this.isSupportSipVideo,
      this.devAccSupperPassword});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    devSn = json['devSn'];
    name = json['name'];
    deviceModelName = json['deviceModelName'];
    deviceModelValue = json['deviceModelValue'];
    screenType = json['screenType'] == 0 ? false : true;
    communityId = json['communityId'];
    communityUuid = json['communityUuid'];
    positionType = json['positionType'];
    positionId = json['positionId'];
    positionUuid = json['positionUuid'];
    positionFullName = json['positionFullName'];
    devMac = json['devMac'];
    appEkey = json['appEkey'];
    miniEkey = json['miniEkey'];
    connectionStatus = json['connectionStatus'];
    isSupportNetwork = json['isSupportNetwork'];
    category = json['category'];
    isSupportSipVideo = json['isSupportSipVideo'];
    devAccSupperPassword = json['devAccSupperPassword'];
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
    data['communityUuid'] = this.communityUuid;
    data['positionType'] = this.positionType;
    data['positionId'] = this.positionId;
    data['positionUuid'] = this.positionUuid;
    data['positionFullName'] = this.positionFullName;
    data['devMac'] = this.devMac;
    data['appEkey'] = this.appEkey;
    data['miniEkey'] = this.miniEkey;
    data['connectionStatus'] = this.connectionStatus;
    data['isSupportNetwork'] = this.isSupportNetwork;
    data['category'] = this.category;
    data['isSupportSipVideo'] = this.isSupportSipVideo;
    data['devAccSupperPassword'] = this.devAccSupperPassword;
    return data;
  }
}
