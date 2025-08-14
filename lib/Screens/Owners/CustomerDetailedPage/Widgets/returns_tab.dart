import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/CustomerDetailController.dart';
import '../../../../core/models/transaction_models.dart';
import '../../../../core/utils/currency_formatter.dart';

class ReturnsTab extends StatelessWidget {
  const ReturnsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller =
        Get.find<CustomerDetailController>();

    return Obx(() {
      if (controller.isLoadingReturns.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.returns.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_return, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No returns found',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create your first return to get started',
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
            final productReturn = controller.returns[index];
            return ReturnCard(productReturn: productReturn);
          },
        ),
      );
    });
  }
}

class ReturnCard extends StatelessWidget {
  final ProductReturn productReturn;

  const ReturnCard({Key? key, required this.productReturn}) : super(key: key);

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
                  productReturn.returnId,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  CurrencyFormatter.formatAmount(productReturn.amount),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
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
                      _formatDate(productReturn.returnDate),
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
                    color: _getStatusColor(productReturn.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    productReturn.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (productReturn.reason.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Reason: ${productReturn.reason}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (productReturn.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                productReturn.description,
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
      case 'REJECTED':
        return Colors.red;
      case 'PROCESSING':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
