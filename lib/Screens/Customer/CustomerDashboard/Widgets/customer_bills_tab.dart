import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../Controller/CustomerDashboardController.dart';
import '../../../../core/models/transaction_models.dart';

class CustomerBillsTab extends StatelessWidget {
  const CustomerBillsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDashboardController controller =
        Get.find<CustomerDashboardController>();

    return Obx(() {
      if (controller.isLoadingBills.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.bills.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
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
                'no_bills_found'.tr,
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
            // Header with Bill ID and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'bill_id'.tr}: ${bill.billId}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${'bill_date'.tr}: ${bill.billDate.toString().split(' ')[0]}',
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
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    CurrencyFormatter.formatAmount(bill.amount),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            // Description
            if (bill.description.isNotEmpty) ...[
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
                      bill.description,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],

            // Bill info
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.receipt, size: 14.sp, color: Colors.grey[500]),
                SizedBox(width: 4.w),
                Text(
                  'Bill ID: ${bill.id}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
