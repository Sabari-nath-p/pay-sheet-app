import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/models/customer_model.dart';
import '../../../core/utils/currency_formatter.dart';
import 'Controller/CustomerDetailController.dart';
import 'Widgets/bills_tab.dart';
import 'Widgets/payments_tab.dart';
import 'Widgets/returns_tab.dart';
import 'Widgets/create_bill_bottom_sheet.dart';
import 'Widgets/create_payment_bottom_sheet.dart';
import 'Widgets/create_return_bottom_sheet.dart';

class CustomerDetailedScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailedScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.put(
      CustomerDetailController(),
    );

    // Set the customer data
    controller.customer.value = customer;
    controller.loadBills();
    controller.loadPayments();
    controller.loadReturns();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          customer.shopName,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Container(
            color: Colors.blue,
            child: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Bills'),
                Tab(text: 'Payments'),
                Tab(text: 'Returns'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Customer Info Card
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      customer.customerId,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                Text(
                  customer.phoneNumber,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 12.h),

                // Financial Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'total_bills'.tr,
                        customer.totalBills.toString(),
                        Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        'total_amount'.tr,
                        CurrencyFormatter.formatAmount(customer.totalAmount),
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'paid'.tr,
                        CurrencyFormatter.formatAmount(customer.paidAmount),
                        Colors.green[700]!,
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        'pending'.tr,
                        CurrencyFormatter.formatAmount(customer.pendingAmount),
                        customer.pendingAmount > 0 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [BillsTab(), PaymentsTab(), ReturnsTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () =>
                _showCreateBottomSheet(context, controller.tabController.index),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        label: Text(
          _getButtonText(controller.tabController.index),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getButtonText(int index) {
    switch (index) {
      case 0:
        return 'New Bill';
      case 1:
        return 'New Payment';
      case 2:
        return 'New Return';
      default:
        return 'New';
    }
  }

  void _showCreateBottomSheet(BuildContext context, int index) {
    Widget bottomSheet;
    switch (index) {
      case 0:
        bottomSheet = CreateBillBottomSheet();
        break;
      case 1:
        bottomSheet = CreatePaymentBottomSheet();
        break;
      case 2:
        bottomSheet = CreateReturnBottomSheet();
        break;
      default:
        return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (context) => bottomSheet,
    );
  }
}
