class ApiConstants {
  // Replace this with your actual API base URL
  static const String baseUrl =
      "http://145.223.19.248:3000"; //'http://192.168.1.2:3000';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';

  // Customer endpoints
  static const String customerAnalyticsEndpoint =
      '/company-owners/customer-analytics';
  static const String createCustomerEndpoint = '/customers';

  // Transaction endpoints
  static const String billsEndpoint = '/bills';
  static const String paymentsEndpoint = '/payments';
  static const String returnsEndpoint = '/product-returns';
  static const String createReturnEndpoint = '/product-returns';

  // Customer endpoints
  static const String myBillsEndpoint = '/bills/my-bills';
  static const String myPaymentsEndpoint = '/payments/my-payments';
  static const String myReturnsEndpoint = '/product-returns';
  static const String myAnalyticsEndpoint = '/customers/my-analytics';

  // Complete URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get customerAnalyticsUrl =>
      '$baseUrl$customerAnalyticsEndpoint';
  static String get createCustomerUrl => '$baseUrl$createCustomerEndpoint';
  static String get billsUrl => '$baseUrl$billsEndpoint';
  static String get paymentsUrl => '$baseUrl$paymentsEndpoint';
  static String get returnsUrl => '$baseUrl$returnsEndpoint';
  static String get createReturnUrl => '$baseUrl$createReturnEndpoint';
  static String get myBillsUrl => '$baseUrl$myBillsEndpoint';
  static String get myPaymentsUrl => '$baseUrl$myPaymentsEndpoint';
  static String get myReturnsUrl => '$baseUrl$myReturnsEndpoint';
  static String get myAnalyticsUrl => '$baseUrl$myAnalyticsEndpoint';
}
