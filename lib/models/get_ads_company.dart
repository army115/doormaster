class getAdsCompany {
  int? status;
  List<DataAds>? data;

  getAdsCompany({this.status, this.data});

  getAdsCompany.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataAds>[];
      json['data'].forEach((v) {
        data!.add(new DataAds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataAds {
  String? sId;
  String? adsversitingName;
  String? adsversitingDetail;
  String? adsversitingPic;
  int? clickCount;
  String? companyId;

  DataAds(
      {this.sId,
      this.adsversitingName,
      this.adsversitingDetail,
      this.adsversitingPic,
      this.clickCount,
      this.companyId});

  DataAds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    adsversitingName = json['adsversiting_name'];
    adsversitingDetail = json['adsversiting_detail'];
    adsversitingPic = json['adsversiting_pic'];
    clickCount = json['click_count'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['adsversiting_name'] = this.adsversitingName;
    data['adsversiting_detail'] = this.adsversitingDetail;
    data['adsversiting_pic'] = this.adsversitingPic;
    data['click_count'] = this.clickCount;
    data['company_id'] = this.companyId;
    return data;
  }
}
