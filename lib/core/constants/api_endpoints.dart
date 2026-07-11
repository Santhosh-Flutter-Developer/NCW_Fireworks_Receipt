class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://sriseosolutions.com/mahendran/niyacrackers/section/retail_mobile_app/API';

  static const String reportsBaseUrl =
      'https://sriseosolutions.com/mahendran/niyacrackers/section/retail_mobile_app/reports';

  static Uri get login => Uri.parse('$baseUrl/login.php');
  static Uri get party => Uri.parse('$baseUrl/party.php');
  static Uri get productPrice => Uri.parse('$baseUrl/product.php');
  static Uri get estimate => Uri.parse('$baseUrl/estimate.php');

  /// Print/download A4 PDF for one estimate — same report is used for both
  /// actions; the browser/OS's own PDF viewer offers print & save/download.
  static Uri estimateReport(String estimateId) => Uri.parse(
      '$reportsBaseUrl/rpt_estimate_a4.php?view_estimate_id=$estimateId&from=');
}