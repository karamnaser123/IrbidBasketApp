import 'package:flutter/material.dart';
import 'services/app_lock_service.dart';
import 'services/biometric_service.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _isLockEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  String _biometricType = 'غير متوفر';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final lockEnabled = await AppLockService.isLockEnabled();
      final biometricEnabled = await AppLockService.isBiometricEnabled();
      final biometricAvailable = await BiometricService.isBiometricAvailable();
      final biometricType = await BiometricService.getBiometricType();

      if (mounted) {
        setState(() {
          _isLockEnabled = lockEnabled;
          _isBiometricEnabled = biometricEnabled;
          _isBiometricAvailable = biometricAvailable;
          _biometricType = biometricType;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // تفعيل قفل التطبيق
      final hasPin = await AppLockService.hasPin();
      if (!hasPin) {
        // إذا لم يكن هناك PIN محفوظ، اطلب من المستخدم إنشاء واحد
        final result = await _showCreatePinDialog();
        if (result) {
          await AppLockService.setLockEnabled(true);
          setState(() {
            _isLockEnabled = true;
          });
        }
      } else {
        await AppLockService.setLockEnabled(true);
        setState(() {
          _isLockEnabled = true;
        });
      }
    } else {
      // إلغاء قفل التطبيق
      await AppLockService.setLockEnabled(false);
      setState(() {
        _isLockEnabled = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // تفعيل المصادقة البيومترية
      final isAuthenticated = await BiometricService.authenticate();
      if (isAuthenticated) {
        await AppLockService.setBiometricEnabled(true);
        setState(() {
          _isBiometricEnabled = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في المصادقة البيومترية'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // إلغاء المصادقة البيومترية
      await AppLockService.setBiometricEnabled(false);
      setState(() {
        _isBiometricEnabled = false;
      });
    }
  }

  Future<bool> _showCreatePinDialog() async {
    String pin = '';
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل PIN مكون من 4 أرقام'),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                pin = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pin.length == 4) {
                await AppLockService.setPin(pin);
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يجب أن يكون PIN مكون من 4 أرقام'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showChangePinDialog() async {
    String currentPin = '';
    String newPin = '';
    String confirmPin = '';
    bool isCurrentPinValid = false;
    
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('تغيير PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // إدخال PIN الحالي
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN الحالي',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  currentPin = value;
                },
              ),
              const SizedBox(height: 16),
              
              // إدخال PIN الجديد
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN الجديد',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  newPin = value;
                },
              ),
              const SizedBox(height: 16),
              
              // تأكيد PIN الجديد
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'تأكيد PIN الجديد',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  confirmPin = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                // التحقق من PIN الحالي
                final isValidCurrentPin = await AppLockService.verifyPin(currentPin);
                if (!isValidCurrentPin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN الحالي غير صحيح'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // التحقق من تطابق PIN الجديد
                if (newPin != confirmPin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN الجديد غير متطابق'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // التحقق من طول PIN الجديد
                if (newPin.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يجب أن يكون PIN مكون من 4 أرقام'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                // حفظ PIN الجديد
                await AppLockService.setPin(newPin);
                Navigator.of(context).pop(true);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تغيير PIN بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('تغيير'),
            ),
          ],
        ),
      ),
    ) ?? false;
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'إعدادات الأمان',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // للتوازن
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // قفل التطبيق
                            _buildSecurityCard(
                              title: 'قفل التطبيق',
                              subtitle: 'استخدم PIN لحماية التطبيق',
                              icon: Icons.lock,
                              isEnabled: _isLockEnabled,
                              onChanged: _toggleAppLock,
                            ),

                            const SizedBox(height: 16),

                            // المصادقة البيومترية
                            _buildSecurityCard(
                              title: 'المصادقة البيومترية',
                              subtitle: 'استخدم $_biometricType للوصول السريع',
                              icon: Icons.fingerprint,
                              isEnabled: _isBiometricEnabled,
                              onChanged: _toggleBiometric,
                              isAvailable: _isBiometricAvailable,
                            ),

                                                         const SizedBox(height: 32),

                             // زر تغيير PIN
                             if (_isLockEnabled)
                               Container(
                                 width: double.infinity,
                                 height: 56,
                                 margin: const EdgeInsets.only(bottom: 16),
                                 child: ElevatedButton.icon(
                                   onPressed: () async {
                                     final result = await _showChangePinDialog();
                                     if (result) {
                                       // تم تغيير PIN بنجاح
                                       setState(() {
                                         // تحديث الواجهة إذا لزم الأمر
                                       });
                                     }
                                   },
                                   style: ElevatedButton.styleFrom(
                                     backgroundColor: Colors.white.withOpacity(0.1),
                                     foregroundColor: Colors.white,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                     elevation: 0,
                                   ),
                                   icon: const Icon(Icons.edit),
                                   label: const Text(
                                     'تغيير PIN',
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ),

                             // زر إعادة تعيين PIN
                             if (_isLockEnabled)
                               Container(
                                 width: double.infinity,
                                 height: 56,
                                 margin: const EdgeInsets.only(bottom: 16),
                                 child: OutlinedButton.icon(
                                   onPressed: () async {
                                     // تأكيد إعادة التعيين
                                     final confirm = await showDialog<bool>(
                                       context: context,
                                       builder: (context) => AlertDialog(
                                         title: const Text('إعادة تعيين PIN'),
                                         content: const Text(
                                           'هل أنت متأكد من إعادة تعيين PIN؟\n'
                                           'سيتم حذف PIN الحالي وإنشاء واحد جديد.',
                                         ),
                                         actions: [
                                           TextButton(
                                             onPressed: () => Navigator.of(context).pop(false),
                                             child: const Text('إلغاء'),
                                           ),
                                           ElevatedButton(
                                             onPressed: () => Navigator.of(context).pop(true),
                                             style: ElevatedButton.styleFrom(
                                               backgroundColor: Colors.red,
                                               foregroundColor: Colors.white,
                                             ),
                                             child: const Text('إعادة تعيين'),
                                           ),
                                         ],
                                       ),
                                     );

                                     if (confirm == true) {
                                       // حذف PIN الحالي
                                       await AppLockService.deletePin();
                                       // إعادة تعيين إعدادات القفل
                                       await AppLockService.setLockEnabled(false);
                                       
                                       setState(() {
                                         _isLockEnabled = false;
                                       });

                                       if (mounted) {
                                         ScaffoldMessenger.of(context).showSnackBar(
                                           const SnackBar(
                                             content: Text('تم إعادة تعيين PIN بنجاح'),
                                             backgroundColor: Colors.green,
                                           ),
                                         );
                                       }
                                     }
                                   },
                                   style: OutlinedButton.styleFrom(
                                     foregroundColor: Colors.red,
                                     side: const BorderSide(color: Colors.red),
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                   ),
                                   icon: const Icon(Icons.refresh),
                                   label: const Text(
                                     'إعادة تعيين PIN',
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ),

                             // زر إعادة تعيين PIN بالبصمة
                             if (_isLockEnabled && _isBiometricAvailable)
                               Container(
                                 width: double.infinity,
                                 height: 56,
                                 margin: const EdgeInsets.only(bottom: 16),
                                 child: OutlinedButton.icon(
                                   onPressed: () async {
                                     // تأكيد إعادة التعيين بالبصمة
                                     final confirm = await showDialog<bool>(
                                       context: context,
                                       builder: (context) => AlertDialog(
                                         title: const Text('إعادة تعيين PIN بالبصمة'),
                                         content: const Text(
                                           'هل تريد إعادة تعيين PIN باستخدام البصمة؟\n'
                                           'سيتم طلب المصادقة البيومترية.',
                                         ),
                                         actions: [
                                           TextButton(
                                             onPressed: () => Navigator.of(context).pop(false),
                                             child: const Text('إلغاء'),
                                           ),
                                           ElevatedButton(
                                             onPressed: () => Navigator.of(context).pop(true),
                                             style: ElevatedButton.styleFrom(
                                               backgroundColor: const Color(0xFFe94560),
                                               foregroundColor: Colors.white,
                                             ),
                                             child: const Text('إعادة تعيين'),
                                           ),
                                         ],
                                       ),
                                     );

                                     if (confirm == true) {
                                       final success = await AppLockService.resetPinWithBiometric();
                                       
                                       if (success) {
                                         setState(() {
                                           _isLockEnabled = false;
                                         });

                                         if (mounted) {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                             const SnackBar(
                                               content: Text('تم إعادة تعيين PIN بالبصمة بنجاح'),
                                               backgroundColor: Colors.green,
                                             ),
                                           );
                                         }
                                       } else {
                                         if (mounted) {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                             const SnackBar(
                                               content: Text('فشل في المصادقة البيومترية'),
                                               backgroundColor: Colors.red,
                                             ),
                                           );
                                         }
                                       }
                                     }
                                   },
                                   style: OutlinedButton.styleFrom(
                                     foregroundColor: const Color(0xFFe94560),
                                     side: const BorderSide(color: Color(0xFFe94560)),
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                   ),
                                   icon: const Icon(Icons.fingerprint),
                                   label: const Text(
                                     'إعادة تعيين PIN بالبصمة',
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ),

                             const SizedBox(height: 32),

                             // معلومات إضافية
                             Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'معلومات الأمان',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '• PIN محفوظ بشكل آمن في الجهاز\n'
                                    '• المصادقة البيومترية تستخدم تقنيات الأمان المتقدمة\n'
                                    '• يمكنك تغيير الإعدادات في أي وقت',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
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

  Widget _buildSecurityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
    bool isAvailable = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEnabled
                  ? const Color(0xFFe94560)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: isAvailable ? onChanged : null,
            activeColor: const Color(0xFFe94560),
          ),
        ],
      ),
    );
  }
} 