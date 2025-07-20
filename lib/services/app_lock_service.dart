import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'biometric_service.dart';

class AppLockService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _pinKey = 'app_pin';
  static const String _isLockEnabledKey = 'is_lock_enabled';
  static const String _isBiometricEnabledKey = 'is_biometric_enabled';

  // حفظ PIN
  static Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  // الحصول على PIN
  static Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  // التحقق من PIN
  static Future<bool> verifyPin(String pin) async {
    final savedPin = await getPin();
    return savedPin == pin;
  }

  // تفعيل/إلغاء قفل التطبيق
  static Future<void> setLockEnabled(bool enabled) async {
    await _storage.write(key: _isLockEnabledKey, value: enabled.toString());
  }

  // فحص إذا كان قفل التطبيق مفعل
  static Future<bool> isLockEnabled() async {
    final value = await _storage.read(key: _isLockEnabledKey);
    return value == 'true';
  }

  // تفعيل/إلغاء المصادقة البيومترية
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _isBiometricEnabledKey, value: enabled.toString());
  }

  // فحص إذا كانت المصادقة البيومترية مفعلة
  static Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _isBiometricEnabledKey);
    return value == 'true';
  }

  // حذف PIN
  static Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }

  // إعادة تعيين جميع إعدادات القفل
  static Future<void> resetLockSettings() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _isLockEnabledKey);
    await _storage.delete(key: _isBiometricEnabledKey);
  }

  // إعادة تعيين PIN من خلال المصادقة البيومترية
  static Future<bool> resetPinWithBiometric() async {
    try {
      // التحقق من توفر المصادقة البيومترية
      final isBiometricAvailable = await BiometricService.isBiometricAvailable();
      if (!isBiometricAvailable) {
        return false;
      }

      // إجراء المصادقة البيومترية
      final isAuthenticated = await BiometricService.authenticate();
      if (isAuthenticated) {
        // حذف PIN الحالي
        await deletePin();
        // إلغاء تفعيل القفل
        await setLockEnabled(false);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // فحص إذا كان PIN محفوظ
  static Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }
} 