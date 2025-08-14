import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/currency_formatter.dart';
import 'Controller/CustomerDashboardController.dart';
import 'Widgets/customer_bills_tab.dart';
import 'Widgets/customer_payments_tab.dart';
import 'Widgets/customer_returns_tab.dart';
import 'Widgets/filter_bottom_sheet.dart';
import '../Settings/SettingsScreen.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerDashboardController controller = Get.put(
      CustomerDashboardController(),
    );
    controller.loadDashboardData();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'dashboard'.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: Obx(
              () => Stack(
                children: [
                  const Icon(Icons.filter_list, color: Colors.white),
                  if (controller.isFilterApplied.value)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.to(() => const SettingsScreen()),
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
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
              tabs: [
                Tab(text: 'bills'.tr),
                Tab(text: 'payments'.tr),
                Tab(text: 'returns'.tr),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Analytics Summary Card
              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final analytics = controller.analytics.value;
                if (analytics == null) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade50, Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.analytics,
                                color: Colors.blue,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'financial_summary'.tr,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  Text(
                                    'your_financial_overview'.tr,
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
                                color:
                                    analytics.netAmount >= 0
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    analytics.netAmount >= 0
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color:
                                        analytics.netAmount >= 0
                                            ? Colors.green
                                            : Colors.red,
                                    size: 16.sp,
                                  ),
                                  // SizedBox(width: 4.w),
                                  // Text(
                                  //   analytics.netAmount >= 0
                                  //       ? 'positive'.tr
                                  //       : 'negative'.tr,
                                  //   style: TextStyle(
                                  //     fontSize: 11.sp,
                                  //     fontWeight: FontWeight.w600,
                                  //     color:
                                  //         analytics.netAmount >= 0
                                  //             ? Colors.green
                                  //             : Colors.red,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Net Amount Display (Prominent)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  analytics.netAmount >= 0
                                      ? [
                                        Colors.green.shade400,
                                        Colors.green.shade600,
                                      ]
                                      : [
                                        Colors.red.shade400,
                                        Colors.red.shade600,
                                      ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: (analytics.netAmount >= 0
                                        ? Colors.green
                                        : Colors.red)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'net_amount'.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                CurrencyFormatter.formatAmount(
                                  analytics.netAmount,
                                ),
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Financial Breakdown
                        Row(
                          children: [
                            Expanded(
                              child: _buildModernAnalyticsItem(
                                'total_bill_amount'.tr,
                                CurrencyFormatter.formatAmount(
                                  analytics.totalBillAmount,
                                ),
                                Colors.blue,
                                Icons.receipt_long,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildModernAnalyticsItem(
                                'total_payment_amount'.tr,
                                CurrencyFormatter.formatAmount(
                                  analytics.totalPaymentAmount,
                                ),
                                Colors.green,
                                Icons.payments,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        Row(
                          children: [
                            Expanded(
                              child: _buildModernAnalyticsItem(
                                'total_return_amount'.tr,
                                CurrencyFormatter.formatAmount(
                                  analytics.totalReturnAmount,
                                ),
                                Colors.orange,
                                Icons.keyboard_return,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey.shade600,
                                      size: 20.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'balance'.tr,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'updated'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Tab Content with fixed height to allow scrolling
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: controller.tabController,
                  children: const [
                    CustomerBillsTab(),
                    CustomerPaymentsTab(),
                    CustomerReturnsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAnalyticsItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
