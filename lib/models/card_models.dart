import 'user.dart';

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class SilverCard {
  final int id;
  final int goldCardId;
  final int userId;
  final String serialNumber;
  final int discountRate;
  final String status;
  final String qrCodeImage;
  final String? lastUsedAt;
  final int usageCount;
  final String createdAt;
  final String updatedAt;
  final String qrCodeImageUrl;

  SilverCard({
    required this.id,
    required this.goldCardId,
    required this.userId,
    required this.serialNumber,
    required this.discountRate,
    required this.status,
    required this.qrCodeImage,
    this.lastUsedAt,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
    required this.qrCodeImageUrl,
  });

  factory SilverCard.fromJson(Map<String, dynamic> json) {
    return SilverCard(
      id: json['id'] ?? 0,
      goldCardId: json['gold_card_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      serialNumber: json['serial_number'] ?? '',
      discountRate: json['discount_rate'] ?? 0,
      status: json['status'] ?? 'inactive',
      qrCodeImage: json['qr_code_image'] ?? '',
      lastUsedAt: json['last_used_at'],
      usageCount: json['usage_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      qrCodeImageUrl: json['qr_code_image_url'] ?? '',
    );
  }
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
  final List<SilverCard>? silverCards;

  CardStatistics({
    required this.totalSales,
    required this.totalRevenue,
    this.walletBalance,
    this.silverCardsCount,
    this.silverCards,
  });

  factory CardStatistics.fromJson(Map<String, dynamic> json) {
    return CardStatistics(
      totalSales: json['total_sales'] ?? 0,
      totalRevenue: parseToDouble(json['total_revenue']),
      walletBalance: json.containsKey('wallet_balance') ? parseToDouble(json['wallet_balance']) : null,
      silverCardsCount: json['silver_cards_count'],
      silverCards: json['silver_cards'] != null 
          ? (json['silver_cards'] as List).map((card) => SilverCard.fromJson(card)).toList()
          : null,
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

class MonthlySale {
  final int year;
  final int month;
  final int count;
  final double revenue;

  MonthlySale({
    required this.year,
    required this.month,
    required this.count,
    required this.revenue,
  });

  factory MonthlySale.fromJson(Map<String, dynamic> json) {
    return MonthlySale(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      count: json['count'] ?? 0,
      revenue: parseToDouble(json['revenue']),
    );
  }
}

class CardDetailsStatistics {
  final int totalSales;
  final double totalRevenue;
  final double averageOrderValue;
  final List<MonthlySale> monthlySales;

  CardDetailsStatistics({
    required this.totalSales,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.monthlySales,
  });

  factory CardDetailsStatistics.fromJson(Map<String, dynamic> json) {
    return CardDetailsStatistics(
      totalSales: json['total_sales'] ?? 0,
      totalRevenue: parseToDouble(json['total_revenue']),
      averageOrderValue: parseToDouble(json['average_order_value']),
      monthlySales: (json['monthly_sales'] as List? ?? [])
          .map((sale) => MonthlySale.fromJson(sale))
          .toList(),
    );
  }
}

class GoldCardInfo {
  final int id;
  final String cardNumber;

  GoldCardInfo({
    required this.id,
    required this.cardNumber,
  });

  factory GoldCardInfo.fromJson(Map<String, dynamic> json) {
    return GoldCardInfo(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
    );
  }
}

class CardDetails {
  final int id;
  final String cardNumber;
  final String? qrCodeImageUrl;
  final String createdAt;
  final String updatedAt;
  final String serialNumber;
  final User user;
  final CardDetailsStatistics statistics;
  final List<CardSale> recentSales;
  final double? walletBalance;
  final int? silverCardsCount;
  final GoldCardInfo? goldCard;
  final String cardType;

  CardDetails({
    required this.id,
    required this.cardNumber,
    this.qrCodeImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.serialNumber,
    required this.user,
    required this.statistics,
    required this.recentSales,
    this.walletBalance,
    this.silverCardsCount,
    this.goldCard,
    required this.cardType,
  });

  factory CardDetails.fromJson(Map<String, dynamic> json, String cardType) {
    return CardDetails(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCodeImageUrl: json['qr_code_image_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      statistics: CardDetailsStatistics.fromJson(json['statistics'] ?? {}),
      recentSales: (json['recent_sales'] as List? ?? [])
          .map((sale) => CardSale.fromJson(sale))
          .toList(),
      walletBalance: json.containsKey('wallet_balance') ? parseToDouble(json['wallet_balance']) : null,
      silverCardsCount: json['silver_cards_count'],
      goldCard: json['gold_card'] != null ? GoldCardInfo.fromJson(json['gold_card']) : null,
      cardType: cardType,
    );
  }
}

class CardDetailsResponse {
  final CardDetails cardDetails;

  CardDetailsResponse({
    required this.cardDetails,
  });

  factory CardDetailsResponse.fromJson(Map<String, dynamic> json, String cardType) {
    return CardDetailsResponse(
      cardDetails: CardDetails.fromJson(json['data'] ?? {}, cardType),
    );
  }
} 