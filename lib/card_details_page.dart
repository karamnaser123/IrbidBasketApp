import 'package:flutter/material.dart';
import 'services/cards_service.dart';
import 'models/card_models.dart';

class CardDetailsPage extends StatefulWidget {
  final int cardId;
  final String cardType;
  final String? cardNumber;

  const CardDetailsPage({
    super.key,
    required this.cardId,
    required this.cardType,
    required this.cardNumber,
  });

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  Map<String, dynamic>? _cardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCardDetails();
  }

  Future<void> _loadCardDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final cardData = await CardsService.getCardDetails(
        cardId: widget.cardId,
        cardType: widget.cardType,
      );

      if (mounted) {
        setState(() {
          _cardData = cardData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F23),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header مع تصميم جميل
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفاصيل البطاقة',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _cardData?['serial_number'] ?? widget.cardNumber ?? 'غير متوفر',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFe94560), Color(0xFFff6b6b)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: _loadCardDetails,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const CircularProgressIndicator(
                                color: Color(0xFFe94560),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'جاري تحميل تفاصيل البطاقة...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _error != null
                        ? _buildErrorWidget()
                        : _buildCardDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'حدث خطأ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _error!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFe94560), Color(0xFFff6b6b)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: _loadCardDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails() {
    if (_cardData == null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card_off,
                size: 60,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                'لا توجد بيانات',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final statistics = (_cardData?['statistics'] as Map<String, dynamic>?) ?? {};
    final recentSales = (_cardData?['recent_sales'] as List?) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // معلومات البطاقة
          _buildCardInfoCard(),
          
          const SizedBox(height: 20),
          
          // الإحصائيات
          _buildStatisticsCard(statistics),
          
          const SizedBox(height: 20),
          
          // المبيعات الأخيرة
          if (recentSales.isNotEmpty)
            _buildRecentSalesCard(recentSales),
        ],
      ),
    );
  }

  Widget _buildCardInfoCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _getCardTypeColor().withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardTypeColor().withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCardTypeColor().withOpacity(0.3),
                      _getCardTypeColor().withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getCardTypeIcon(),
                  color: _getCardTypeColor(),
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بطاقة ${_getCardTypeName()}',
                      style: TextStyle(
                        color: _getCardTypeColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'رقم: ${_cardData!['serial_number'] ?? 'غير متوفر'}',
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
          const SizedBox(height: 20),
          _buildInfoRow('نوع البطاقة', _getCardTypeName()),
          _buildInfoRow('تاريخ الإنشاء', _formatDate(_cardData!['created_at'])),
          _buildInfoRow('آخر تحديث', _formatDate(_cardData!['updated_at'])),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(Map<String, dynamic> statistics) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFe94560), Color(0xFFff6b6b)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'الإحصائيات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'عدد المشتريات',
                  '${statistics['total_sales'] ?? 0}',
                  Icons.shopping_cart,
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatItem(
                  'إجمالي المشتريات',
                  '${parseToDouble(statistics['total_revenue']).toStringAsFixed(0)} د.أ',
                  Icons.attach_money,
                  const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
          if (statistics['average_order_value'] != null) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'متوسط الطلب',
                    '${parseToDouble(statistics['average_order_value']).toStringAsFixed(0)} د.أ',
                    Icons.trending_up,
                    const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(), // مساحة فارغة للتوازن
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentSalesCard(List recentSales) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'المشتريات الأخيرة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...recentSales.map((sale) => _buildSaleItem(sale)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.6),
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
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

  Widget _buildSaleItem(Map<String, dynamic> sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مشتريات رقم: ${sale['id']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'المبلغ: ${parseToDouble(sale['total_amount']).toStringAsFixed(0)} د.أ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatDate(sale['created_at']),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCardTypeIcon() {
    switch (widget.cardType) {
      case 'gold':
        return Icons.star;
      case 'silver':
        return Icons.star_border;
      default:
        return Icons.credit_card;
    }
  }

  Color _getCardTypeColor() {
    switch (widget.cardType) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.blue;
    }
  }

  String _getCardTypeName() {
    switch (widget.cardType) {
      case 'gold':
        return 'ذهبية';
      case 'silver':
        return 'فضية';
      default:
        return 'غير محدد';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString.replaceAll(' ', 'T'));
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString();
      return '$day/$month/$year';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }
} 