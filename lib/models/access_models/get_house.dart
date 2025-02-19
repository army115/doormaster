class getHouse {
  List<HouseData>? data;

  getHouse({this.data});

  getHouse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HouseData>[];
      json['data'].forEach((v) {
        data!.add(new HouseData.fromJson(v));
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

class HouseData {
  String? value;
  String? label;

  HouseData({this.value, this.label});

  HouseData.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}
