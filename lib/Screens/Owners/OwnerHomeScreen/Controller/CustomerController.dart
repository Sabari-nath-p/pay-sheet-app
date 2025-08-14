import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/customer_model.dart';
import '../../../../core/utils/api_constants.dart';

class CustomerController extends GetxController {
  // Observable variables
  var customers = <Customer>[].obs;
  var isLoading = false.obs;
  var isCreatingCustomer = false.obs;
  var paginationData =
      PaginationData(
        currentPage: 1,
        totalPages: 1,
        totalItems: 0,
        itemsPerPage: 10,
        hasNextPage: false,
        hasPreviousPage: false,
      ).obs;

  // Controllers for search and create customer form
  final searchController = TextEditingController();
  final customerIdController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final shopNameController = TextEditingController();
  final vatController = TextEditingController();
  final descriptionController = TextEditingController();

  // Form validation variables
  var isPasswordVisible = false.obs;

  // Pagination variables
  int currentPage = 1;
  int itemsPerPage = 10;
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null) {
      // Debug: Print token information
      print('Auth Token: $token');
      _debugJWTToken(token);
    }

    return token;
  }

  void _debugJWTToken(String token) {
    try {
      // Split JWT token and decode payload
      final parts = token.split('.');
      if (parts.length == 3) {
        // Decode payload (second part)
        String payload = parts[1];

        // Add padding if needed
        while (payload.length % 4 != 0) {
          payload += '=';
        }

        final decodedBytes = base64Url.decode(payload);
        final decodedPayload = utf8.decode(decodedBytes);
        final payloadJson = json.decode(decodedPayload);

        print('JWT Payload: $payloadJson');
        print('User Type: ${payloadJson['userType']}');
        print('Company ID: ${payloadJson['companyId']}');
        print('Login ID: ${payloadJson['loginId']}');
      }
    } catch (e) {
      print('Error decoding JWT: $e');
    }
  }

  String? _extractCompanyIdFromToken(String token) {
    try {
      // Split JWT token and decode payload
      final parts = token.split('.');
      if (parts.length == 3) {
        // Decode payload (second part)
        String payload = parts[1];

        // Add padding if needed
        while (payload.length % 4 != 0) {
          payload += '=';
        }

        final decodedBytes = base64Url.decode(payload);
        final decodedPayload = utf8.decode(decodedBytes);
        final payloadJson = json.decode(decodedPayload);

        return payloadJson['companyId'] as String?;
      }
    } catch (e) {
      print('Error extracting company ID from JWT: $e');
    }
    return null;
  }

  Future<void> loadCustomers({
    int page = 1,
    String? customerId,
    bool showLoading = true,
  }) async {
    if (showLoading) isLoading.value = true;

    try {
      final token = await getAuthToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      // Extract company ID from JWT token
      String? companyId = _extractCompanyIdFromToken(token);

      // Build query parameters
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': itemsPerPage.toString(),
      };

      if (customerId != null && customerId.isNotEmpty) {
        queryParams['customerId'] = customerId;
      }

      // Add company ID if available

      final uri = Uri.parse(
        ApiConstants.customerAnalyticsUrl,
      ).replace(queryParameters: queryParams);

      print('Request URL: $uri');
      print('Request Headers: Authorization: Bearer $token');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final customerResponse = CustomerResponse.fromJson(
          json.decode(response.body),
        );

        customers.value = customerResponse.data;
        paginationData.value = customerResponse.pagination;
        currentPage = page;
        searchQuery = customerId ?? '';
      } else {
        String errorMessage = 'failed_to_load_customers'.tr;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // Use default error message if response can't be parsed
        }

        print('Error Status Code: ${response.statusCode}');
        print('Error Response: ${response.body}');

        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_load_customers'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  void searchCustomers() {
    currentPage = 1;
    loadCustomers(page: currentPage, customerId: searchController.text.trim());
  }

  void clearSearch() {
    searchController.clear();
    currentPage = 1;
    loadCustomers(page: currentPage);
  }

  void nextPage() {
    if (paginationData.value.hasNextPage) {
      loadCustomers(
        page: currentPage + 1,
        customerId: searchQuery.isEmpty ? null : searchQuery,
        showLoading: false,
      );
    }
  }

  void previousPage() {
    if (paginationData.value.hasPreviousPage) {
      loadCustomers(
        page: currentPage - 1,
        customerId: searchQuery.isEmpty ? null : searchQuery,
        showLoading: false,
      );
    }
  }

  void refreshCustomers() {
    loadCustomers(
      page: currentPage,
      customerId: searchQuery.isEmpty ? null : searchQuery,
    );
  }

  bool _validateCreateCustomerForm() {
    if (customerIdController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'customer_id_required'.tr);
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'phone_number_required'.tr);
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'password_required'.tr);
      return false;
    }

    if (shopNameController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'shop_name_required'.tr);
      return false;
    }

    return true;
  }

  Future<void> createCustomer() async {
    if (!_validateCreateCustomerForm()) return;

    isCreatingCustomer.value = true;

    try {
      final token = await getAuthToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      // // Extract company ID from JWT token
      // String? companyId = _extractCompanyIdFromToken(token);
      // if (companyId == null) {
      //   Get.snackbar('Error', 'Company ID not found in token');
      //   return;
      // }

      final createRequest = CreateCustomerRequest(
        customerId: customerIdController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
        shopName: shopNameController.text.trim(),
        vat: vatController.text.trim(),
        description: descriptionController.text.trim(),
        //   companyId: companyId, // Use dynamic company ID from JWT
      );

      final response = await http.post(
        Uri.parse(ApiConstants.createCustomerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createRequest.toJson()),
      );
      print(response.body);
      if (response.statusCode == 201) {
        Get.snackbar(
          'success'.tr,
          'customer_created_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form
        clearCreateCustomerForm();

        // Close bottom sheet
        Get.back();

        // Refresh customer list
        refreshCustomers();
      } else if (response.statusCode == 409) {
        Get.snackbar(
          'error'.tr,
          'customer_id_already_exists'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 400) {
        String errorMessage = 'bad_request'.tr;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // Use default error message
        }

        Get.snackbar(
          'error'.tr,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        throw Exception('failed_to_create_customer'.tr);
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_create_customer'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingCustomer.value = false;
    }
  }

  void clearCreateCustomerForm() {
    customerIdController.clear();
    phoneController.clear();
    passwordController.clear();
    shopNameController.clear();
    vatController.clear();
    descriptionController.clear();
    isPasswordVisible.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    customerIdController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    shopNameController.dispose();
    vatController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
