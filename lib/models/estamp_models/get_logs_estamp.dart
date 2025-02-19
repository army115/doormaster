class GetLogsEstamp {
  List<LogData> data;

  GetLogsEstamp({required this.data});

  factory GetLogsEstamp.fromJson(Map<String, dynamic> json) {
    return GetLogsEstamp(
      data: List<LogData>.from(
          json['data'].map((item) => LogData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class LogData {
  int rowId;
  String estampId;
  String estampName;
  String parkingId;
  String plateNum;
  String createDate;

  LogData({
    required this.rowId,
    required this.estampId,
    required this.estampName,
    required this.parkingId,
    required this.plateNum,
    required this.createDate,
  });

  factory LogData.fromJson(Map<String, dynamic> json) {
    return LogData(
      rowId: json['row_id'],
      estampId: json['estamp_id'],
      estampName: json['estamp_name'],
      parkingId: json['parking_id'],
      plateNum: json['plate_num'],
      createDate: json['create_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row_id': rowId,
      'estamp_id': estampId,
      'estamp_name': estampName,
      'parking_id': parkingId,
      'plate_num': plateNum,
      'create_date': createDate,
    };
  }
}
