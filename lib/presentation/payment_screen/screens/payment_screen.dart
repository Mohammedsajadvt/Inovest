import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/data/services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String userId;
  final String projectId;
  
  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.userId,
    required this.projectId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isProcessing = false;
  String _selectedPaymentMethod = '';
  final PaymentService _paymentService = PaymentService();
  String? _paymentId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _processPaymentWithAPI();
      }
    });
  }

  Future<void> _processPaymentWithAPI() async {
    try {
      final result = await _paymentService.processPayment(
        amount: widget.amount,
        paymentMethod: _selectedPaymentMethod,
        projectId: widget.projectId,
      );

      if (result['success']) {
        _paymentId = result['data']['id'];
        await _simulatePaymentGateway();
      } else {
        if (mounted) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processing failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _simulatePaymentGateway() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (_paymentId == null) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment ID not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final transactionId = 'TRANS_${DateTime.now().millisecondsSinceEpoch}';
    
    final verificationResult = await _paymentService.verifyPayment(
      paymentId: _paymentId!,
      transactionId: transactionId,
    );

    if (mounted) {
      setState(() => _isProcessing = false);
      
      if (verificationResult['success']) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationResult['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _processPayment() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    _animationController.forward();
  }

  Widget _buildPaymentOption(String title) {
    final isSelected = _selectedPaymentMethod == title;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppArray().colors[0].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppArray().colors[0] : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 32.h,
              width: 32.w,
              decoration: BoxDecoration(
                color: AppArray().colors[0].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                _getPaymentIcon(title),
                color: AppArray().colors[0],
                size: 20.r,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppArray().colors[0],
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppArray().colors[0],
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'Pay through Gpay':
        return Icons.g_mobiledata;
      case 'Pay through Paytm':
        return Icons.payment;
      case 'Pay through PhonePe':
        return Icons.phone_android;
      case 'Pay through PayPal':
        return Icons.payment_outlined;
      default:
        return Icons.payment;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for invalid data
    if (widget.amount <= 0 || widget.userId.isEmpty || widget.projectId.isEmpty) {
      return Scaffold(
        backgroundColor: AppArray().colors[1],
        appBar: AppBar(
          backgroundColor: AppArray().colors[1],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppArray().colors[0]),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, false);
              }
            },
          ),
          title: Text(
            'Payment Error',
            style: TextStyle(
              color: AppArray().colors[0],
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64.r,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Invalid Payment Data',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppArray().colors[0],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please try again with valid payment information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppArray().colors[3],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppArray().colors[0],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
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

    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[1],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppArray().colors[0]),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, false);
            }
          },
        ),
        title: Text(
          'Payment Methods',
          style: TextStyle(
            color: AppArray().colors[0],
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppArray().colors[0],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount to Pay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  '\$${widget.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Select Payment Method',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppArray().colors[0],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildPaymentOption('Pay through Gpay'),
                          _buildPaymentOption('Pay through Paytm'),
                          _buildPaymentOption('Pay through PhonePe'),
                          _buildPaymentOption('Pay through PayPal'),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppArray().colors[0],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: 100.w,
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _progressAnimation.value,
                            strokeWidth: 8.w,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(AppArray().colors[0]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Processing Payment...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 