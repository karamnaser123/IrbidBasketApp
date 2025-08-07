import 'package:flutter/material.dart';

import 'debug_test_page.dart';
import 'login_page.dart';
import 'qr_code_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Irbid Basket',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFe94560),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      navigatorKey: _navigatorKey,
      home: const DebugTestPage(), // مؤقت للاختبار
      // home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // انتظار قليل لعرض شاشة البداية
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;

      // التحقق من وجود توكن صالح
      final isLoggedIn = await AuthService.isLoggedIn();
      
      if (!mounted) return;

      if (isLoggedIn) {
        // انتقل مباشرة إلى الصفحة الرئيسية
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const QrCodePage()),
          );
        }
      } else {
        // إذا لم يكن مسجل دخول، انتقل إلى صفحة تسجيل الدخول
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      }
    } catch (e) {
      print('خطأ في فحص حالة المصادقة: $e');
      // في حالة حدوث خطأ، انتقل إلى صفحة تسجيل الدخول
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار التطبيق
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // اسم التطبيق
              const Text(
                'Irbid Basket',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // مؤشر التحميل
              const CircularProgressIndicator(
                color: Color(0xFFe94560),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}