class ApiEndPoint {
  static const bool isProduction = true;
  static const apiBaseUrl =
      isProduction
          ? "https://kalapifarsan.business/api"
          : 'https://unfixable-pedately-kaden.ngrok-free.dev/api'; // Main Base url

  static const login = "$apiBaseUrl/User/login";
  static const home = "$apiBaseUrl/User/GetDashboardSummary";
  static const productList = "$apiBaseUrl/Product/GetProductList";
  static const branchDetails = "$apiBaseUrl/Branch/GetBranchDetails";
  static const productDetails = "$apiBaseUrl/Product/GetProductDetails";
  static const productCategoryList =
      "$apiBaseUrl/Product/GetProductCategoryList";
  static const checkOut = "$apiBaseUrl/Order/SaveOrder";
  static const getOrderList = "$apiBaseUrl/Order/GetOrderList";
  static const getOrderDetails = "$apiBaseUrl/Order/GetOrderDetails";
}

/// App-wide external links
class AppLinks {
  static const String privacyPolicy =
      "https://kalapifarsan.business/privacy-policy";
  static const String termsAndConditions =
      "https://kalapifarsan.business/terms-and-conditions";
}
