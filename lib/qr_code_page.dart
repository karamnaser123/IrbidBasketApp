import 'package:flutter/material.dart';
import 'models/qr_code_response.dart';
import 'services/qr_code_service.dart';
import 'services/auth_service.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'cards_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'no_internet_page.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  QrCode? _qrCode;
  bool _isLoading = true;
  String? _error;
  Uint8List? _qrImageBytes;

  @override
  void initState() {
    super.initState();
    _loadQrCode();
  }

  Future<void> _loadQrCode() async {
    // تحقق من الاتصال أولاً
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => NoInternetPage(onRetry: _loadQrCode)),
        );
      }
      return;
    }
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _qrImageBytes = null;
      });

      final response = await QrCodeService.getQrCode();
      _qrCode = response.qrCode;
      final headers = await AuthService.getAuthHeaders();
      final imgRes = await http.get(
        Uri.parse(_qrCode!.qrCodeImageUrl),
        headers: headers,
      );
      if (imgRes.statusCode == 200) {
        _qrImageBytes = imgRes.bodyBytes;
      } else {
        _qrImageBytes = null;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // إذا كان الخطأ متعلق بالاتصال
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NoInternetPage(onRetry: _loadQrCode)),
          );
        }
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ... existing code ...
  String _formatDate(String? dateString) {
    if (dateString == null) return 'لم يتم الاستخدام بعد';
    try {
      final date = DateTime.parse(dateString.replaceAll(' ', 'T'));
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString();
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      String second = date.second.toString().padLeft(2, '0');
      return '$day/$month/$year   $hour:$minute:$second';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'QR Code الخاص بك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CardsPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.credit_card, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: _loadQrCode,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadQrCode,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _buildQrCodeContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeContent() {
    if (_qrCode == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // QR Code Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // QR Code Image
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _qrImageBytes != null
                        ? Image.memory(_qrImageBytes!, fit: BoxFit.contain)
                        : const Center(
                            child: Icon(
                              Icons.qr_code,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // زر تنزيل QR
                // if (_qrImageBytes != null)
                //   SizedBox(
                //     width: 180,
                //     child: ElevatedButton.icon(
                //       onPressed: _saveQrToDownloads,
                //       icon: const Icon(Icons.download),
                //       label: const Text('تنزيل QR Code'),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFFe94560),
                //         foregroundColor: Colors.white,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //     ),
                //   ),
                const SizedBox(height: 24),

                // Serial Number
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFe94560).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFe94560),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        ': الرقم التسلسلي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _qrCode!.serialNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'نسبة الخصم',
                  '${_qrCode!.discountRate}%',
                  Icons.discount,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'عدد مرات الاستخدام',
                  '${_qrCode!.usageCount}',
                  Icons.repeat,
                  Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _qrCode!.status == 'active'
                    ? Colors.green.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _qrCode!.status == 'active'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: _qrCode!.status == 'active'
                      ? Colors.green
                      : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحالة',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _qrCode!.status == 'active' ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: _qrCode!.status == 'active'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Last Used Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آخر استخدام',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(_qrCode!.lastUsedAt),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveQrToDownloads() async {
    if (_qrImageBytes == null) return;
    try {
      // مجلد التنزيلات الافتراضي في أندرويد
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      final file = await File(
        '${downloadsDir.path}/qr_code_${_qrCode?.serialNumber ?? ''}.png',
      ).writeAsBytes(_qrImageBytes!);
      if (await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ QR Code في مجلد التنزيلات!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ أثناء الحفظ!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('لا'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('نعم'),
          ),
        ],
      ),
    );
    if (result == true) {
      await AuthService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
