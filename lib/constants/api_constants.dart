class ApiConstants {
  // رابط الموقع الأساسي
  static const String baseUrl = 'https://irbidbasket.com/api/';
  
  // نقاط النهاية (Endpoints)
  static const String loginEndpoint = 'login';
  static const String qrCodeEndpoint = 'qrcode';
  static const String userEndpoint = 'user';
  static const String userProfileUpdateEndpoint = 'update-profile';
  static const String changePasswordEndpoint = 'update-password';
  static const String forgotPasswordEndpoint = 'forgot-password';
  
  // Cards API Endpoints
  static const String userCardsEndpoint = 'user-cards';
  static const String cardDetailsEndpoint = 'card-details';
  static const String userCardSummaryEndpoint = 'user-card-summary';
  
  // ربط كامل لـ API
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get qrCodeUrl => '$baseUrl$qrCodeEndpoint';
  static String get userUrl => '$baseUrl$userEndpoint';
  static String get userProfileUpdateUrl => '$baseUrl$userProfileUpdateEndpoint';
  static String get changePasswordUrl => '$baseUrl$changePasswordEndpoint';
  static String get userCardsUrl => '$baseUrl$userCardsEndpoint';
  static String get cardDetailsUrl => '$baseUrl$cardDetailsEndpoint';
  static String get userCardSummaryUrl => '$baseUrl$userCardSummaryEndpoint';
  static String get forgotPasswordUrl => '$baseUrl$forgotPasswordEndpoint';
} 