import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/CustomerDetailController.dart';
import '../../../../core/models/transaction_models.dart';
import '../../../../core/utils/currency_formatter.dart';

class BillsTab extends StatelessWidget {
  const BillsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller =
        Get.find<CustomerDetailController>();

    return Obx(() {
      if (controller.isLoadingBills.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.bills.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No bills found',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create your first bill to get started',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadBills,
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.bills.length,
          itemBuilder: (context, index) {
            final bill = controller.bills[index];
            return BillCard(bill: bill);
          },
        ),
      );
    });
  }
}

class BillCard extends StatelessWidget {
  final Bill bill;

  const BillCard({Key? key, required this.bill}) : super(key: key);

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
                  bill.billId,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  CurrencyFormatter.formatAmount(bill.amount),
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
              children: [
                Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  _formatDate(bill.billDate),
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            if (bill.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                bill.description,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
