class getEstamp {
  String? label;
  Value? value;

  getEstamp({this.label, this.value});

  getEstamp.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    if (value != null) {
      data['value'] = value!.toJson();
    }
    return data;
  }
}

class Value {
  String? estampId;
  String? discount;

  Value({this.estampId, this.discount});

  Value.fromJson(Map<String, dynamic> json) {
    estampId = json['estamp_id'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['estamp_id'] = estampId;
    data['discount'] = discount;
    return data;
  }
}
