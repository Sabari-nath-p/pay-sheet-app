import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AuthenticationScreens/AuthenticationScreen.dart';

class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Profile Section
          _buildSettingsCard(
            title: 'profile'.tr,
            icon: Icons.person,
            child: Column(children: [_buildProfileInfo()]),
          ),

          SizedBox(height: 16.h),

          // Language Section
          _buildSettingsCard(
            title: 'language'.tr,
            icon: Icons.language,
            child: Column(
              children: [
                _buildLanguageTile(
                  title: 'english'.tr,
                  locale: const Locale('en', 'US'),
                  isSelected: Get.locale?.languageCode == 'en',
                ),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildLanguageTile(
                  title: 'arabic'.tr,
                  locale: const Locale('ar', 'SA'),
                  isSelected: Get.locale?.languageCode == 'ar',
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Business Settings Section
          _buildSettingsCard(
            title: 'business_settings'.tr,
            icon: Icons.business,
            child: Column(
              children: [
                _buildSettingsItem(
                  title: 'company_information'.tr,
                  icon: Icons.info,
                  onTap: () => _showCompanyInfoDialog(context),
                ),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildSettingsItem(
                  title: 'customer_management'.tr,
                  icon: Icons.people,
                  onTap: () => Get.back(), // Goes back to customer management
                ),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildSettingsItem(
                  title: 'reports_analytics'.tr,
                  icon: Icons.analytics,
                  onTap: () => _showComingSoonDialog(context),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Security Section
          _buildSettingsCard(
            title: 'security'.tr,
            icon: Icons.security,
            child: Column(
              children: [
                _buildSettingsItem(
                  title: 'change_password'.tr,
                  icon: Icons.lock,
                  onTap: () => _showComingSoonDialog(context),
                ),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildSettingsItem(
                  title: 'two_factor_auth'.tr,
                  icon: Icons.verified_user,
                  onTap: () => _showComingSoonDialog(context),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Account Section
          _buildSettingsCard(
            title: 'Account',
            icon: Icons.account_circle,
            child: Column(
              children: [
                _buildSettingsItem(
                  title: 'logout'.tr,
                  icon: Icons.logout,
                  color: Colors.red,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // App Info
          _buildSettingsCard(
            title: 'App Information',
            icon: Icons.info,
            child: Column(
              children: [
                _buildInfoItem('Version', '1.0.0'),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildInfoItem('Build', '100'),
                Divider(height: 1.h, color: Colors.grey[300]),
                _buildInfoItem('Last Updated', 'August 2025'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return FutureBuilder<Map<String, String>>(
      future: _getProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data ?? {};
        return Column(
          children: [
            _buildInfoItem('User ID', data['userId'] ?? 'N/A'),
            Divider(height: 1.h, color: Colors.grey[300]),
            _buildInfoItem('Company', data['companyName'] ?? 'N/A'),
            Divider(height: 1.h, color: Colors.grey[300]),
            _buildInfoItem('Role', 'Owner'),
          ],
        );
      },
    );
  }

  Widget _buildLanguageTile({
    required String title,
    required Locale locale,
    required bool isSelected,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: Colors.blue, size: 20.sp)
              : Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey,
                size: 20.sp,
              ),
      onTap: () => _changeLanguage(locale),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.grey[600], size: 20.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.sp),
      onTap: onTap,
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>> _getProfileInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? 'N/A';
      final companyName = prefs.getString('companyName') ?? 'N/A';

      return {'userId': userId, 'companyName': companyName};
    } catch (e) {
      return {'userId': 'N/A', 'companyName': 'N/A'};
    }
  }

  void _changeLanguage(Locale locale) async {
    await Get.updateLocale(locale);

    // Save language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');

    Get.snackbar(
      'success'.tr,
      'language_changed'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showCompanyInfoDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'company_information'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: FutureBuilder<Map<String, String>>(
          future: _getProfileInfo(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? {};
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogInfoItem(
                  'Company Name',
                  data['companyName'] ?? 'N/A',
                ),
                SizedBox(height: 8.h),
                _buildDialogInfoItem('Owner ID', data['userId'] ?? 'N/A'),
                SizedBox(height: 8.h),
                _buildDialogInfoItem('Account Type', 'Business Owner'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogInfoItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'coming_soon'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'coming_soon_message'.tr,
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('ok'.tr, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'logout'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('logout'.tr, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Get.snackbar(
        'success'.tr,
        'Logged out successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => AuthenticationScreen());
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to logout: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
