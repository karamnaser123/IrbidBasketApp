import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'services/app_lock_service.dart';
import 'qr_code_page.dart';

class PinLockPage extends StatefulWidget {
  const PinLockPage({super.key});

  @override
  State<PinLockPage> createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage> with TickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  int _attempts = 0;
  static const int _maxAttempts = 5;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isError = false; // متغير لتتبع حالة الخطأ

  @override
  void initState() {
    super.initState();
    
    // إعداد تأثير الاهتزاز
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pinController.dispose();
    _shakeController.dispose();
    super.dispose();
  }



  Future<void> _verifyPin(String pin) async {
    if (_attempts >= _maxAttempts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تجاوز الحد الأقصى للمحاولات. يرجى المحاولة لاحقاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await AppLockService.verifyPin(pin);
      
      if (isValid) {
        // PIN صحيح، انتقل إلى التطبيق
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const QrCodePage()),
          );
        }
      } else {
        // PIN خاطئ - مسح الحقل وإظهار رسالة الخطأ مع تأثير الاهتزاز
        setState(() {
          _attempts++;
          _pinController.clear(); // مسح الأرقام من الحقل
          _isError = true; // تفعيل حالة الخطأ
        });
        
        // تشغيل تأثير الاهتزاز
        _shakeController.forward().then((_) {
          _shakeController.reverse();
        });
        
        // إعادة تعيين حالة الخطأ بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isError = false;
            });
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PIN خاطئ. المحاولات المتبقية: ${_maxAttempts - _attempts}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // في حالة حدوث خطأ، مسح الحقل أيضاً
      setState(() {
        _pinController.clear();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التحقق: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // أيقونة القفل
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'أدخل PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'لإلغاء قفل التطبيق',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // PIN Input
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                                             // حقل إدخال PIN مع تأثير الاهتزاز
                       AnimatedBuilder(
                         animation: _shakeAnimation,
                         builder: (context, child) {
                           return Transform.translate(
                             offset: Offset(_shakeAnimation.value, 0),
                             child: PinCodeTextField(
                               appContext: context,
                               length: 4,
                               controller: _pinController,
                               onChanged: (value) {
                                 // إعادة تعيين حالة الخطأ عند بدء الإدخال
                                 if (_isError) {
                                   setState(() {
                                     _isError = false;
                                   });
                                 }
                               },
                               onCompleted: (value) {
                                 _verifyPin(value);
                               },
                               pinTheme: PinTheme(
                                 shape: PinCodeFieldShape.box,
                                 borderRadius: BorderRadius.circular(12),
                                 fieldHeight: 60,
                                 fieldWidth: 60,
                                 activeFillColor: _isError 
                                     ? Colors.red.withOpacity(0.2)
                                     : Colors.white.withOpacity(0.1),
                                 activeColor: _isError 
                                     ? Colors.red
                                     : const Color(0xFFe94560),
                                 selectedColor: _isError 
                                     ? Colors.red
                                     : const Color(0xFFe94560),
                                 inactiveColor: _isError 
                                     ? Colors.red.withOpacity(0.5)
                                     : Colors.white.withOpacity(0.3),
                                 inactiveFillColor: _isError 
                                     ? Colors.red.withOpacity(0.1)
                                     : Colors.white.withOpacity(0.05),
                               ),
                               keyboardType: TextInputType.number,
                               enableActiveFill: true,
                               animationType: AnimationType.fade,
                               textStyle: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           );
                         },
                       ),

                      const SizedBox(height: 32),

                      // مؤشر التحميل
                      if (_isLoading)
                        const CircularProgressIndicator(
                          color: Color(0xFFe94560),
                          strokeWidth: 3,
                        ),

                      const SizedBox(height: 32),

                      // معلومات إضافية
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.white.withOpacity(0.7),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'PIN محفوظ بشكل آمن في جهازك',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 