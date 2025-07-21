import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLockService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _pinKey = 'app_pin';
  static const String _isLockEnabledKey = 'is_lock_enabled';

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

  // حذف PIN
  static Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }

  // إعادة تعيين جميع إعدادات القفل
  static Future<void> resetLockSettings() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _isLockEnabledKey);
  }

  // فحص إذا كان PIN محفوظ
  static Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }
} 