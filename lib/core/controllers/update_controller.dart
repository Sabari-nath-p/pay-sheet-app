import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/firebase_service.dart';

class UpdateController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService.instance;

  final RxBool isCheckingForUpdate = false.obs;
  final RxBool isUpdateRequired = false.obs;
  final RxBool isForceUpdate = false.obs;
  final RxBool isUpdateDialogShowing = false.obs;

  // Keep track of update info for re-showing dialog if needed
  UpdateInfo? _currentUpdateInfo;

  @override
  void onInit() {
    super.onInit();
    // Check for updates when controller initializes
    checkForUpdates();
  }

  // Method to be called from any screen to ensure force update dialog is shown
  void ensureForceUpdateDialog() {
    if (_currentUpdateInfo?.isForceUpdate == true &&
        !isUpdateDialogShowing.value) {
      _showUpdateDialog(_currentUpdateInfo!);
    }
  }

  // Method to check if force update is blocking navigation
  bool get isForceUpdateBlocking => _currentUpdateInfo?.isForceUpdate == true;

  // Method to be called when app comes to foreground
  void onAppResumed() {
    ensureForceUpdateDialog();
  }

  // Debug method to test remote config
  Future<void> debugRemoteConfig() async {
    try {
      print('=== Remote Config Debug Info ===');

      // Refresh remote config
      bool refreshed = await _firebaseService.refreshRemoteConfig();
      print('Config refreshed: $refreshed');

      // Get current status
      Map<String, dynamic> status = _firebaseService.getRemoteConfigStatus();
      print('Remote Config Status:');
      status.forEach((key, value) {
        print('  $key: $value');
      });

      // Test update check
      UpdateInfo updateInfo = await _firebaseService.checkForUpdate();
      print('Update Info: $updateInfo');

      print('=== End Debug Info ===');
    } catch (e) {
      print('Debug error: $e');
    }
  }

  // Force check for updates (useful for testing)
  Future<void> forceCheckForUpdates() async {
    await debugRemoteConfig();
    await checkForUpdates();
  }

  // Test update dialog with mock data (for UI testing)
  // void testUpdateDialog({bool forceUpdate = false}) {
  //   final mockUpdateInfo = UpdateInfo(
  //     isUpdateRequired: true,
  //     isForceUpdate: forceUpdate,
  //     currentVersion: '1.0.0',
  //     latestVersion: '2.0.0',
  //     playStoreUrl:
  //         'https://play.google.com/store/apps/details?id=com.paysheet.app',
  //     appStoreUrl: 'https://apps.apple.com/app/paysheet-app/id123456789',
  //   );

  //   _showUpdateDialog(mockUpdateInfo);
  // }

  Future<void> checkForUpdates() async {
    try {
      isCheckingForUpdate.value = true;

      print('Starting update check...');

      UpdateInfo updateInfo = await _firebaseService.checkForUpdate();

      print('Update check completed: $updateInfo');

      isUpdateRequired.value = updateInfo.isUpdateRequired;
      isForceUpdate.value = updateInfo.isForceUpdate;

      // Store update info for re-use
      _currentUpdateInfo = updateInfo;

      if (updateInfo.isUpdateRequired) {
        await _firebaseService.logEvent('update_available', {
          'current_version': updateInfo.currentVersion,
          'latest_version': updateInfo.latestVersion,
          'is_force_update': updateInfo.isForceUpdate,
        });

        _showUpdateDialog(updateInfo);
      } else {
        print('No update required - App is up to date');
        _currentUpdateInfo = null; // Clear update info if no update required
      }
    } catch (e) {
      print('Error checking for updates: $e');
    } finally {
      isCheckingForUpdate.value = false;
    }
  }

  void _showUpdateDialog(UpdateInfo updateInfo) {
    if (isUpdateDialogShowing.value) return; // Prevent multiple dialogs

    isUpdateDialogShowing.value = true;

    Get.dialog(
      UpdateDialog(
        updateInfo: updateInfo,
        onUpdatePressed: () => _redirectToStore(updateInfo),
        onLaterPressed:
            updateInfo.isForceUpdate
                ? null
                : () {
                  isUpdateDialogShowing.value = false;
                  Get.back();
                },
      ),
      barrierDismissible: !updateInfo.isForceUpdate,
      barrierColor: updateInfo.isForceUpdate ? Colors.black87 : Colors.black54,
    ).then((_) {
      // Dialog was dismissed
      isUpdateDialogShowing.value = false;

      // If it's a force update, show the dialog again after a short delay
      if (updateInfo.isForceUpdate) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_currentUpdateInfo?.isForceUpdate == true &&
              !isUpdateDialogShowing.value) {
            _showUpdateDialog(updateInfo);
          }
        });
      }
    });
  }

  Future<void> _redirectToStore(UpdateInfo updateInfo) async {
    try {
      String url;

      if (Platform.isAndroid) {
        url = updateInfo.playStoreUrl;
      } else if (Platform.isIOS) {
        url = updateInfo.appStoreUrl;
      } else {
        throw Exception('Unsupported platform');
      }

      final Uri uri = Uri.parse(url);

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error redirecting to store: $e');
      Get.snackbar(
        'error'.tr,
        'update_error_message'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class UpdateDialog extends StatelessWidget {
  final UpdateInfo updateInfo;
  final VoidCallback onUpdatePressed;
  final VoidCallback? onLaterPressed;

  const UpdateDialog({
    Key? key,
    required this.updateInfo,
    required this.onUpdatePressed,
    this.onLaterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !updateInfo.isForceUpdate,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Update Icon
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color:
                      updateInfo.isForceUpdate
                          ? Colors.red.shade100
                          : Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  updateInfo.isForceUpdate
                      ? Icons.priority_high
                      : Icons.system_update,
                  size: 40.sp,
                  color: updateInfo.isForceUpdate ? Colors.red : Colors.blue,
                ),
              ),

              SizedBox(height: 16.h),

              // Title
              Text(
                updateInfo.isForceUpdate
                    ? 'force_update_title'.tr
                    : 'update_available_title'.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              // Message
              Text(
                updateInfo.isForceUpdate
                    ? 'force_update_message'.tr
                    : 'update_available_message'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              // Version Info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'current_version'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          updateInfo.currentVersion,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sp,
                      color: Colors.grey[400],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'latest_version'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          updateInfo.latestVersion,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Action Buttons
              Row(
                children: [
                  if (!updateInfo.isForceUpdate && onLaterPressed != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onLaterPressed,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'later'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    flex: updateInfo.isForceUpdate ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: onUpdatePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            updateInfo.isForceUpdate ? Colors.red : Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'update_now'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
