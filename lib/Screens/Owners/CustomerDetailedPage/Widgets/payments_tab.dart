import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/CustomerDetailController.dart';
import '../../../../core/models/transaction_models.dart';
import '../../../../core/utils/currency_formatter.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller =
        Get.find<CustomerDetailController>();

    return Obx(() {
      if (controller.isLoadingPayments.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.payments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.payment, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No payments found',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create your first payment to get started',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  payment.voucherId,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  CurrencyFormatter.formatAmount(payment.amount),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(payment.paymentDate),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    payment.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  _getPaymentMethodIcon(payment.paymentMethod),
                  size: 16.sp,
                  color: Colors.grey,
                ),
                SizedBox(width: 4.w),
                Text(
                  payment.paymentMethod,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (payment.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                payment.description,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return Icons.money;
      case 'POS':
        return Icons.credit_card;
      case 'BANK':
        return Icons.account_balance;
      case 'CHEQUE':
        return Icons.receipt;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
