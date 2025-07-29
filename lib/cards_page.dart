import 'package:flutter/material.dart';
import 'services/cards_service.dart';
import 'models/card_models.dart';
import 'models/user.dart';
import 'services/user_service.dart';
import 'card_details_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'no_internet_page.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  UserCardResponse? _cardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  Future<void> _loadCardData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => NoInternetPage(onRetry: _loadCardData)),
        );
      }
      return;
    }
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final cardData = await CardsService.getUserCard();

      if (mounted) {
        setState(() {
          _cardData = cardData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NoInternetPage(onRetry: _loadCardData)),
          );
        }
        return;
      }
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
                          const Text(
                            'بطاقتي',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'إدارة بطاقتك الشخصية',
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
                        onPressed: _loadCardData,
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
                              'جاري تحميل بيانات البطاقة...',
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
                        : _buildCardContent(),
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
            Text(
              'حدث خطأ',
              style: const TextStyle(
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
                onPressed: _loadCardData,
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

  Widget _buildCardContent() {
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
    final card = _cardData!.card;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCardTile(card),
          // عرض البطاقات الفضية بشكل منفصل
          _buildSilverCardsSection(),
        ],
      ),
    );
  }

  Widget _buildCardTile(CardModel card) {
    final isGold = card.cardType == 'gold';
    final color = isGold ? const Color(0xFFFFD700) : const Color(0xFFC0C0C0);
    final cardType = card.cardType;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CardDetailsPage(
                cardId: card.id,
                cardType: cardType,
                cardNumber: card.cardNumber,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Header مع الأيقونة والنوع
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isGold ? Icons.star : Icons.star_border,
                      color: color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بطاقة ${isGold ? 'ذهبية' : 'فضية'}',
                          style: TextStyle(
                            color: color,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'رقم: ${card.cardNumber}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 25),
              
              // الإحصائيات
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'عدد المشتريات',
                      '${card.statistics.totalSales}',
                      Icons.shopping_cart,
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'المشتريات',
                      '${parseToDouble(card.statistics.totalRevenue).toStringAsFixed(0)} د.أ',
                      Icons.attach_money,
                      const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
              
              // معلومات إضافية للبطاقة الذهبية
              if (isGold) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'رصيد المحفظة',
                        '${card.walletBalance?.toStringAsFixed(0) ?? '0'} د.أ',
                        Icons.account_balance_wallet,
                        const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        'كروت فضية',
                        '${card.silverCardsCount}',
                        Icons.star_border,
                        const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // عرض البطاقات الفضية بشكل منفصل
  Widget _buildSilverCardsSection() {
    if (_cardData == null || _cardData!.card.cardType != 'gold') return const SizedBox.shrink();
    
    final silverCards = _cardData!.card.statistics.silverCards;
    if (silverCards == null || silverCards.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC0C0C0).withOpacity(0.2),
                  const Color(0xFFC0C0C0).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: const Color(0xFFC0C0C0),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'البطاقات الفضية المرتبطة',
                  style: TextStyle(
                    color: const Color(0xFFC0C0C0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC0C0C0).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${silverCards.length}',
                    style: TextStyle(
                      color: const Color(0xFFC0C0C0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          // قائمة البطاقات الفضية
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: silverCards.length,
            itemBuilder: (context, index) {
              final silverCard = silverCards[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFC0C0C0).withOpacity(0.15),
                      const Color(0xFFC0C0C0).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFC0C0C0).withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC0C0C0).withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CardDetailsPage(
                          cardId: silverCard.id,
                          cardType: 'silver',
                          cardNumber: silverCard.serialNumber,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // أيقونة البطاقة الفضية
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFC0C0C0).withOpacity(0.3),
                                const Color(0xFFC0C0C0).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.star_border,
                            color: const Color(0xFFC0C0C0),
                            size: 28,
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // تفاصيل البطاقة
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'بطاقة فضية',
                                style: TextStyle(
                                  color: const Color(0xFFC0C0C0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'رقم: ${silverCard.serialNumber}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'خصم ${silverCard.discountRate}%',
                                      style: const TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'الاستخدام: ${silverCard.usageCount}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // حالة البطاقة
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: silverCard.status == 'active' 
                                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                silverCard.status == 'active' ? 'نشط' : 'غير نشط',
                                style: TextStyle(
                                  color: silverCard.status == 'active' 
                                      ? const Color(0xFF4CAF50)
                                      : Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: const Color(0xFFC0C0C0).withOpacity(0.7),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
} 