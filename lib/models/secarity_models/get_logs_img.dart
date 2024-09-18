class getLogs_img {
  List<Img>? data;

  getLogs_img({this.data});

  getLogs_img.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Img>[];
      json['data'].forEach((v) {
        data!.add(new Img.fromJson(v));
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

class Img {
  String? imgPath;
  String? guardLogId;

  Img({this.imgPath, this.guardLogId});

  Img.fromJson(Map<String, dynamic> json) {
    imgPath = json['img_path'];
    guardLogId = json['guard_log_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_path'] = this.imgPath;
    data['guard_log_id'] = this.guardLogId;
    return data;
  }
}
