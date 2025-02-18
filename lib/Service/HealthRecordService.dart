import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/HealthRecordResponse.dart';
import '../Parameters.dart';

class HealthRecordService {
  /// Fetch all health records
  static Future<HealthRecordResponse> getAllHealthRecords() async {
    final String url = "${Parameters.baseUrl}${Parameters.getAllHealthRecords}";
    print("Đang test kết nối đến: $url");

    try {
      // Test server connectivity
      final testConnection = await InternetAddress.lookup('https://firsttealcat50.conveyor.cloud/');
      print("Kết nối thành công: ${testConnection.first.address}");
    } catch (e) {
      print("Không thể kết nối đến server: $e");
    }

    const int maxRetries = 3;
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
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException("Timeout sau 10 giây");
          },
        );

        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          return HealthRecordResponse.fromJson(json.decode(response.body));
        } else {
          throw HttpException("API Error: ${response.statusCode}");
        }
      } catch (e) {
        currentTry++;
        print("Lần thử $currentTry - Lỗi: $e");

        if (currentTry == maxRetries) {
          throw Exception("Không thể kết nối sau $maxRetries lần thử");
        }

        await Future.delayed(const Duration(seconds: 2));
      }
    }

    throw Exception("Không thể kết nối đến server");
  }

  /// Insert a new health record
  static Future<bool> insertHealthRecord(InsertRecordModel model) async {
    final String url = "${Parameters.baseUrl}${Parameters.insertHealthRecord}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(model.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Timeout sau 10 giây");
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] ?? false;
      }
      return false;
    } catch (e) {
      print("Lỗi thêm hồ sơ sức khỏe: $e");
      return false;
    }
  }
}
