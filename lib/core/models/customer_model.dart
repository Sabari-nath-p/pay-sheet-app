class Customer {
  final String id;
  final String customerId;
  final String shopName;
  final String phoneNumber;
  final String vat;
  final String description;
  final bool isActive;
  final int totalBills;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.customerId,
    required this.shopName,
    required this.phoneNumber,
    required this.vat,
    required this.description,
    required this.isActive,
    required this.totalBills,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      shopName: json['shopName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      vat: json['vat'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      totalBills: json['totalBills'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      pendingAmount: (json['pendingAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class PaginationData {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationData({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class CustomerResponse {
  final bool success;
  final String message;
  final List<Customer> data;
  final PaginationData pagination;

  CustomerResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => Customer.fromJson(item as Map<String, dynamic>))
              .toList(),
      pagination: PaginationData.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CreateCustomerRequest {
  final String customerId;
  final String phoneNumber;
  final String password;
  final String shopName;
  final String vat;
  final String description;

  CreateCustomerRequest({
    required this.customerId,
    required this.phoneNumber,
    required this.password,
    required this.shopName,
    required this.vat,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'phoneNumber': phoneNumber,
      'password': password,
      'shopName': shopName,
      'vat': vat,
      'description': description,
      //     'companyId': companyId,
    };
  }
}
