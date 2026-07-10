class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://sriseosolutions.com/mahendran/niyacrackers/section/retail_mobile_app/API';

  static Uri get login => Uri.parse('$baseUrl/login.php');
  static Uri get party => Uri.parse('$baseUrl/party.php');
}