class CustomerAnalytics {
  final double totalBillAmount;
  final double totalPaymentAmount;
  final double totalReturnAmount;
  final double netAmount;

  CustomerAnalytics({
    required this.totalBillAmount,
    required this.totalPaymentAmount,
    required this.totalReturnAmount,
    required this.netAmount,
  });

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) {
    return CustomerAnalytics(
      totalBillAmount: (json['totalBillAmount'] ?? 0).toDouble(),
      totalPaymentAmount: (json['totalPaymentAmount'] ?? 0).toDouble(),
      totalReturnAmount: (json['totalReturnAmount'] ?? 0).toDouble(),
      netAmount: (json['netAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBillAmount': totalBillAmount,
      'totalPaymentAmount': totalPaymentAmount,
      'totalReturnAmount': totalReturnAmount,
      'netAmount': netAmount,
    };
  }
}
