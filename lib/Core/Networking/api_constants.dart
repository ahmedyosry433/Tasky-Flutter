class ApiConstants {
  // static const String apiBaseUrl = 'http://18.194.53.25/';
  static const String apiBaseUrl = 'https://node-api-loiy.onrender.com/';
  static const String loginUrl = 'auth/login';
  static const String profileUrl = 'auth/me';
  static const String allUsersUrl = 'auth';
  static const String allSuppliersUrl = 'users';
  static const String addUsersRegisterUrl = '/register';
  static const String allCategoriesUrl = 'categories';
  static const String startDateReportUrl = 'orders/weekly-report?startDate=';
  static const String startDateExportExcelReportUrl =
      'orders/weekly-report-export?startDate=';
  static const String endDateReportUrl = '&endDate=';
  static const String ordersUrl = 'orders';
  static const String addBalanceUrl = '/add-balance';
  
  static const String publicKey =
      'egy_pk_test_BR59iRuYBuXEslv5tJbLdCekSSxYIBs3';
  static const String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1Rnek5qSXlMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuaTMwU0JZSEdpSF9oVkN4UGNWR3IxbzUtOGpKd0NSUHpCTHNFNHpGRFJTRHRwQXQ5Vkx5bEZ1QlotcGotb0k1NnQ3XzdQQlNGd25pb1ZEMW5aWG1OTGc=';

  static const String paymentTokenUrl =
      'https://accept.paymob.com/api/auth/tokens';

  static const String paymentOrderUrl =
      'https://accept.paymob.com/api/ecommerce/orders';
  static const String paymentKeyUrl =
      'https://accept.paymob.com/api/acceptance/payment_keys';
}
