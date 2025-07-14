class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? emailVerifiedAt;
  final String? qrcode;
  final String? qrcodeNumber;
  final String? locationId;
  final String? deviceFcm;
  final String? sessionToken;
  final String? lastLoginAt;
  final bool active;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.emailVerifiedAt,
    this.qrcode,
    this.qrcodeNumber,
    this.locationId,
    this.deviceFcm,
    this.sessionToken,
    this.lastLoginAt,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      qrcode: json['qrcode'],
      qrcodeNumber: json['qrcode_number'],
      locationId: json['location_id']?.toString(),
      deviceFcm: json['device_fcm'],
      sessionToken: json['session_token'],
      lastLoginAt: json['last_login_at'],
      active: json['active'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'qrcode': qrcode,
      'qrcode_number': qrcodeNumber,
      'location_id': locationId,
      'device_fcm': deviceFcm,
      'session_token': sessionToken,
      'last_login_at': lastLoginAt,
      'active': active ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? emailVerifiedAt,
    String? qrcode,
    String? qrcodeNumber,
    String? locationId,
    String? deviceFcm,
    String? sessionToken,
    String? lastLoginAt,
    bool? active,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      qrcode: qrcode ?? this.qrcode,
      qrcodeNumber: qrcodeNumber ?? this.qrcodeNumber,
      locationId: locationId ?? this.locationId,
      deviceFcm: deviceFcm ?? this.deviceFcm,
      sessionToken: sessionToken ?? this.sessionToken,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 