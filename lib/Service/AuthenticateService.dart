import 'dart:convert';

import 'package:appsk2/Model/LoginResponse.dart';

import '../Parameters.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
class AuthenticateService{
  static Future<LoginResponse> login (String name, String passWord) async{
    String url = "${Parameters.baseUrl}${Parameters.login}";
    String body = json.encode({
      'Username': name,
      'Password' : passWord});
    var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"},body: body );
    LoginResponse loginResponse = LoginResponse();
    loginResponse.statusCode = response.statusCode;
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      loginResponse = LoginResponse.fromJson(jsonResponse);
    }
    return loginResponse;
  }
}