import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // فحص توفر المصادقة البيومترية
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('خطأ في فحص المصادقة البيومترية: $e');
      return false;
    }
  }

  // الحصول على أنواع المصادقة المتاحة
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('خطأ في الحصول على أنواع المصادقة: $e');
      return [];
    }
  }

  // إجراء المصادقة البيومترية
  static Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'يرجى المصادقة للوصول إلى التطبيق',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print('خطأ في المصادقة البيومترية: $e');
      return false;
    }
  }

  // فحص نوع المصادقة المتاح
  static Future<String> getBiometricType() async {
    final availableBiometrics = await getAvailableBiometrics();
    
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'بصمة الإصبع';
    } else if (availableBiometrics.contains(BiometricType.face)) {
      return 'الوجه';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'قزحية العين';
    } else {
      return 'غير متوفر';
    }
  }

  // فحص إذا كان الجهاز يدعم المصادقة البيومترية
  static Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException catch (e) {
      print('خطأ في فحص دعم الجهاز: $e');
      return false;
    }
  }
} 