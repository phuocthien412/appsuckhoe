import '../Entity/HealthRecord.dart';

class HealthRecordResponse {
  String? id;
  bool status;
  String message;
  int totalRecords;
  HealthRecordData data;

  HealthRecordResponse({
    this.id,
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.data,
  });

  factory HealthRecordResponse.fromJson(Map<String, dynamic> json) {
    return HealthRecordResponse(
      id: json['\$id'],
      status: json['status'],
      message: json['message'],
      totalRecords: json['totalRecords'],
      data: HealthRecordData.fromJson(json['data']),
    );
  }
}

class HealthRecordData {
  String? id;
  List<HealthRecord> values;

  HealthRecordData({
    this.id,
    required this.values,
  });

  factory HealthRecordData.fromJson(Map<String, dynamic> json) {
    return HealthRecordData(
      id: json['\$id'],
      values: (json['\$values'] as List)
          .map((item) => HealthRecord.fromJson(item))
          .toList(),
    );
  }
}

class InsertRecordModel {
  double bloodPressure;
  List<String>? bmiIds;

  InsertRecordModel({
    required this.bloodPressure,
    this.bmiIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'bloodPressure': bloodPressure,
      'bmiIds': bmiIds,
    };
  }
}

class BMIIdsResponse {
  String? id;
  bool status;
  String message;
  List<String> data;

  BMIIdsResponse({
    this.id,
    required this.status,
    required this.message,
    required this.data,
  });

  factory BMIIdsResponse.fromJson(Map<String, dynamic> json) {
    return BMIIdsResponse(
      id: json['\$id'],
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((e) => e.toString()).toList(),
    );
  }
} 