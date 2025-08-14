import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/customer_model.dart';
import '../../../../core/models/transaction_models.dart';
import '../../../../core/utils/api_constants.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Customer data
  final Rx<Customer?> customer = Rx<Customer?>(null);

  // Observable variables for each tab
  var bills = <Bill>[].obs;
  var payments = <Payment>[].obs;
  var returns = <ProductReturn>[].obs;

  var isLoadingBills = false.obs;
  var isLoadingPayments = false.obs;
  var isLoadingReturns = false.obs;

  var isCreatingBill = false.obs;
  var isCreatingPayment = false.obs;
  var isCreatingReturn = false.obs;

  // Form controllers for creating bills
  final billIdController = TextEditingController();
  final billAmountController = TextEditingController();
  final billDescriptionController = TextEditingController();
  final billDateController = TextEditingController();

  // Form controllers for creating payments
  final voucherIdController = TextEditingController();
  final paymentAmountController = TextEditingController();
  final paymentDescriptionController = TextEditingController();
  final paymentDateController = TextEditingController();
  final selectedPaymentMethod = PaymentMethod.cash.obs;

  // Form controllers for creating returns
  final returnIdController = TextEditingController();
  final returnAmountController = TextEditingController();
  final returnDescriptionController = TextEditingController();
  final returnReasonController = TextEditingController();
  final returnDateController = TextEditingController();

  // Date selection
  final selectedBillDate = DateTime.now().obs;
  final selectedPaymentDate = DateTime.now().obs;
  final selectedReturnDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    // Initialize date controllers with today's date
    final today = DateTime.now();
    billDateController.text = _formatDate(today);
    paymentDateController.text = _formatDate(today);
    returnDateController.text = _formatDate(today);

    // Load data for all tabs
    loadBills();
    loadPayments();
    loadReturns();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  String? _extractCompanyIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        String payload = parts[1];
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

  // BILLS FUNCTIONALITY
  Future<void> loadBills() async {
    if (customer.value == null) return;

    isLoadingBills.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final queryParams = {'customerId': customer.value!.id};

      final uri = Uri.parse(
        ApiConstants.billsUrl,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        bills.value = data.map((item) => Bill.fromJson(item)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bills: ${e.toString()}');
    } finally {
      isLoadingBills.value = false;
    }
  }

  Future<void> createBill() async {
    if (!_validateBillForm()) return;
    if (customer.value == null) return;

    isCreatingBill.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final createRequest = CreateBillRequest(
        billId: billIdController.text.trim(),
        customerId: customer.value!.id,
        billDate: billDateController.text,
        amount: double.parse(billAmountController.text),
        description: billDescriptionController.text.trim(),
      );

      final response = await http.post(
        Uri.parse(ApiConstants.billsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createRequest.toJson()),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Bill created successfully');
        clearBillForm();
        Get.back();
        loadBills();
      } else {
        Get.snackbar('Error', 'Failed to create bill');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create bill: ${e.toString()}');
    } finally {
      isCreatingBill.value = false;
    }
  }

  bool _validateBillForm() {
    if (billIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Bill ID is required');
      return false;
    }
    if (billAmountController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Amount is required');
      return false;
    }
    if (double.tryParse(billAmountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return false;
    }
    return true;
  }

  void clearBillForm() {
    billIdController.clear();
    billAmountController.clear();
    billDescriptionController.clear();
    billDateController.text = _formatDate(DateTime.now());
    selectedBillDate.value = DateTime.now();
  }

  // PAYMENTS FUNCTIONALITY
  Future<void> loadPayments() async {
    if (customer.value == null) return;

    isLoadingPayments.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final queryParams = {'customerId': customer.value!.id};

      final uri = Uri.parse(
        ApiConstants.paymentsUrl,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        payments.value = data.map((item) => Payment.fromJson(item)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payments: ${e.toString()}');
    } finally {
      isLoadingPayments.value = false;
    }
  }

  Future<void> createPayment() async {
    if (!_validatePaymentForm()) return;
    if (customer.value == null) return;

    isCreatingPayment.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final createRequest = CreatePaymentRequest(
        voucherId: voucherIdController.text.trim(),
        customerId: customer.value!.id,
        paymentDate: paymentDateController.text,
        amount: double.parse(paymentAmountController.text),
        description: paymentDescriptionController.text.trim(),
        paymentMethod: selectedPaymentMethod.value.apiValue,
      );

      final response = await http.post(
        Uri.parse(ApiConstants.paymentsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createRequest.toJson()),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Payment created successfully');
        clearPaymentForm();
        Get.back();
        loadPayments();
      } else {
        Get.snackbar('Error', 'Failed to create payment');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create payment: ${e.toString()}');
    } finally {
      isCreatingPayment.value = false;
    }
  }

  bool _validatePaymentForm() {
    if (voucherIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Voucher ID is required');
      return false;
    }
    if (paymentAmountController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Amount is required');
      return false;
    }
    if (double.tryParse(paymentAmountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return false;
    }
    return true;
  }

  void clearPaymentForm() {
    voucherIdController.clear();
    paymentAmountController.clear();
    paymentDescriptionController.clear();
    paymentDateController.text = _formatDate(DateTime.now());
    selectedPaymentDate.value = DateTime.now();
    selectedPaymentMethod.value = PaymentMethod.cash;
  }

  // RETURNS FUNCTIONALITY
  Future<void> loadReturns() async {
    if (customer.value == null) return;

    isLoadingReturns.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final queryParams = {'customerId': customer.value!.id};

      final uri = Uri.parse(
        ApiConstants.returnsUrl,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final returnResponse = ReturnResponse.fromJson(
          json.decode(response.body),
        );
        returns.value = returnResponse.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load returns: ${e.toString()}');
    } finally {
      isLoadingReturns.value = false;
    }
  }

  Future<void> createReturn() async {
    if (!_validateReturnForm()) return;
    if (customer.value == null) return;

    isCreatingReturn.value = true;
    try {
      final token = await getAuthToken();
      if (token == null) return;

      final createRequest = CreateReturnRequest(
        returnId: returnIdController.text.trim(),
        customerId: customer.value!.id,
        returnDate: returnDateController.text,
        amount: double.parse(returnAmountController.text),
        description: returnDescriptionController.text.trim(),
        reason: returnReasonController.text.trim(),
      );

      final response = await http.post(
        Uri.parse(ApiConstants.createReturnUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createRequest.toJson()),
      );
      print(response.body);

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Return created successfully');
        clearReturnForm();
        Get.back();
        loadReturns();
      } else {
        Get.snackbar('Error', 'Failed to create return');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create return: ${e.toString()}');
    } finally {
      isCreatingReturn.value = false;
    }
  }

  bool _validateReturnForm() {
    if (returnIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Return ID is required');
      return false;
    }
    if (returnAmountController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Amount is required');
      return false;
    }
    if (double.tryParse(returnAmountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return false;
    }
    return true;
  }

  void clearReturnForm() {
    returnIdController.clear();
    returnAmountController.clear();
    returnDescriptionController.clear();
    returnReasonController.clear();
    returnDateController.text = _formatDate(DateTime.now());
    selectedReturnDate.value = DateTime.now();
  }

  // Date picker methods
  Future<void> selectBillDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBillDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedBillDate.value = picked;
      billDateController.text = _formatDate(picked);
    }
  }

  Future<void> selectPaymentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedPaymentDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedPaymentDate.value = picked;
      paymentDateController.text = _formatDate(picked);
    }
  }

  Future<void> selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedReturnDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedReturnDate.value = picked;
      returnDateController.text = _formatDate(picked);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    billIdController.dispose();
    billAmountController.dispose();
    billDescriptionController.dispose();
    billDateController.dispose();
    voucherIdController.dispose();
    paymentAmountController.dispose();
    paymentDescriptionController.dispose();
    paymentDateController.dispose();
    returnIdController.dispose();
    returnAmountController.dispose();
    returnDescriptionController.dispose();
    returnReasonController.dispose();
    returnDateController.dispose();
    super.onClose();
  }
}
