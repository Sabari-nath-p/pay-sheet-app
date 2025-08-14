import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:paysheet_app/Screens/AuthenticationScreens/Controller/AuthController.dart';
import 'package:paysheet_app/core/theme/app_theme.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});

  Authcontroller controller = Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: GetBuilder<Authcontroller>(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.h),

                  // App Logo/Title
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80.w,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'app_title'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'professional_paysheet_management'.tr,
                          style: AppTextStyles.body2.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60.h),

                  // Login Form
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'sign_in'.tr,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h3.copyWith(fontSize: 24.sp),
                          ),

                          SizedBox(height: 32.h),

                          // Identifier Field (Email or Username)
                          TextFormField(
                            controller: controller.identifierController,
                            decoration: InputDecoration(
                              labelText: 'email_or_username'.tr,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            textInputAction: TextInputAction.next,
                          ),

                          SizedBox(height: 16.h),

                          // Password Field
                          TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'password'.tr,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => controller.signIn(),
                          ),

                          SizedBox(height: 32.h),

                          // Sign In Button
                          ElevatedButton(
                            onPressed:
                                controller.isLoading ? null : controller.signIn,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child:
                                controller.isLoading
                                    ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'sign_in'.tr,
                                      style: AppTextStyles.button.copyWith(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Language Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Get.updateLocale(const Locale('en')),
                        child: Text(
                          'English',
                          style: TextStyle(
                            color:
                                Get.locale?.languageCode == 'en'
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                            fontWeight:
                                Get.locale?.languageCode == 'en'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        ' | ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => Get.updateLocale(const Locale('ar')),
                        child: Text(
                          'العربية',
                          style: TextStyle(
                            color:
                                Get.locale?.languageCode == 'ar'
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                            fontWeight:
                                Get.locale?.languageCode == 'ar'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
