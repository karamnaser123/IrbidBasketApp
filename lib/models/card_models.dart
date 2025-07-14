import 'user.dart';

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class CardSale {
  final int id;
  final double totalAmount;
  final String createdAt;

  CardSale({
    required this.id,
    required this.totalAmount,
    required this.createdAt,
  });

  factory CardSale.fromJson(Map<String, dynamic> json) {
    return CardSale(
      id: json['id'] ?? 0,
      totalAmount: parseToDouble(json['total_amount']),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class CardStatistics {
  final int totalSales;
  final double totalRevenue;
  final double? walletBalance;
  final int? silverCardsCount;

  CardStatistics({
    required this.totalSales,
    required this.totalRevenue,
    this.walletBalance,
    this.silverCardsCount,
  });

  factory CardStatistics.fromJson(Map<String, dynamic> json) {
    return CardStatistics(
      totalSales: json['total_sales'] ?? 0,
      totalRevenue: parseToDouble(json['total_revenue']),
      walletBalance: json.containsKey('wallet_balance') ? parseToDouble(json['wallet_balance']) : null,
      silverCardsCount: json['silver_cards_count'],
    );
  }
}

class CardModel {
  final int id;
  final String cardNumber;
  final String? serialNumber;
  final String? qrCodeImageUrl;
  final String createdAt;
  final String updatedAt;
  final int? goldCardId;
  final CardStatistics statistics;
  final List<CardSale> recentSales;
  final double? walletBalance;
  final int? silverCardsCount;
  final String cardType; // gold أو silver

  CardModel({
    required this.id,
    required this.cardNumber,
    this.serialNumber,
    this.qrCodeImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.goldCardId,
    required this.statistics,
    required this.recentSales,
    this.walletBalance,
    this.silverCardsCount,
    required this.cardType,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    // تحديد نوع البطاقة من البيانات
    String determineCardType(Map<String, dynamic> cardData) {
      // إذا كان هناك gold_card_id فهي بطاقة فضية
      if (cardData.containsKey('gold_card_id') && cardData['gold_card_id'] != null) {
        return 'silver';
      }
      // إذا كان هناك wallet_balance فهي بطاقة ذهبية
      if (cardData.containsKey('wallet_balance') && cardData['wallet_balance'] != null) {
        return 'gold';
      }
      // افتراضي: ذهبية
      return 'gold';
    }

    return CardModel(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? json['serial_number'] ?? '',
      serialNumber: json['serial_number'],
      qrCodeImageUrl: json['qr_code_image_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      goldCardId: json['gold_card_id'],
      statistics: CardStatistics.fromJson(json['statistics'] ?? {}),
      recentSales: (json['recent_sales'] as List? ?? [])
          .map((sale) => CardSale.fromJson(sale ?? {}))
          .toList(),
      walletBalance: json.containsKey('wallet_balance') ? parseToDouble(json['wallet_balance']) : null,
      silverCardsCount: json['statistics']['silver_cards_count'],
      cardType: determineCardType(json),
    );
  }
}

class UserCardResponse {
  final User user;
  final CardModel card;

  UserCardResponse({
    required this.user,
    required this.card,
  });

  factory UserCardResponse.fromJson(Map<String, dynamic> json) {
    return UserCardResponse(
      user: User.fromJson(json['user'] ?? {}),
      card: CardModel.fromJson(json['card'] ?? {}),
    );
  }
} 