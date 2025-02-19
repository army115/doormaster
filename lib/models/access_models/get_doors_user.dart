class GetDoors {
  List<DoorData>? data;

  GetDoors({this.data});

  factory GetDoors.fromJson(Map<String, dynamic> json) {
    return GetDoors(
      data: json['data'] != null
          ? List<DoorData>.from(
              json['data'].map((item) => DoorData.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class DoorData {
  String? value;
  String? label;

  DoorData({this.value, this.label});

  factory DoorData.fromJson(Map<String, dynamic> json) {
    return DoorData(
      value: json['value'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
