import 'package:flutter/material.dart';
import 'services/user_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await UserService.changePassword(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تغيير كلمة المرور بنجاح'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        String errorMessage = 'خطأ في تغيير كلمة المرور';
        if (e.toString().contains('Invalid old password')) {
          errorMessage = 'كلمة المرور القديمة غير صحيحة';
        } else if (e.toString().contains('old_password')) {
          errorMessage = 'كلمة المرور القديمة غير صحيحة';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
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
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // المحتوى
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // أيقونة
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFe94560).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: const Color(0xFFe94560),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 50,
                            color: Color(0xFFe94560),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'تغيير كلمة المرور',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                                                 const Text(
                           'أدخل كلمة المرور الحالية والجديدة\n(الحد الأدنى 8 أحرف)\nتأكد من صحة كلمة المرور الحالية',
                           style: TextStyle(
                             fontSize: 16,
                             color: Colors.white70,
                           ),
                           textAlign: TextAlign.center,
                         ),

                        const SizedBox(height: 40),

                        // كلمة المرور القديمة
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: TextFormField(
                            controller: _oldPasswordController,
                            obscureText: !_isOldPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور الحالية',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isOldPasswordVisible = !_isOldPasswordVisible;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                                                         validator: (value) {
                               if (value == null || value.isEmpty) {
                                 return 'يرجى إدخال كلمة المرور الحالية';
                               }
                               if (value.length < 8) {
                                 return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                               }
                               return null;
                             },
                           ),
                         ),

                        //  const SizedBox(height: 8),
                        //  const Text(
                        //    'تأكد من إدخال كلمة المرور الحالية بشكل صحيح',
                        //    style: TextStyle(
                        //      color: Colors.orange,
                        //      fontSize: 12,
                        //    ),
                        //    textAlign: TextAlign.center,
                        //  ),

                        const SizedBox(height: 20),

                        // كلمة المرور الجديدة
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: TextFormField(
                            controller: _newPasswordController,
                            obscureText: !_isNewPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور الجديدة',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isNewPasswordVisible = !_isNewPasswordVisible;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور الجديدة';
                              }
                              if (value.length < 8) {
                                return 'كلمة المرور الجديدة يجب أن تكون 8 أحرف على الأقل';
                              }
                              if (value == _oldPasswordController.text) {
                                return 'كلمة المرور الجديدة يجب أن تكون مختلفة عن الحالية';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // تأكيد كلمة المرور الجديدة
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'تأكيد كلمة المرور الجديدة',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى تأكيد كلمة المرور الجديدة';
                              }
                              if (value != _newPasswordController.text) {
                                return 'كلمة المرور غير متطابقة';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 40),

                        // زر تغيير كلمة المرور
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFe94560),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'تغيير كلمة المرور',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // نص إضافي
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                                                 child: Text(
                                   'تأكد من أن كلمة المرور الجديدة قوية وآمنة\nالحد الأدنى 8 أحرف',
                                   style: TextStyle(
                                     color: Colors.blue,
                                     fontSize: 14,
                                   ),
                                 ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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