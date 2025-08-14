import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/customer_analytics_model.dart';
import '../../../../core/models/transaction_models.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../AuthenticationScreens/AuthenticationScreen.dart';

class CustomerDashboardController extends GetxController
    with GetTickerProviderStateMixin {
  // Observable variables
  var isLoading = false.obs;
  var analytics = Rx<CustomerAnalytics?>(null);
  var bills = <Bill>[].obs;
  var payments = <Payment>[].obs;
  var returns = <ProductReturn>[].obs;

  // Filter variables
  var fromDate = Rx<DateTime?>(null);
  var toDate = Rx<DateTime?>(null);
  var isFilterApplied = false.obs;

  // UI controllers
  late TabController tabController;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  // Loading states
  var isLoadingBills = false.obs;
  var isLoadingPayments = false.obs;
  var isLoadingReturns = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    loadDashboardData();
  }

  @override
  void onClose() {
    tabController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.onClose();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    isLoading.value = true;

    await loadAnalytics();
    await loadBills();
    await loadPayments();
    await loadReturns();

    // } catch (e) {
    //   print('Error loading dashboard data: $e');
    //   Get.snackbar('error'.tr, e.toString());
    // } finally {
    isLoading.value = false;

    // }
  }

  // Load customer analytics
  Future<void> loadAnalytics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _handleUnauthorized();
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.myAnalyticsUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Analytics Response Status: ${response.statusCode}');
      print('Analytics Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        analytics.value = CustomerAnalytics.fromJson(data);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading analytics: $e');
      throw e;
    }
  }

  // Load bills with optional date filter
  Future<void> loadBills() async {
    isLoadingBills.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _handleUnauthorized();
        return;
      }

      String url = ApiConstants.myBillsUrl;
      if (isFilterApplied.value &&
          fromDate.value != null &&
          toDate.value != null) {
        url +=
            '?fromDate=${fromDate.value!.toIso8601String()}&toDate=${toDate.value!.toIso8601String()}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Bills Response Status: ${response.statusCode}');
      print('Bills Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> billsData = data['data'] ?? [];
        bills.value = billsData.map((json) => Bill.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        throw Exception('Failed to load bills: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading bills: $e');
      Get.snackbar('error'.tr, e.toString());
    } finally {
      isLoadingBills.value = false;
    }
  }

  // Load payments with optional date filter
  Future<void> loadPayments() async {
    isLoadingPayments.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _handleUnauthorized();
        return;
      }

      String url = ApiConstants.myPaymentsUrl;
      if (isFilterApplied.value &&
          fromDate.value != null &&
          toDate.value != null) {
        url +=
            '?fromDate=${fromDate.value!.toIso8601String()}&toDate=${toDate.value!.toIso8601String()}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Payments Response Status: ${response.statusCode}');
      print('Payments Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> paymentsData = data['data'] ?? [];
        payments.value =
            paymentsData.map((json) => Payment.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading payments: $e');
      Get.snackbar('error'.tr, e.toString());
    } finally {
      isLoadingPayments.value = false;
    }
  }

  // Load returns with optional date filter
  Future<void> loadReturns() async {
    isLoadingReturns.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _handleUnauthorized();
        return;
      }

      String url = ApiConstants.myReturnsUrl;
      if (isFilterApplied.value &&
          fromDate.value != null &&
          toDate.value != null) {
        url +=
            '?fromDate=${fromDate.value!.toIso8601String()}&toDate=${toDate.value!.toIso8601String()}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Returns Response Status: ${response.statusCode}');
      print('Returns Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> returnsData = data['data'] ?? [];
        returns.value =
            returnsData.map((json) => ProductReturn.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        throw Exception('Failed to load returns: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading returns: $e');
      Get.snackbar('error'.tr, e.toString());
    } finally {
      isLoadingReturns.value = false;
    }
  }

  // Date picker methods
  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      fromDate.value = picked;
      fromDateController.text = picked.toString().split(' ')[0];
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? DateTime.now(),
      firstDate: fromDate.value ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      toDate.value = picked;
      toDateController.text = picked.toString().split(' ')[0];
    }
  }

  // Apply date filter
  Future<void> applyFilter() async {
    if (fromDate.value != null && toDate.value != null) {
      if (fromDate.value!.isAfter(toDate.value!)) {
        Get.snackbar('error'.tr, 'From date cannot be after to date');
        return;
      }

      isFilterApplied.value = true;
      await Future.wait([loadBills(), loadPayments(), loadReturns()]);
      Get.snackbar('success'.tr, 'filter_applied'.tr);
    } else {
      Get.snackbar('error'.tr, 'Please select both from and to dates');
    }
  }

  // Clear filter
  Future<void> clearFilter() async {
    fromDate.value = null;
    toDate.value = null;
    fromDateController.clear();
    toDateController.clear();
    isFilterApplied.value = false;

    await Future.wait([loadBills(), loadPayments(), loadReturns()]);
    Get.snackbar('success'.tr, 'clear_filter'.tr);
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadDashboardData();
    Get.snackbar('success'.tr, 'data_loaded_successfully'.tr);
  }

  // Handle unauthorized access
  void _handleUnauthorized() {
    return;
    Get.snackbar('error'.tr, 'session_expired'.tr);
    _logout();
  }

  // Logout method
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => AuthenticationScreen());
  }
}
