# Keystore Information for Google Play Store

## معلومات Keystore

تم إنشاء Keystore بنجاح لتطبيق Irbid Basket. إليك المعلومات المهمة:

### معلومات Keystore:
- **اسم الملف**: `android/app/upload-keystore.jks`
- **كلمة المرور**: `upload123`
- **Alias**: `upload`
- **كلمة مرور المفتاح**: `upload123`

### معلومات الشهادة:
- **الاسم**: Irbid Basket
- **الوحدة التنظيمية**: Development
- **الشركة**: Your Company
- **المدينة**: Your City
- **الولاية**: Your State
- **البلد**: JO (الأردن)

### ⚠️ تحذيرات مهمة:

1. **احتفظ بنسخة احتياطية من Keystore**: إذا فقدت هذا الملف، لن تتمكن من تحديث تطبيقك على Google Play Store.

2. **احتفظ بكلمة المرور**: لا تنس كلمة المرور `upload123` - ستحتاجها في المستقبل.

3. **لا تشارك Keystore**: لا ترسل هذا الملف لأي شخص ولا ترفعه على GitHub.

### كيفية بناء APK للتوزيع:

```bash
flutter build apk --release
```

### كيفية بناء App Bundle (مطلوب لـ Google Play Store):

```bash
flutter build appbundle --release
```

### ملفات مهمة:
- `android/key.properties` - يحتوي على إعدادات Keystore
- `android/app/upload-keystore.jks` - ملف Keystore نفسه
- `android/app/build.gradle.kts` - تم تعديله لاستخدام Keystore

### للتحقق من Keystore:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
```

### ملاحظة:
هذا Keystore صالح لمدة 10,000 يوم (حوالي 27 سنة) وهو مناسب لنشر التطبيق على Google Play Store. 