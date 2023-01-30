class RegisResponse {
  int? status;
  String? result;

  RegisResponse({this.status, this.result});

  RegisResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['result'] = this.result;
    return data;
  }
}
