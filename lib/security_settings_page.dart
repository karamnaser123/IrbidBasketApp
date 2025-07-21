import 'package:flutter/material.dart';
import 'services/app_lock_service.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _isLockEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      print('=== تحميل إعدادات الأمان ===');
      
      final lockEnabled = await AppLockService.isLockEnabled();

      print('قفل التطبيق مفعل: $lockEnabled');

      if (mounted) {
        setState(() {
          _isLockEnabled = lockEnabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ في تحميل إعدادات الأمان: $e');
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

  Future<bool> _showCreatePinDialog() async {
    final pinController = TextEditingController();
    final confirmPinController = TextEditingController();
    bool isValid = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('إنشاء PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'أدخل PIN مكون من 4 أرقام لحماية التطبيق',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {
                    isValid = value.length == 4 && value == confirmPinController.text;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'تأكيد PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {
                    isValid = value.length == 4 && value == pinController.text;
                  });
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
              onPressed: isValid
                  ? () async {
                      await AppLockService.setPin(pinController.text);
                      Navigator.of(context).pop(true);
                    }
                  : null,
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    ) ?? false;
  }

  Future<bool> _showChangePinDialog() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    bool isValid = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('تغيير PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'أدخل PIN الحالي ثم PIN الجديد',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: currentPinController,
                decoration: const InputDecoration(
                  labelText: 'PIN الحالي',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {
                    isValid = value.length == 4 && 
                              newPinController.text.length == 4 && 
                              newPinController.text == confirmPinController.text;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPinController,
                decoration: const InputDecoration(
                  labelText: 'PIN الجديد',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {
                    isValid = value.length == 4 && 
                              value == confirmPinController.text &&
                              currentPinController.text.length == 4;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'تأكيد PIN الجديد',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {
                    isValid = value.length == 4 && 
                              value == newPinController.text &&
                              currentPinController.text.length == 4;
                  });
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
              onPressed: isValid
                  ? () async {
                      // التحقق من PIN الحالي
                      final isCurrentPinValid = await AppLockService.verifyPin(currentPinController.text);
                      if (isCurrentPinValid) {
                        await AppLockService.setPin(newPinController.text);
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PIN الحالي غير صحيح'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('تغيير'),
            ),
          ],
        ),
      ),
    ) ?? false;
  }

  Widget _buildSecurityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isEnabled 
                  ? const Color(0xFFe94560).withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isEnabled ? const Color(0xFFe94560) : Colors.white,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          
          // المفتاح
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: const Color(0xFFe94560),
            inactiveThumbColor: Colors.white.withOpacity(0.3),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
        ],
      ),
    );
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
          child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFe94560),
                ),
              )
            : Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'إعدادات الأمان',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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

                          const SizedBox(height: 24),

                          // أزرار إضافية
                          if (_isLockEnabled) ...[
                            // زر تغيير PIN
                            Container(
                              width: double.infinity,
                              height: 56,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await _showChangePinDialog();
                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم تغيير PIN بنجاح'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFe94560),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.edit, size: 20),
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
                            Container(
                              width: double.infinity,
                              height: 56,
                              margin: const EdgeInsets.only(bottom: 24),
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
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh, size: 20),
                                label: const Text(
                                  'إعادة تعيين PIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // معلومات إضافية
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFe94560).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.security,
                                        color: Color(0xFFe94560),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'معلومات الأمان',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildInfoItem(
                                  'PIN محفوظ بشكل آمن في الجهاز.',
                                  Icons.shield,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoItem(
                                  'يمكنك تغيير الإعدادات في أي وقت.',
                                  Icons.settings,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoItem(
                                  'PIN مكون من 4 أرقام فقط.',
                                  Icons.pin,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
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

  Widget _buildInfoItem(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
} 