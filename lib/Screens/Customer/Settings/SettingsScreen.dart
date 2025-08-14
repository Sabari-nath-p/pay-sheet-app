import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AuthenticationScreens/AuthenticationScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 20.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: color,
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
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
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
