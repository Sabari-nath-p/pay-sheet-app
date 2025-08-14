import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../Controller/CustomerDashboardController.dart';
import '../../../../core/models/transaction_models.dart';

class CustomerReturnsTab extends StatelessWidget {
  const CustomerReturnsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDashboardController controller =
        Get.find<CustomerDashboardController>();

    return Obx(() {
      if (controller.isLoadingReturns.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.returns.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_return_outlined,
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
                'no_returns_found'.tr,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadReturns,
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.returns.length,
          itemBuilder: (context, index) {
            final returnItem = controller.returns[index];
            return ReturnCard(returnItem: returnItem);
          },
        ),
      );
    });
  }
}

class ReturnCard extends StatelessWidget {
  final ProductReturn returnItem;

  const ReturnCard({Key? key, required this.returnItem}) : super(key: key);

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
            // Header with Return ID and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'return_id'.tr}: ${returnItem.returnId}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${'return_date'.tr}: ${returnItem.returnDate.toString().split(' ')[0]}',
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    CurrencyFormatter.formatAmount(returnItem.amount),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getStatusColor(returnItem.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(returnItem.status),
                    size: 14.sp,
                    color: _getStatusColor(returnItem.status),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _getStatusText(returnItem.status),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(returnItem.status),
                    ),
                  ),
                ],
              ),
            ),

            // Reason
            if (returnItem.reason.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'reason'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      returnItem.reason,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],

            // Description
            if (returnItem.description.isNotEmpty) ...[
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
                      returnItem.description,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],

            // Return info
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.keyboard_return,
                  size: 14.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4.w),
                Text(
                  'Return ID: ${returnItem.id}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'pending'.tr;
      case 'approved':
        return 'approved'.tr;
      case 'rejected':
        return 'rejected'.tr;
      case 'processed':
        return 'processed'.tr;
      case 'completed':
        return 'completed'.tr;
      case 'cancelled':
        return 'cancelled'.tr;
      case 'active':
        return 'active'.tr;
      case 'inactive':
        return 'inactive'.tr;
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'processed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }
}
