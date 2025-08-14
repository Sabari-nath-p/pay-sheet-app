import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/CustomerDetailController.dart';
import '../../../../core/models/transaction_models.dart';

class CreatePaymentBottomSheet extends StatelessWidget {
  const CreatePaymentBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller =
        Get.find<CustomerDetailController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                    'Create New Payment',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clearPaymentForm();
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

                    // Voucher ID Field
                    _buildTextField(
                      controller: controller.voucherIdController,
                      label: 'Voucher ID *',
                      hint: 'Enter voucher ID (e.g., VOUCHER001)',
                      icon: Icons.confirmation_number,
                    ),
                    SizedBox(height: 16.h),

                    // Payment Date Field
                    _buildDateField(
                      controller: controller.paymentDateController,
                      label: 'Payment Date *',
                      hint: 'Select payment date',
                      icon: Icons.calendar_today,
                      onTap: () => controller.selectPaymentDate(context),
                    ),
                    SizedBox(height: 16.h),

                    // Amount Field
                    _buildTextField(
                      controller: controller.paymentAmountController,
                      label: 'Amount *',
                      hint: 'Enter amount',
                      icon: Icons.monetization_on,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Payment Method Field
                    _buildPaymentMethodDropdown(controller),
                    SizedBox(height: 16.h),

                    // Description Field
                    _buildTextField(
                      controller: controller.paymentDescriptionController,
                      label: 'Description',
                      hint: 'Enter description (optional)',
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
                              controller.isCreatingPayment.value
                                  ? null
                                  : controller.createPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child:
                              controller.isCreatingPayment.value
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
                                    'Create Payment',
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
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          onTapOutside:
              (event) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20.sp),
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
              borderSide: const BorderSide(color: Colors.green, width: 2),
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
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
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20.sp),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
              size: 20.sp,
            ),
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
              borderSide: const BorderSide(color: Colors.green, width: 2),
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

  Widget _buildPaymentMethodDropdown(CustomerDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => DropdownButtonFormField<PaymentMethod>(
            value: controller.selectedPaymentMethod.value,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.payment,
                color: Colors.grey[600],
                size: 20.sp,
              ),
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
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            items:
                PaymentMethod.values.map((method) {
                  return DropdownMenuItem<PaymentMethod>(
                    value: method,
                    child: Text(
                      method.displayName,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }).toList(),
            onChanged: (PaymentMethod? value) {
              if (value != null) {
                controller.selectedPaymentMethod.value = value;
              }
            },
          ),
        ),
      ],
    );
  }
}
