import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';

class UserService {
  static Future<User> getUserProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('لم يتم العثور على token');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userEndpoint}'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // البيانات تأتي مباشرة بدون wrapper
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('غير مصرح - يرجى تسجيل الدخول مرة أخرى');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في جلب بيانات المستخدم');
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  static Future<bool> updateUserName(String newName) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('لم يتم العثور على token');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfileUpdateEndpoint}'),
        headers: headers,
        body: json.encode({
          'name': newName,
        }),
      );

      print('Update name response status: ${response.statusCode}');
      print('Update name response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          throw Exception(data['message'] ?? 'فشل في تحديث الاسم');
        }
      } else if (response.statusCode == 401) {
        throw Exception('غير مصرح - يرجى تسجيل الدخول مرة أخرى');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في تحديث الاسم');
      }
    } catch (e) {
      print('Error in updateUserName: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('لم يتم العثور على token');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changePasswordEndpoint}'),
        headers: headers,
        body: json.encode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      print('Change password response status: ${response.statusCode}');
      print('Change password response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          throw Exception(data['message'] ?? 'فشل في تغيير كلمة المرور');
        }
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'فشل في تغيير كلمة المرور');
      }
    } catch (e) {
      print('Error in changePassword: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }
} 