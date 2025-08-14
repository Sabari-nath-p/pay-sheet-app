class Bill {
  final String id;
  final String billId;
  final String customerId;
  final String companyId;
  final String createdById;
  final DateTime billDate;
  final double amount;
  final String description;

  Bill({
    required this.id,
    required this.billId,
    required this.customerId,
    required this.companyId,
    required this.createdById,
    required this.billDate,
    required this.amount,
    required this.description,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? '',
      billId: json['billId'] ?? '',
      customerId: json['customerId'] ?? '',
      companyId: json['companyId'] ?? '',
      createdById: json['createdById'] ?? '',
      billDate: DateTime.parse(
        json['billDate'] ?? DateTime.now().toIso8601String(),
      ),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}

class CreateBillRequest {
  final String billId;
  final String customerId;
  final String billDate;
  final double amount;
  final String description;

  CreateBillRequest({
    required this.billId,
    required this.customerId,
    required this.billDate,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'customerId': customerId,
      'billDate': billDate,
      'amount': amount,
      'description': description,
    };
  }
}

class Payment {
  final String id;
  final String voucherId;
  final String customerId;
  final String companyId;
  final String receivedById;
  final DateTime paymentDate;
  final double amount;
  final String description;
  final String paymentMethod;
  final String status;

  Payment({
    required this.id,
    required this.voucherId,
    required this.customerId,
    required this.companyId,
    required this.receivedById,
    required this.paymentDate,
    required this.amount,
    required this.description,
    required this.paymentMethod,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      voucherId: json['voucherId'] ?? '',
      customerId: json['customerId'] ?? '',
      companyId: json['companyId'] ?? '',
      receivedById: json['receivedById'] ?? '',
      paymentDate: DateTime.parse(
        json['paymentDate'] ?? DateTime.now().toIso8601String(),
      ),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CreatePaymentRequest {
  final String voucherId;
  final String customerId;
  final String paymentDate;
  final double amount;
  final String description;
  final String paymentMethod;

  CreatePaymentRequest({
    required this.voucherId,
    required this.customerId,
    required this.paymentDate,
    required this.amount,
    required this.description,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucherId': voucherId,
      'customerId': customerId,
      'paymentDate': paymentDate,
      'amount': amount,
      'description': description,
      'paymentMethod': paymentMethod,
    };
  }
}

class ProductReturn {
  final String id;
  final String returnId;
  final String customerId;
  final String companyId;
  final String processedById;
  final DateTime returnDate;
  final double amount;
  final String description;
  final String reason;
  final String status;

  ProductReturn({
    required this.id,
    required this.returnId,
    required this.customerId,
    required this.companyId,
    required this.processedById,
    required this.returnDate,
    required this.amount,
    required this.description,
    required this.reason,
    required this.status,
  });

  factory ProductReturn.fromJson(Map<String, dynamic> json) {
    return ProductReturn(
      id: json['id'] ?? '',
      returnId: json['returnId'] ?? '',
      customerId: json['customerId'] ?? '',
      companyId: json['companyId'] ?? '',
      processedById: json['processedById'] ?? '',
      returnDate: DateTime.parse(
        json['returnDate'] ?? DateTime.now().toIso8601String(),
      ),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CreateReturnRequest {
  final String returnId;
  final String customerId;
  final String returnDate;
  final double amount;
  final String description;
  final String reason;

  CreateReturnRequest({
    required this.returnId,
    required this.customerId,
    required this.returnDate,
    required this.amount,
    required this.description,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'returnId': returnId,
      'customerId': customerId,
      'returnDate': returnDate,
      'amount': amount,
      'description': description,
      'reason': reason,
    };
  }
}

class ReturnResponse {
  final bool success;
  final String message;
  final List<ProductReturn> data;
  final int total;

  ReturnResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.total,
  });

  factory ReturnResponse.fromJson(Map<String, dynamic> json) {
    return ReturnResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map(
                (item) => ProductReturn.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      total: json['total'] ?? 0,
    );
  }
}

enum PaymentMethod {
  cash,
  pos,
  bank,
  cheque;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.pos:
        return 'POS';
      case PaymentMethod.bank:
        return 'BANK';
      case PaymentMethod.cheque:
        return 'CHEQUE';
    }
  }

  String get apiValue {
    return displayName;
  }
}
