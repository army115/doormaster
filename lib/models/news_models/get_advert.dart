class getAdvert {
  List<Data>? data;
  int? count;

  getAdvert({this.data, this.count});

  getAdvert.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Data {
  String? advertId;
  String? advertText;
  String? img;
  String? title;
  String? createDate;
  String? subTitle;
  String? link;
  int? rowId;

  Data(
      {this.advertId,
      this.advertText,
      this.img,
      this.title,
      this.createDate,
      this.subTitle,
      this.link,
      this.rowId});

  Data.fromJson(Map<String, dynamic> json) {
    advertId = json['advert_id'];
    advertText = json['advert_text'];
    img = json['img'];
    title = json['title'];
    createDate = json['create_date'];
    subTitle = json['sub_title'];
    link = json['link'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advert_id'] = this.advertId;
    data['advert_text'] = this.advertText;
    data['img'] = this.img;
    data['title'] = this.title;
    data['create_date'] = this.createDate;
    data['sub_title'] = this.subTitle;
    data['link'] = this.link;
    data['row_id'] = this.rowId;
    return data;
  }
}
