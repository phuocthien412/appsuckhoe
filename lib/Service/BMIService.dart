import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/BMIResponse.dart';
import '../Parameters.dart';

class BMIService {
  static Future<BMIResponse> getAllBMI() async {
    final String url = "${Parameters.baseUrl}${Parameters.getAllBMI}";

    print("Đang test kết nối đến: $url");

    // Thử ping trước khi gọi API
    try {
      // doi lai api
      final testConnection = await InternetAddress.lookup('https://firsttealcat50.conveyor.cloud/');
      print("Kết nối thành công: ${testConnection.first.address}");
    } catch (e) {
      print("Không thể kết nối đến server: $e");
    }

    int maxRetries = 3;
    int currentTry = 0;

    while (currentTry < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ).timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException("Timeout sau 10 giây");
          },
        );

        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          return BMIResponse.fromJson(json.decode(response.body));
        } else {
          throw HttpException("API Error: ${response.statusCode}");
        }
      } catch (e) {
        currentTry++;
        print("Lần thử $currentTry - Lỗi: $e");

        if (currentTry == maxRetries) {
          throw Exception("Không thể kết nối sau $maxRetries lần thử");
        }

        await Future.delayed(Duration(seconds: 2));
      }
    }

    throw Exception("Không thể kết nối đến server");
  }

  static Future<bool> insertBMI(double weight, double height, String healthRecordId) async {
    final String url = "${Parameters.baseUrl}${Parameters.insertBMI}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "weight": weight,
          "height": height,
          "healthRecordId": healthRecordId
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] ?? false;
      }
      return false;
    } catch (e) {
      print("Lỗi thêm BMI: $e");
      return false;
    }
  }

  static Future<bool> updateBMI(String id, double weight, double height) async {
    final String url = "${Parameters.baseUrl}${Parameters.updateBMI}$id";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "weight": weight,
          "height": height,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] ?? false;
      }
      return false;
    } catch (e) {
      print("Lỗi cập nhật BMI: $e");
      return false;
    }
  }

  static Future<bool> deleteBMI(String id) async {
    final String url = "${Parameters.baseUrl}${Parameters.deleteBMI}$id";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] ?? false;
      }
      return false;
    } catch (e) {
      print("Lỗi xóa BMI: $e");
      return false;
    }
  }

}
