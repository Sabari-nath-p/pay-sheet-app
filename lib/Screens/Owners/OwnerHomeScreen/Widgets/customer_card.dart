import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/models/customer_model.dart';
import '../../../../core/utils/currency_formatter.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerCard({Key? key, required this.customer, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with customer ID and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customer.customerId,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: customer.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      customer.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Shop name
              Text(
                customer.shopName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4.h),

              // Phone number
              Row(
                children: [
                  Icon(Icons.phone, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    customer.phoneNumber,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Financial summary
              //  if (false)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFinancialItem(
                          'total_bills'.tr,
                          customer.totalBills.toString(),
                          Colors.blue,
                        ),
                        _buildFinancialItem(
                          'total_amount'.tr,
                          CurrencyFormatter.formatAmount(customer.totalAmount),
                          Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFinancialItem(
                          'paid'.tr,
                          CurrencyFormatter.formatAmount(customer.paidAmount),
                          Colors.green[700]!,
                        ),
                        _buildFinancialItem(
                          'pending'.tr,
                          CurrencyFormatter.formatAmount(
                            customer.pendingAmount,
                          ),
                          customer.pendingAmount > 0 ? Colors.red : Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Description (if available)
              if (customer.description.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  customer.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
