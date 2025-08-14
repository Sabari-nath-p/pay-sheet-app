import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/CustomerController.dart';

class CreateCustomerBottomSheet extends StatelessWidget {
  final CustomerController controller = Get.find<CustomerController>();

  CreateCustomerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text fields
        FocusScope.of(context).unfocus();
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed Header
            Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'create_new_customer'.tr,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clearCreateCustomerForm();
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Customer ID Field
                    _buildTextField(
                      controller: controller.customerIdController,
                      label: '${'customer_id'.tr} *',
                      hint: 'customer_id_hint'.tr,
                      icon: Icons.badge,
                    ),
                    SizedBox(height: 16.h),

                    // Phone Number Field
                    _buildTextField(
                      controller: controller.phoneController,
                      label: '${'phone_number'.tr} *',
                      hint: 'phone_number_hint'.tr,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    Obx(
                      () => _buildTextField(
                        controller: controller.passwordController,
                        label: '${'password'.tr} *',
                        hint: 'password'.tr,
                        icon: Icons.lock,
                        isPassword: true,
                        isPasswordVisible: controller.isPasswordVisible.value,
                        onTogglePassword: controller.togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Shop Name Field
                    _buildTextField(
                      controller: controller.shopNameController,
                      label: '${'shop_name'.tr} *',
                      hint: 'shop_name_hint'.tr,
                      icon: Icons.store,
                    ),
                    SizedBox(height: 16.h),

                    // VAT Field
                    _buildTextField(
                      controller: controller.vatController,
                      label: 'vat_number'.tr,
                      hint: 'vat_number_hint'.tr,
                      icon: Icons.receipt_long,
                    ),
                    SizedBox(height: 16.h),

                    // Description Field
                    _buildTextField(
                      controller: controller.descriptionController,
                      label: 'description'.tr,
                      hint: 'description_hint'.tr,
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    SizedBox(height: 24.h),

                    // Create Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed:
                              controller.isCreatingCustomer.value
                                  ? null
                                  : controller.createCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child:
                              controller.isCreatingCustomer.value
                                  ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'create_customer'.tr,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: isPassword && !isPasswordVisible,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          onTapOutside: (event) {
            // Dismiss keyboard when tapping outside
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20.sp),
            suffixIcon:
                isPassword
                    ? IconButton(
                      onPressed: onTogglePassword,
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                        size: 20.sp,
                      ),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }
}
