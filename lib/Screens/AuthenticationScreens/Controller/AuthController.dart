import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:paysheet_app/Screens/Customer/CustomerDashboard/CustomerDashboardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Customer/CustomerHomeScreen/CHomeScreen.dart';
import '../../Owners/OwnerHomeScreen/OwnerHomeScreen.dart';
import '../../../core/utils/api_constants.dart';

class Authcontroller extends GetxController {
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  bool _validateSignInForm() {
    if (identifierController.text.trim().isEmpty) {
      Get.snackbar(
        'tr.error'.tr,
        'tr.fieldRequired'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'tr.error'.tr,
        'tr.fieldRequired'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkSavedUser();
  }

  void signIn() async {
    if (!_validateSignInForm()) return;

    isLoading = true;
    update();

    try {
      // Use API constants for endpoint
      final String endpoint = ApiConstants.loginUrl;

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier': identifierController.text.trim(),
          'password': passwordController.text,
        }),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract data from response
        final String accessToken = responseData['access_token'];
        final Map<String, dynamic> user = responseData['user'];
        final String userId = user['id'];
        final String userType = user['userType'];

        // Save to SharedPreferences
        await _saveUserData(
          userId: userId,
          token: accessToken,
          identifier: identifierController.text.trim(),
          userType: userType,
        );

        // Navigate based on user type
        if (userType.toLowerCase() == 'customer') {
          Get.offAll(() => const CustomerDashboardScreen());
        } else if (userType.toLowerCase() == 'companyowner') {
          Get.offAll(() => const OwnerHomeScreen());
        } else {
          Get.snackbar(
            'tr.error'.tr,
            'unknown_user_type'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle error response
        String errorMessage = 'login_failed'.tr;
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // Use default error message if response can't be parsed
        }

        Get.snackbar(
          'tr.error'.tr,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle network or other errors
      Get.snackbar(
        'tr.error'.tr,
        'Network error. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _saveUserData({
    required String userId,
    required String token,
    required String identifier,
    required String userType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('access_token', token);
    await prefs.setString('identifier', identifier);
    await prefs.setString('user_type', userType);
  }

  Future<void> checkSavedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');
    final String? token = prefs.getString('access_token');
    final String? userType = prefs.getString('user_type');

    if (userId != null && token != null && userType != null) {
      // User is already logged in, navigate to appropriate home screen
      if (userType.toLowerCase() == 'customer') {
        Get.offAll(() => const CustomerDashboardScreen());
      } else if (userType.toLowerCase() == 'companyowner') {
        Get.offAll(() => const OwnerHomeScreen());
      }
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigate back to login screen
    Get.offAllNamed('/login');
  }

  // Helper method to get stored user data
  Future<Map<String, String?>> getStoredUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString('user_id'),
      'access_token': prefs.getString('access_token'),
      'identifier': prefs.getString('identifier'),
      'user_type': prefs.getString('user_type'),
    };
  }

  @override
  void onClose() {
    identifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
