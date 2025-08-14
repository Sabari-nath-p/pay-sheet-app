import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../Controller/CustomerDashboardController.dart';
import '../../../../core/models/transaction_models.dart';

class CustomerPaymentsTab extends StatelessWidget {
  const CustomerPaymentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDashboardController controller =
        Get.find<CustomerDashboardController>();

    return Obx(() {
      if (controller.isLoadingPayments.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.payments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment_outlined,
                size: 64.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'no_data'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'no_payments_found'.tr,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadPayments,
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.payments.length,
          itemBuilder: (context, index) {
            final payment = controller.payments[index];
            return PaymentCard(payment: payment);
          },
        ),
      );
    });
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Payment ID and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'payment_id'.tr}: ${payment.voucherId}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${'payment_date'.tr}: ${payment.paymentDate.toString().split(' ')[0]}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    CurrencyFormatter.formatAmount(payment.amount),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Payment Method
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getPaymentMethodColor(
                  payment.paymentMethod,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPaymentMethodIcon(payment.paymentMethod),
                    size: 14.sp,
                    color: _getPaymentMethodColor(payment.paymentMethod),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _getPaymentMethodText(payment.paymentMethod),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getPaymentMethodColor(payment.paymentMethod),
                    ),
                  ),
                ],
              ),
            ),

            // Description
            if (payment.description.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'description'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      payment.description,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],

            // Payment info
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.payment, size: 14.sp, color: Colors.grey[500]),
                SizedBox(width: 4.w),
                Text(
                  'Payment ID: ${payment.id}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return Colors.green;
      case 'BANK':
        return Colors.blue;
      case 'POS':
        return Colors.purple;
      case 'CHEQUE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return Icons.money;
      case 'BANK':
        return Icons.account_balance;
      case 'POS':
        return Icons.credit_card;
      case 'CHEQUE':
        return Icons.receipt;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodText(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return 'cash'.tr;
      case 'BANK':
        return 'bank'.tr;
      case 'POS':
        return 'pos'.tr;
      case 'CHEQUE':
        return 'cheque'.tr;
      default:
        return method;
    }
  }
}
