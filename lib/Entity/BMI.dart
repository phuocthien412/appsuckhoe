class BMI {
  String? id;
  String bmiId;
  double weight;
  double height;
  double bmiValue;
  String classification;
  String dateCreated;
  String healthRecordId;

  BMI({
    this.id,
    required this.bmiId,
    required this.weight,
    required this.height,
    required this.bmiValue,
    required this.classification,
    required this.dateCreated,
    required this.healthRecordId,
  });

  factory BMI.fromJson(Map<String, dynamic> json) {
    return BMI(
      id: json['\$id'],
      bmiId: json['bmiId'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      bmiValue: json['bmiValue'].toDouble(),
      classification: json['classification'],
      dateCreated: json['dateCreated'],
      healthRecordId: json['healthRecordId'],
    );
  }
}
