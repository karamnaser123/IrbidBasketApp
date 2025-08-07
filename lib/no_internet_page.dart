import 'package:flutter/material.dart';


class NoInternetPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoInternetPage({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.redAccent, size: 100),
              const SizedBox(height: 32),
              Text(
                'لا يوجد اتصال بالإنترنت',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'يرجى التحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  // مؤقتاً نتجاهل فحص الاتصال
                  // final connectivityResult = await Connectivity().checkConnectivity();
                  // if (connectivityResult != ConnectivityResult.none) {
                  //   if (onRetry != null) onRetry!();
                  //   Navigator.of(context).pop();
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('لا يوجد اتصال بالإنترنت!'),
                  //       backgroundColor: Colors.redAccent,
                  //   ),
                  // );
                  // }
                  
                  // مؤقتاً نعود مباشرة
                  if (onRetry != null) onRetry!();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 