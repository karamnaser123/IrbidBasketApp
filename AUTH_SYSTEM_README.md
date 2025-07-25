# نظام حفظ التوكن - Irbid Basket

## نظرة عامة

تم تطبيق نظام حفظ التوكن (Token Persistence) في التطبيق لضمان بقاء المستخدم مسجل دخول حتى يقوم بتسجيل الخروج يدوياً.

## الميزات المضافة

### 1. حفظ التوكن تلقائياً
- عند تسجيل الدخول بنجاح، يتم حفظ التوكن في `SharedPreferences`
- يتم حفظ بيانات المستخدم أيضاً
- التوكن محفوظ بشكل آمن في التخزين المحلي

### 2. التحقق التلقائي من حالة تسجيل الدخول
- عند فتح التطبيق، يتم التحقق من وجود توكن صالح
- إذا وجد توكن، يتم توجيه المستخدم مباشرة إلى الصفحة الرئيسية
- إذا لم يوجد توكن، يتم توجيه المستخدم إلى صفحة تسجيل الدخول

### 3. شاشة البداية (Splash Screen)
- شاشة جميلة تعرض شعار التطبيق
- تظهر لمدة ثانيتين أثناء التحقق من حالة تسجيل الدخول
- تصميم متناسق مع باقي التطبيق

### 4. تسجيل الخروج الآمن
- زر تسجيل الخروج في الصفحة الرئيسية
- تأكيد قبل تسجيل الخروج
- مسح جميع البيانات المحفوظة عند تسجيل الخروج

## كيفية العمل

### عند تسجيل الدخول:
1. المستخدم يدخل بياناته في صفحة تسجيل الدخول
2. يتم إرسال الطلب إلى الخادم
3. إذا نجح تسجيل الدخول، يتم حفظ التوكن وبيانات المستخدم
4. يتم توجيه المستخدم إلى الصفحة الرئيسية

### عند فتح التطبيق:
1. تظهر شاشة البداية
2. يتم التحقق من وجود توكن محفوظ
3. إذا وجد توكن، يتم توجيه المستخدم إلى الصفحة الرئيسية
4. إذا لم يوجد توكن، يتم توجيه المستخدم إلى صفحة تسجيل الدخول

### عند تسجيل الخروج:
1. المستخدم يضغط على زر تسجيل الخروج
2. تظهر رسالة تأكيد
3. إذا أكد، يتم مسح جميع البيانات المحفوظة
4. يتم توجيه المستخدم إلى صفحة تسجيل الدخول

## الملفات المحدثة

### 1. `lib/main.dart`
- إضافة `SplashScreen` للتحقق من حالة تسجيل الدخول
- توجيه المستخدم بناءً على وجود التوكن

### 2. `lib/services/auth_service.dart`
- وظائف حفظ واسترجاع التوكن
- وظائف التحقق من حالة تسجيل الدخول
- وظائف تسجيل الخروج ومسح البيانات

### 3. `lib/login_page.dart`
- حفظ التوكن تلقائياً عند نجاح تسجيل الدخول
- توجيه المستخدم إلى الصفحة الرئيسية

### 4. `lib/qr_code_page.dart`
- زر تسجيل الخروج مع تأكيد
- مسح البيانات والتوجيه إلى صفحة تسجيل الدخول

## الوظائف المتاحة في AuthService

```dart
// تسجيل الدخول وحفظ التوكن
static Future<LoginResponse> login(String login, String password)

// التحقق من وجود جلسة نشطة
static Future<bool> isLoggedIn()

// الحصول على التوكن المحفوظ
static Future<String?> getToken()

// الحصول على بيانات المستخدم
static Future<User?> getUser()

// تسجيل الخروج ومسح البيانات
static Future<void> logout()

// الحصول على headers للمصادقة
static Future<Map<String, String>> getAuthHeaders()
```

## الأمان

- التوكن محفوظ في `SharedPreferences` بشكل آمن
- يتم مسح البيانات عند تسجيل الخروج
- التحقق من صحة التوكن قبل استخدامه
- معالجة الأخطاء بشكل مناسب

## الاختبار

لاختبار النظام:
1. سجل دخولك في التطبيق
2. أغلق التطبيق تماماً
3. افتح التطبيق مرة أخرى
4. يجب أن تجد نفسك في الصفحة الرئيسية مباشرة
5. اضغط على زر تسجيل الخروج
6. يجب أن تعود إلى صفحة تسجيل الدخول

## ملاحظات مهمة

- التوكن محفوظ محلياً في الجهاز
- عند حذف بيانات التطبيق، سيتم مسح التوكن
- يمكن للمستخدم تسجيل الخروج يدوياً في أي وقت
- النظام يعمل بشكل تلقائي دون تدخل المستخدم 