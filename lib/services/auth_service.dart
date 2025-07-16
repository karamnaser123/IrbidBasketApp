import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/login_response.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // تسجيل الدخول
  static Future<LoginResponse> login(String login, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'login': login, // يمكن أن يكون بريد إلكتروني أو رقم هاتف
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);
      
      // مسح البيانات القديمة وحفظ التوكن الجديد
      await _clearOldData();
      await _saveAuthData(loginResponse);
      
      return loginResponse;
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'حدث خطأ في تسجيل الدخول');
    }
  }

  // حفظ بيانات المصادقة
  static Future<void> _saveAuthData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, loginResponse.token);
    await prefs.setString(_userKey, json.encode(loginResponse.user.toJson()));
  }

  // مسح البيانات القديمة
  static Future<void> _clearOldData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // تحديث التوكن
  static Future<void> updateToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, newToken);
  }

  // الحصول على التوكن المحفوظ
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // الحصول على بيانات المستخدم المحفوظة
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }

  // التحقق من وجود جلسة نشطة
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // تسجيل الخروج - مسح كل البيانات
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    // مسح أي بيانات أخرى قد تكون محفوظة
    await prefs.clear();
  }

  // مسح كل البيانات المحفوظة
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // الحصول على التوكن للاستخدام في الطلبات الأخرى
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('لم يتم العثور على token، يرجى تسجيل الدخول مرة أخرى');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // التحقق من صلاحية التوكن
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // استعادة كلمة المرور
  static Future<bool> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.forgotPasswordEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // يمكنك تعديل الرسالة حسب استجابة السيرفر
      return true;
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'حدث خطأ في استعادة كلمة المرور');
    }
  }
}