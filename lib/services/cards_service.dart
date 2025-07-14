import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_models.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';

class CardsService {
  static Future<UserCardResponse> getUserCard() async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.get(
      Uri.parse(ApiConstants.userCardsUrl),
      headers: headers,
    );

    print('Get user card response status: ${response.statusCode}');
    print('Get user card response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return UserCardResponse.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب بيانات الكارت');
      }
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'فشل في جلب بيانات الكارت');
    }
  }

  static Future<Map<String, dynamic>> getCardDetails({
    required int cardId,
    required String cardType,
  }) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.get(
      Uri.parse('${ApiConstants.cardDetailsUrl}?card_id=$cardId&card_type=$cardType'),
      headers: headers,
    );

    print('Get card details response status: ${response.statusCode}');
    print('Get card details response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب تفاصيل الكارت');
      }
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'فشل في جلب تفاصيل الكارت');
    }
  }
} 