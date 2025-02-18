import 'package:appsk2/Entity/BMI.dart';

class BMIResponse {
  String? id;
  bool status;
  String message;
  int totalRecord;
  BMIData data;

  BMIResponse({
    this.id,
    required this.status,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory BMIResponse.fromJson(Map<String, dynamic> json) {
    return BMIResponse(
      id: json['\$id'],
      status: json['status'],
      message: json['message'],
      totalRecord: json['totalRecord'],
      data: BMIData.fromJson(json['data']),
    );
  }
}

class BMIData {
  String? id;
  List<BMI> values;

  BMIData({
    this.id,
    required this.values,
  });

  factory BMIData.fromJson(Map<String, dynamic> json) {
    return BMIData(
      id: json['\$id'],
      values: (json['\$values'] as List)
          .map((item) => BMI.fromJson(item))
          .toList(),
    );
  }
}
