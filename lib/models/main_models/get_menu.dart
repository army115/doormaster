class getMenu {
  int? status;
  List<DataMenu>? data;

  getMenu({this.status, this.data});

  getMenu.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataMenu>[];
      json['data'].forEach((v) {
        data!.add(new DataMenu.fromJson(v));
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

class DataMenu {
  String? sId;
  String? icon;
  String? name;
  String? page;
  String? companyId;
  String? modulename;
  String? type;

  DataMenu(
      {this.sId,
      this.icon,
      this.name,
      this.page,
      this.companyId,
      this.modulename,
      this.type});

  DataMenu.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    icon = json['icon'];
    name = json['name'];
    page = json['page'];
    companyId = json['company_id'];
    modulename = json['modulename'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['page'] = this.page;
    data['company_id'] = this.companyId;
    data['modulename'] = this.modulename;
    data['type'] = this.type;
    return data;
  }
}
