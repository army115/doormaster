class getNews {
  List<Data>? data;

  getNews({this.data});

  getNews.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? rowId;
  String? announcementId;
  String? img;
  String? title;
  String? createDate;
  String? subTitle;
  String? link;
  String? announcementText;

  Data(
      {this.rowId,
      this.announcementId,
      this.img,
      this.title,
      this.createDate,
      this.subTitle,
      this.link,
      this.announcementText});

  Data.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    announcementId = json['announcement_id'];
    img = json['img'];
    title = json['title'];
    createDate = json['create_date'];
    subTitle = json['sub_title'];
    link = json['link'];
    announcementText = json['announcement_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['row_id'] = rowId;
    data['announcement_id'] = announcementId;
    data['img'] = img;
    data['title'] = title;
    data['create_date'] = createDate;
    data['sub_title'] = subTitle;
    data['link'] = link;
    data['announcement_text'] = announcementText;
    return data;
  }
}
