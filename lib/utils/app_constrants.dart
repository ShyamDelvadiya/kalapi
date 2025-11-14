import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';

class ApiEndPoint {
  static const bool isProduction = false;
  static const apiBaseUrl =
      isProduction
          ? "https://mypgapi.vihaainfotech.com"
          : 'https://unfixable-pedately-kaden.ngrok-free.dev/api'; // Main Base url

  static const login = "$apiBaseUrl/User/login";
  static const home = "$apiBaseUrl/User/GetDashboardSummary";
  static const productList = "$apiBaseUrl/Product/GetProductList";
  static const productDetails = "$apiBaseUrl/Product/GetProductDetails";
}
