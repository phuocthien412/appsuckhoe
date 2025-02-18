class HealthRecord {
  String recordId;
  double bloodPressure;
  String dateCreated;
  BmiIdsData? bmiIds; // Thay đổi kiểu dữ liệu

  HealthRecord({
    required this.recordId,
    required this.bloodPressure,
    required this.dateCreated,
    this.bmiIds,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      recordId: json['recordId'],
      bloodPressure: json['bloodPressure'].toDouble(),
      dateCreated: json['dateCreated'],
      bmiIds: json['bmiIds'] != null 
          ? BmiIdsData.fromJson(json['bmiIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'bloodPressure': bloodPressure,
      'dateCreated': dateCreated,
      'bmiIds': bmiIds?.toJson(),
    };
  }
}

// Thêm class mới để xử lý cấu trúc bmiIds
class BmiIdsData {
  String? id;
  List<String> values;

  BmiIdsData({
    this.id,
    required this.values,
  });

  factory BmiIdsData.fromJson(Map<String, dynamic> json) {
    return BmiIdsData(
      id: json['\$id'],
      values: (json['\$values'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      '\$values': values,
    };
  }
} 