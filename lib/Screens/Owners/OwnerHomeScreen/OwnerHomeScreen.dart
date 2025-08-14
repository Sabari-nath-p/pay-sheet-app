import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/force_update_wrapper.dart';
import 'Controller/CustomerController.dart';
import 'Widgets/customer_card.dart';
import 'Widgets/create_customer_bottom_sheet.dart';
import '../CustomerDetailedPage/CustomerDetailedScreen.dart';
import '../Settings/OwnerSettingsScreen.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.put(CustomerController());

    return ForceUpdateWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'customer_management'.tr,
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
              onPressed: controller.refreshCustomers,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
            IconButton(
              onPressed: () => Get.to(() => const OwnerSettingsScreen()),
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.blue,
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'search_customers'.tr,
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 20.sp,
                        ),
                        suffixIcon:
                            controller.searchController.text.isNotEmpty
                                ? IconButton(
                                  onPressed: controller.clearSearch,
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey[600],
                                    size: 20.sp,
                                  ),
                                )
                                : const SizedBox.shrink(),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onSubmitted: (_) => controller.searchCustomers(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: controller.searchCustomers,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Customer List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'no_customers_found'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'create_your_first_customer'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Customer List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 8.h),
                        itemCount: controller.customers.length,
                        itemBuilder: (context, index) {
                          final customer = controller.customers[index];
                          return CustomerCard(
                            customer: customer,
                            onTap: () {
                              // Navigate to customer details
                              Get.to(
                                () =>
                                    CustomerDetailedScreen(customer: customer),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Pagination Controls
                    Obx(() => _buildPaginationControls(controller)),
                  ],
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: true,
              isDismissible: true,
              useSafeArea: true,
              builder: (context) => CreateCustomerBottomSheet(),
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: Text(
            'new_customer'.tr,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add),
        ),
      ), // End Scaffold
    ); // End ForceUpdateWrapper
  }

  Widget _buildPaginationControls(CustomerController controller) {
    if (controller.paginationData.value.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          TextButton.icon(
            onPressed:
                controller.paginationData.value.hasPreviousPage
                    ? controller.previousPage
                    : null,
            icon: const Icon(Icons.chevron_left),
            label: Text('previous'.tr),
            style: TextButton.styleFrom(
              foregroundColor:
                  controller.paginationData.value.hasPreviousPage
                      ? Colors.blue
                      : Colors.grey,
            ),
          ),

          // Page Info
          Text(
            'Page ${controller.paginationData.value.currentPage} of ${controller.paginationData.value.totalPages}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),

          // Next Button
          TextButton.icon(
            onPressed:
                controller.paginationData.value.hasNextPage
                    ? controller.nextPage
                    : null,
            icon: const Icon(Icons.chevron_right),
            label: Text('next'.tr),
            style: TextButton.styleFrom(
              foregroundColor:
                  controller.paginationData.value.hasNextPage
                      ? Colors.blue
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
