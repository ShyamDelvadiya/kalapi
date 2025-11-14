class ApiEndPoint {
  static const bool isProduction = false;
  static const apiBaseUrl =
      isProduction
          ? "https://mypgapi.vihaainfotech.com"
          : 'https://unfixable-pedately-kaden.ngrok-free.dev/api'; // Main Base url

  static const login = "$apiBaseUrl/User/login";
}
