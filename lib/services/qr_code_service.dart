import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/qr_code_response.dart';
import 'auth_service.dart';

class QrCodeService {
  // الحصول على QR Code
  static Future<QrCodeResponse> getQrCode() async {
    try {
      final headers = await AuthService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse(ApiConstants.qrCodeUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return QrCodeResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'حدث خطأ في جلب QR Code');
      }
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال: $e');
    }
  }
} 