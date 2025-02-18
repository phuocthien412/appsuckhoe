import 'package:appsk2/Model/BaseResponse.dart';

class LoginResponse extends BaseResponse{
  String token = "";
  LoginResponse();
  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'] == null ? "": json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() {
    return 'LoginResponse{token: $token}';
  }
}