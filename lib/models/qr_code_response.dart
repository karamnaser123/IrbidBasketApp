class QrCodeResponse {
  final String message;
  final QrCode qrCode;

  QrCodeResponse({
    required this.message,
    required this.qrCode,
  });

  factory QrCodeResponse.fromJson(Map<String, dynamic> json) {
    return QrCodeResponse(
      message: json['message'] ?? '',
      qrCode: QrCode.fromJson(json['qrCode'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'qrCode': qrCode.toJson(),
    };
  }
}

class QrCode {
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

  QrCode({
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

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      id: json['id'] ?? 0,
      goldCardId: json['gold_card_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      serialNumber: json['serial_number'] ?? '',
      discountRate: json['discount_rate'] ?? 0,
      status: json['status'] ?? '',
      qrCodeImage: json['qr_code_image'] ?? '',
      lastUsedAt: json['last_used_at'],
      usageCount: json['usage_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      qrCodeImageUrl: json['qr_code_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gold_card_id': goldCardId,
      'user_id': userId,
      'serial_number': serialNumber,
      'discount_rate': discountRate,
      'status': status,
      'qr_code_image': qrCodeImage,
      'last_used_at': lastUsedAt,
      'usage_count': usageCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'qr_code_image_url': qrCodeImageUrl,
    };
  }
} 