class complaint_type {
  List<DataType>? data;

  complaint_type({this.data});

  complaint_type.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataType>[];
      json['data'].forEach((v) {
        data!.add(new DataType.fromJson(v));
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

class DataType {
  int? value;
  String? label1;
  String? label2;

  DataType({this.value, this.label1, this.label2});

  DataType.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label1 = json['label1'];
    label2 = json['label2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label1'] = this.label1;
    data['label2'] = this.label2;
    return data;
  }
}
