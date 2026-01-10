import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kalapi/data/Model/base_model.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/diamension.dart';

class ResponseModel {
  /// HTTP-like code returned by your API (e.g. 200)
  int? code;

  /// Optional transaction id returned by API (taid)
  int? taid;

  /// Message returned by API
  String? message;

  /// Data payload (usually a map)
  Map<String, dynamic>? data;

  /// List of errors parsed from the response
  List<Error>? error;

  ResponseModel({this.code, this.taid, this.message, this.data, this.error});

  /// Convenience constructor used when the request succeeded and we have a data map
  ResponseModel.withSuccess(
    Map<String, dynamic> d, {
    int? code,
    String? message,
    int? taid,
  }) {
    this.code = code ?? 200;
    this.taid = taid;
    this.message = message;
    this.data = d;
    this.error = null;
  }

  /// Convenience constructor used when the request failed and we have errors
  ResponseModel.withError(
    List<Error> e, {
    int? code,
    String? message,
    int? taid,
  }) {
    this.code = code;
    this.taid = taid;
    this.message = message;
    this.data = null;
    this.error = e;
  }

  /// Create ResponseModel from raw JSON that matches your API envelope
  factory ResponseModel.fromJson(dynamic json) {
    if (json == null) return ResponseModel();

    final int? code =
        json['code'] is int
            ? json['code']
            : (json['code'] != null
                ? int.tryParse(json['code'].toString())
                : null);
    final int? taid =
        json['taid'] is int
            ? json['taid']
            : (json['taid'] != null
                ? int.tryParse(json['taid'].toString())
                : null);
    final String? message = json['message']?.toString();

    Map<String, dynamic>? data;
    if (json['data'] is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(json['data']);
    }

    List<Error>? errors;
    if (json['errors'] != null && json['errors'] is List) {
      errors = [];
      for (var v in json['errors']) {
        errors.add(Error.fromJson(v));
      }
    } else if (json['error'] != null) {
      if (json['error'] is List) {
        errors = [];
        for (var v in json['error']) {
          errors.add(Error(message: v.toString()));
        }
      } else if (json['error'] is String) {
        errors = [Error(message: json['error'])];
      }
    }

    return ResponseModel(
      code: code,
      taid: taid,
      message: message,
      data: data,
      error: errors,
    );
  }
}

class RestRequestProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 20);

    // httpClient.defaultDecoder = baseResponse.fromJson;

    // httpClient.addAuthenticator((request) async {
    //   var headers = {
    //     'APIKey': "3297F0F2-35D3-4231-919D-1CFCF4035975",
    //     'UserId': "6",
    //     'UserSessionId': "327a8c0c-b404-4435-9693-ba3a62c35eb4",
    //   };
    //   request.headers.addAll(headers);
    //   return request;
    // });
    super.onInit();
  }

  Map<String, String>? getHeader() {
    // Build a common set of headers for API requests.
    // Read token from persistent storage (`pref`) and include it as a Bearer token when available.
    try {
      final token = pref.read('userToken');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null && token.toString().isNotEmpty) {
        headers['Authorization'] = 'Bearer ${token.toString()}';
      }
      return headers;
    } catch (e) {
      // Fallback to minimal headers if pref isn't available for some reason
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    }
  }

  /// Safely shows an error snackbar, handling cases where Get context might not be available
  void _showErrorSnackbar(String message) {
    try {
      final errorMessage = message.isNotEmpty ? message : "An error occurred";
      log("🔴 Showing error snackbar: $errorMessage");

      // Add a small delay to ensure UI is ready, then show snackbar
      Future.delayed(Duration(milliseconds: 100), () {
        _showSnackbarInternal(errorMessage);
      });
    } catch (e) {
      // If scheduling fails, try to show immediately
      try {
        final errorMessage = message.isNotEmpty ? message : "An error occurred";
        _showSnackbarInternal(errorMessage);
      } catch (e2) {
        print("❌ Failed to show snackbar: $e2. Error message: $message");
        log("❌ Failed to show snackbar: $e2. Error message: $message");
      }
    }
  }

  /// Internal method to show snackbar with multiple fallback strategies
  void _showSnackbarInternal(String errorMessage) {
    // Try ScaffoldMessenger first (most reliable, works with Stack overlays)
    try {
      final scaffoldState = rootScaffoldMessengerKey.currentState;
      if (scaffoldState != null && scaffoldState.mounted) {
        scaffoldState.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 6,
            dismissDirection: DismissDirection.horizontal,
          ),
        );
        log(
          "✅ Snackbar shown via ScaffoldMessenger (rootScaffoldMessengerKey)",
        );
        return;
      } else {
        log(
          "⚠️ ScaffoldMessenger currentState is null or not mounted. State: $scaffoldState",
        );
      }
    } catch (scaffoldError) {
      log("⚠️ ScaffoldMessenger snackbar failed: $scaffoldError");
    }

    // Try using Get.context if available
    try {
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 6,
          ),
        );
        log("✅ Snackbar shown via ScaffoldMessenger (Get.context)");
        return;
      }
    } catch (contextError) {
      log("⚠️ ScaffoldMessenger via Get.context failed: $contextError");
    }

    // Fallback: Try Get.snackbar
    try {
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 8,
        margin: EdgeInsets.all(16.0),
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
        shouldIconPulse: true,
        maxWidth: 400,
      );
      log("✅ Snackbar shown via Get.snackbar");
      return;
    } catch (getError) {
      log("⚠️ Get.snackbar failed: $getError");
    }

    // Fallback: Try Get.showSnackbar
    try {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          borderRadius: 8,
          margin: EdgeInsets.all(16.0),
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          message: errorMessage,
        ),
      );
      log("✅ Snackbar shown via Get.showSnackbar");
      return;
    } catch (getError2) {
      log("⚠️ Get.showSnackbar failed: $getError2");
    }

    // Last resort: print to console
    print("❌ ERROR: $errorMessage");
  }

  // Future<ResponseModel> doGet(
  //     {required String endPoint,
  //     dynamic requestData,
  //     Map<String, String>? headers,
  //     Map<String, dynamic>? queryParams,
  //     required Function(Map<String, dynamic> response) onSuccess,
  //     required Function(List<Error> error, int statusCode) onError,
  //     Function(List<Error> errors)? onConnectionError,
  //     Rx<RequestStatus>? requestStatus,
  //     Duration? cacheDuration}) async {
  //   print("requestData $queryParams");
  //   try {
  //     String queryString = '';
  //     if (queryParams != null) {
  //       queryString = '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
  //     }
  //     String url = endPoint + queryString;
  //
  //     changeRequestStatus(requestStatus, RequestStatus.loading);
  //     var response = await get(url, headers: headers ?? getHeader());
  //     print("response.statusCode ${response.statusCode}");
  //     print("response.statusText ${response.statusText}");
  //     if (response.isOk) {
  //       print("response.isOkk");
  //       var baseResponse = BaseResponse.fromJson(response.body);
  //       if (response.statusCode == 200) {
  //         onSuccess(response.body);
  //         log("success.request:${response.body}");
  //         print("endpoint $url");
  //         changeRequestStatus(requestStatus, RequestStatus.success);
  //         return ResponseModel.withSuccess(response.body);
  //       } else {
  //         print("onError");
  //         onError([Error(message: baseResponse.message ?? "Unknown error")],
  //             response.statusCode ?? 0); // Include statusCode
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError([]);
  //       }
  //     } else if (response.hasError) {
  //       print("hasError ${response.bodyString}");
  //       print("hasError ${response.body}");
  //       print("hasError ${response.status}");
  //
  //       if (response.status.connectionError && onConnectionError != null) {
  //         onConnectionError([Error(message: "Please Check your internet connection")]);
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError([]);
  //       }
  //
  //       if (response.body != null) {
  //         var baseResponse = BaseResponse.fromJson(response.body);
  //         onError([Error(message: baseResponse.message ?? "Unknown error")],
  //             response.statusCode ?? 0); // Include statusCode
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError(baseResponse.error ?? []);
  //       } else {
  //         onError(
  //             [Error(message: "Unknown error")], response.statusCode ?? 0); // Include statusCode
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError(getError(response));
  //       }
  //     }
  //   } catch (e) {
  //     print("catch error ${e.toString()}");
  //     List<Error> errors = [Error(message: "Exceptional Error : ${e.toString()}")];
  //     onError(errors, 0); // Include null as statusCode
  //     changeRequestStatus(requestStatus, RequestStatus.failed);
  //     return ResponseModel.withError(errors);
  //   }
  //   return ResponseModel.withError([]);
  // }

  // Future<ResponseModel> doPost({
  //   required String endPoint,
  //   Map<String, String>? headers,
  //   dynamic requestData,
  //   required Function(dynamic response) onSuccess,
  //   required Function(List<Error> errors, int? statusCode) onError,
  //   Function(List<Error> errors)? onConnectionError,
  //   Rx<RequestStatus>? requestStatus,
  // }) async {
  //   print("endPoint $endPoint");
  //   print("requestData $requestData");
  //
  //   try {
  //     changeRequestStatus(requestStatus, RequestStatus.loading);
  //
  //     var response = await post(endPoint, requestData, headers: headers);
  //
  //     if (response.statusCode == 200) {
  //       var baseResponse = BaseResponse.fromJson(response.body);
  //       print(baseResponse);
  //       log("success.request:${response.body}");
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         log("success.request:${response.body}");
  //         onSuccess(response.body);
  //         changeRequestStatus(requestStatus, RequestStatus.success);
  //         return ResponseModel.withSuccess(response.body);
  //       } else {
  //         onError([Error(message: baseResponse.message ?? "Unknown error")], response.statusCode);
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError([]);
  //       }
  //     } else if (response.hasError) {
  //       if (response.status.connectionError && onConnectionError != null) {
  //         onConnectionError([Error(message: "Please Check your internet connection")]);
  //         changeRequestStatus(requestStatus, RequestStatus.failed);
  //         return ResponseModel.withError([]);
  //       }
  //
  //       var baseResponse = BaseResponse.fromJson(response.body);
  //       if (baseResponse != null && baseResponse.message != null) {
  //         onError([Error(message: baseResponse.message ?? "Unknown error")], response.statusCode);
  //       } else {
  //         onError([Error(message: "Unknown error")], response.statusCode);
  //       }
  //       changeRequestStatus(requestStatus, RequestStatus.failed);
  //       return ResponseModel.withError(baseResponse?.error ?? []);
  //     }
  //   } catch (e) {
  //     print("catch error ${e.toString()}");
  //     List<Error> errors = [Error(message: "Exceptional Error : ${e.toString()}")];
  //     onError(errors, null);
  //     changeRequestStatus(requestStatus, RequestStatus.failed);
  //     return ResponseModel.withError(errors);
  //   }
  //
  //   return ResponseModel.withError([]);
  // }

  String extractErrorMessage(dynamic body) {
    try {
      if (body == null) return "Unknown error";

      // 1. Django/DRF style
      if (body is Map && body.containsKey('detail')) {
        return body['detail'].toString();
      }

      // 2. Custom error as string
      if (body is Map && body.containsKey('error')) {
        if (body['error'] is String) {
          return body['error'];
        } else if (body['error'] is List && body['error'].isNotEmpty) {
          return body['error'][0]['message'] ?? "Unknown error";
        }
      }

      // 3. BaseResponse pattern
      if (body is Map && body.containsKey('message')) {
        return body['message'].toString();
      }

      return "Unknown error";
    } catch (e) {
      return "Unknown error";
    }
  }

  /// Returns true if the provided expiration timestamp (dd/MM/yyyy HH:mm:ss)
  /// represents a time in the past. If `expiration` is null or empty we
  /// consider there is no expiration information available and treat the token
  /// as NOT expired (returns false) so requests can proceed when the server
  /// doesn't return an expiration field.
  bool isTokenExpired(String? expiration) {
    // If there's no expiration provided, assume token is not expired.
    if (expiration == null || expiration.trim().isEmpty) return false;

    try {
      // First try ISO-8601 parsing which is the most common format returned by
      // modern backends (e.g. "2024-11-23T12:34:56Z" or without timezone).
      final iso = DateTime.tryParse(expiration);
      if (iso != null) {
        return DateTime.now().isAfter(iso);
      }

      // Fallback to the legacy format some endpoints return: dd/MM/yyyy HH:mm:ss
      try {
        final format = DateFormat("dd/MM/yyyy HH:mm:ss");
        final expirationTime = format.parse(expiration);
        return DateTime.now().isAfter(expirationTime);
      } catch (e) {
        // If that fails, be conservative and treat token as NOT expired so
        // users are not unexpectedly logged out due to format mismatch.
        log(
          "isTokenExpired: failed to parse expiration string: $expiration | $e",
        );
        return false;
      }
    } catch (e) {
      // Extremely defensive: any unexpected error -> do not treat token as expired.
      log("isTokenExpired: unexpected error while parsing expiration: $e");
      return false;
    }
  }

  /// Handle an expired token: clear stored auth data and navigate back to login.
  ///
  /// This performs a best-effort cleanup of common storage keys and then
  /// navigates to the login route using Get. We also show a brief snackbar to
  /// inform the user.
  void _handleExpiredToken() {
    try {
      pref.remove('userToken');
      pref.remove('refreshToken');
      pref.remove('expiration');
      pref.remove('isLoggedIn');
    } catch (e) {
      // ignore
    }

    // Notify user and navigate to login screen.
    Future.microtask(() {
      try {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Session expired. Please login again.')),
        );
      } catch (_) {}

      // Use Get to clear navigation stack and go to login.
      try {
        Get.offAllNamed(RouteName.login);
      } catch (_) {}
    });
  }

  Future<ResponseModel> doGet({
    required String endPoint,
    dynamic requestData,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required Function(Map<String, dynamic> response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
    Duration? cacheDuration,
  }) async {
    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      String queryString = '';
      if (queryParams != null) {
        queryString =
            '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      }
      String url = endPoint + queryString;
      print("📤 GET -> Endpoint: $url");
      print("📤 GET -> QueryParams: $queryParams");
      changeRequestStatus(requestStatus, RequestStatus.loading);

      var response = await get(url, headers: headers);
      print("response.statusCode ${response.statusCode}");
      print("response.statusText ${response.statusText}");

      if (response.isOk) {
        print("response.isOkk");
        // Normalize the response body: some endpoints return a List at top-level.
        dynamic responseBody;
        try {
          responseBody =
              response.body is Map ? response.body : json.decode(response.body);
        } catch (_) {
          responseBody = response.body;
        }

        var baseResponse = BaseResponse.fromJson(responseBody);

        if (response.statusCode == 200) {
          // Ensure we always pass a Map to callers (many callers expect a Map).
          Map<String, dynamic> payload;
          if (responseBody is Map<String, dynamic>) {
            payload = Map<String, dynamic>.from(responseBody);
          } else if (responseBody is List) {
            payload = {'data': responseBody};
          } else {
            payload = {'data': responseBody};
          }

          onSuccess(payload);
          log("Api header=> ${headers}");
          log("success.request:${responseBody}");
          changeRequestStatus(requestStatus, RequestStatus.success);
          return ResponseModel.withSuccess(payload);
        } else {
          String errorMessage =
              (responseBody is Map &&
                      (responseBody['detail'] ?? responseBody['message']) !=
                          null)
                  ? (responseBody['detail'] ?? responseBody['message'])
                      .toString()
                  : 'Unknown error';

          List<Error> errors =
              baseResponse.error ??
              [Error(message: baseResponse.message ?? "Unknown error")];
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                errors.first.message ?? '',
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimension.fontSize14,
                ),
              ),
            ),
          );
          onError(errors, response.statusCode);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: errorMessage)]);
        }
      } else if (response.hasError) {
        print("hasError ${response.bodyString}");
        print("hasError ${response.body}");
        print("hasError ${response.status}");

        if (response.status.connectionError && onConnectionError != null) {
          onConnectionError([
            Error(message: "Please check your internet connection"),
          ]);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }

        dynamic errorRaw =
            response.body['error'] ??
            response.body['detail'] ??
            response.body['message'] ??
            'Unknown error occurred';

        String errorMessage =
            errorRaw is String ? errorRaw : errorRaw.toString();
        Future.delayed(Duration(milliseconds: 200), () {
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimension.fontSize14,
                ),
              ),
            ),
          );
        });

        onError([Error(message: errorMessage)], response.statusCode);
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError([Error(message: errorMessage)]);
      }
    } catch (e) {
      print("catch error ${e.toString()}");
      List<Error> errors = [
        Error(message: "Exceptional Error: ${e.toString()}"),
      ];
      onError(errors, 0);
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }

    return ResponseModel.withError([Error(message: "Unknown error occurred")]);
  }

  Future<ResponseModel> doPost({
    required String endPoint,
    Map<String, String>? headers,
    dynamic requestData,
    Map<String, dynamic>? queryParams,
    required Function(dynamic response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
  }) async {
    print("📤 endPoint: $endPoint");
    log("📤 requestData: $requestData");

    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          List<Error> tokenErrors = [
            Error(message: "Token expired. Please login again."),
          ];
          _showErrorSnackbar(tokenErrors.first.message ?? "Token expired");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError(tokenErrors);
        }
      }
      // Handle query params
      String queryString = '';
      if (queryParams != null) {
        queryString =
            '?' +
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      }
      String url = endPoint + queryString;
      log("🌍 Full URL: $url");

      // Change request status
      changeRequestStatus(requestStatus, RequestStatus.loading);

      // Send request
      var response = await post(
        url,
        requestData,
        headers: headers ?? getHeader(),
      );
      print("🔻 Status Code: ${response.statusCode}");
      print("🔻 Raw Body: ${response.body}");

      // Check for connection errors first
      if (response.hasError) {
        if (response.status.connectionError && onConnectionError != null) {
          List<Error> connErrors = [
            Error(message: "Please check your internet connection"),
          ];
          _showErrorSnackbar(connErrors.first.message ?? "Connection error");
          onConnectionError(connErrors);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError(connErrors);
        }
      }

      // Try to parse body safely
      dynamic responseBody;
      try {
        responseBody =
            response.body is Map ? response.body : json.decode(response.body);
      } catch (_) {
        // If decode fails, try to use response.body directly. It might already
        // be decoded by GetConnect (Map/List) or be a raw string.
        responseBody = response.body;
      }

      log("📥 Response Status: ${response.statusCode}, Body: $responseBody");

      // Check success - check status code directly
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ success.response: $responseBody");

        // Normalize similar to GET: ensure callers receive a Map when possible
        Map<String, dynamic> payload;
        if (responseBody is Map<String, dynamic>) {
          payload = Map<String, dynamic>.from(responseBody);
        } else if (responseBody is List) {
          payload = {'data': responseBody};
        } else {
          payload = {'data': responseBody};
        }

        onSuccess(payload);
        changeRequestStatus(requestStatus, RequestStatus.success);
        return ResponseModel.withSuccess(payload);
      } else {
        // Handle error response
        List<Error> errors = [];
        String errorMsg = "Unknown error occurred";

        try {
          // Try to parse as BaseResponse
          BaseResponse baseResponse = BaseResponse.fromJson(responseBody);

          if (baseResponse.error != null && baseResponse.error!.isNotEmpty) {
            errors = baseResponse.error!;
            errorMsg = errors.first.message ?? "Unknown error occurred";
          } else if (baseResponse.message != null &&
              baseResponse.message!.isNotEmpty) {
            errorMsg = baseResponse.message!;
            errors = [Error(message: errorMsg)];
          } else {
            // Fallback: check responseBody directly for message
            if (responseBody is Map) {
              if (responseBody['message'] != null) {
                errorMsg = responseBody['message'].toString();
                errors = [Error(message: errorMsg)];
              } else if (responseBody['error'] != null) {
                errorMsg = responseBody['error'].toString();
                errors = [Error(message: errorMsg)];
              }
            }
          }
        } catch (parseError) {
          // If BaseResponse parsing fails, try to extract error from responseBody directly
          log("⚠️ Failed to parse BaseResponse: $parseError");
          if (responseBody is Map) {
            if (responseBody['message'] != null) {
              errorMsg = responseBody['message'].toString();
              errors = [Error(message: errorMsg)];
            } else if (responseBody['error'] != null) {
              errorMsg = responseBody['error'].toString();
              errors = [Error(message: errorMsg)];
            } else {
              errorMsg = "Error: ${response.statusCode}";
              errors = [Error(message: errorMsg)];
            }
          } else {
            errorMsg =
                "Error: ${response.statusCode} - ${responseBody.toString()}";
            errors = [Error(message: errorMsg)];
          }
        }

        // Ensure we have at least one error
        if (errors.isEmpty) {
          errors = [Error(message: errorMsg)];
        }

        log("❌ Error: $errorMsg");
        _showErrorSnackbar(errorMsg);

        onError(errors, response.statusCode);
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError(errors);
      }
    } catch (e) {
      print("❌ Exception: ${e.toString()}");
      List<Error> errors = [];
      String errorMessage;
      if (e is TimeoutException) {
        errorMessage = "The connection has timed out after 60 seconds.";
        errors.add(Error(message: errorMessage));
      } else if (e.toString().contains("SocketException") ||
          e.toString().contains("Failed host lookup")) {
        errorMessage = "Please check your internet connection";
        errors.add(Error(message: errorMessage));
      } else {
        errorMessage = "An error occurred: ${e.toString()}";
        errors.add(Error(message: errorMessage));
      }
      print("❌ Exception: ${e.toString()}");

      _showErrorSnackbar(errorMessage);

      onError(errors, null);
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }
  }

  Future<ResponseModel> doPostMultipart({
    required String endPoint,
    Map<String, String>? headers,
    required Map<String, dynamic> fields,
    List<http.MultipartFile>? files,
    required Function(dynamic response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
  }) async {
    print("endPoint $endPoint");
    print("📤 Form Fields: $fields");
    print("📤 Files: $files");

    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      changeRequestStatus(requestStatus, RequestStatus.loading);
      var url = Uri.parse(endPoint);
      var request = http.MultipartRequest('POST', url);

      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add form fields
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files
      if (files != null && files.isNotEmpty) {
        request.files.addAll(files);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("🔻 Status Code: ${response.statusCode}");
      print("🔻 Response Body: ${response.body}");

      dynamic responseBody;
      try {
        responseBody = json.decode(response.body);
      } catch (e) {
        responseBody = response.body; // fallback if not JSON
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(responseBody);
        changeRequestStatus(requestStatus, RequestStatus.success);
        return ResponseModel.withSuccess(responseBody);
      } else {
        String errorMessage = "Unknown error";
        BaseResponse baseResponse = BaseResponse.fromJson(responseBody);
        List<Error> errors = [];

        if (baseResponse.error != null && baseResponse.error!.isNotEmpty) {
          errors = baseResponse.error!;
        } else if (baseResponse.message != null &&
            baseResponse.message!.isNotEmpty) {
          errors = [Error(message: baseResponse.message!)];
        } else {
          errors = [Error(message: "Unknown error")];
        }

        Get.showSnackbar(
          GetSnackBar(
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            borderRadius: 8,
            margin: EdgeInsets.all(16.0),
            icon: Icon(Icons.check_circle, color: Colors.white),

            duration: Duration(seconds: 3),
            message: errors.first.message ?? '',
          ),
        );
        onError(errors, response.statusCode);
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError([Error(message: errorMessage)]);
      }
    } catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w500,
              fontSize: Dimension.fontSize14,
            ),
          ),
        ),
      );
      print("❌ Exception: ${e.toString()}");
      List<Error> errors = [
        Error(message: "Exceptional Error: ${e.toString()}"),
      ];
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 8,
          margin: EdgeInsets.all(16.0),
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          message: "Something went wrong",
        ),
      );
      onError(errors, null);
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }
  }

  Future<ResponseModel> doPutMultipart({
    required String endPoint,
    Map<String, String>? headers,
    required Map<String, dynamic> fields,
    List<http.MultipartFile>? files,
    List<String>? imageIds, // ✅ Add imageIds support
    required Function(dynamic response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
  }) async {
    print("🌐 API: $endPoint");
    print("📦 Fields: $fields");
    print("📁 Files: $files");
    print("🖼️ imageIds: $imageIds");

    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      changeRequestStatus(requestStatus, RequestStatus.loading);

      var url = Uri.parse(endPoint);
      var request = http.MultipartRequest('PUT', url);

      if (headers != null) {
        request.headers.addAll(headers);
      }

      // ✅ Add fields (excluding lists)
      fields.forEach((key, value) {
        if (value is! List) {
          request.fields[key] = value.toString();
          print("🧾 FIELD => $key: ${value.toString()}");
        }
      });

      for (final entry in fields.entries) {
        if (entry.key == 'images' && entry.value is List) {
          List list = entry.value as List;
          for (var item in list) {
            request.fields.addAll({'images': item.toString()});
            print("🖼️ images: $item");
          }
        } else {
          request.fields[entry.key] = entry.value.toString();
          print("🧾 FIELD => ${entry.key}: ${entry.value}");
        }
      }

      // ✅ Add files
      if (files != null && files.isNotEmpty) {
        request.files.addAll(files);
      }

      print("🔎 Final request fields: ${request.fields}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("🔻 Status Code: ${response.statusCode}");
      print("🔻 Response Body: ${response.body}");

      dynamic responseBody;
      try {
        responseBody = json.decode(response.body);
      } catch (e) {
        responseBody = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(responseBody);
        changeRequestStatus(requestStatus, RequestStatus.success);
        return ResponseModel.withSuccess(responseBody);
      } else {
        BaseResponse baseResponse = BaseResponse.fromJson(responseBody);
        List<Error> errors =
            baseResponse.error ??
            [Error(message: baseResponse.message ?? "Unknown error")];

        Get.showSnackbar(
          GetSnackBar(
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            borderRadius: 8,
            margin: EdgeInsets.all(16.0),
            icon: Icon(Icons.check_circle, color: Colors.white),

            duration: Duration(seconds: 3),
            message: errors.first.message ?? '',
          ),
        );
        onError(errors, response.statusCode);
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError(errors);
      }
    } catch (e) {
      List<Error> errors = [
        Error(message: "Exceptional Error: ${e.toString()}"),
      ];
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 8,
          margin: EdgeInsets.all(16.0),
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          message: "Something went wrong",
        ),
      );
      onError(errors, null);
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }
  }

  doPut({
    required String endPoint,
    dynamic requestData,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required Function(Map<String, dynamic> response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
  }) async {
    print("endPoint $endPoint");
    print("requestData $requestData");
    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      changeRequestStatus(requestStatus, RequestStatus.loading);
      String queryString = '';
      if (queryParams != null) {
        queryString =
            '?' +
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      }
      String url = endPoint + queryString;

      var response = await put(url, requestData, headers: headers);
      if (response.isOk) {
        dynamic responseBody;
        try {
          responseBody = json.decode(response.body);
        } catch (e) {
          responseBody = response.body;
        }
        if (response.statusCode == 200) {
          log("success.request:${response.body}");
          onSuccess(responseBody);
          changeRequestStatus(requestStatus, RequestStatus.success);
          return ResponseModel.withSuccess(response.body);
        } else {
          String errorMessage = "Unknown error";
          BaseResponse baseResponse = BaseResponse.fromJson(responseBody);
          List<Error> errors = [];

          if (baseResponse.error != null && baseResponse.error!.isNotEmpty) {
            errors = baseResponse.error!;
          } else if (baseResponse.message != null &&
              baseResponse.message!.isNotEmpty) {
            errors = [Error(message: baseResponse.message!)];
          } else {
            errors = [Error(message: "Unknown Error")];
          }
          Get.showSnackbar(
            GetSnackBar(
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              borderRadius: 8,
              margin: EdgeInsets.all(16.0),
              icon: Icon(Icons.error, color: Colors.white),
              duration: Duration(seconds: 3),
              message: errors.first.message ?? '',
            ),
          );

          onError(errors, response.statusCode);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: errorMessage)]);
        }
      } else if (response.hasError) {
        if (response.status.connectionError && onConnectionError != null) {
          final connErrors =
              response.hasError && response.body != null
                  ? [Error(message: extractErrorMessage(response.body))]
                  : [Error(message: "Please check your internet connection")];
          onConnectionError(connErrors);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }

        dynamic errorRaw =
            response.body['error'] ??
            response.body['detail'] ??
            response.body['message'] ??
            'Unknown error occurred';
        String errorMsg = errorRaw is String ? errorRaw : errorRaw.toString();
        // ...existing code...
        Future.delayed(Duration(milliseconds: 200), () {
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimension.fontSize14,
                ),
              ),
            ),
          );
        });

        // ...existing code...
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError([Error(message: errorMsg)]);
      }
    } catch (e) {
      print("catch error ${e.toString()}");
      List<Error> errors = [
        Error(message: "Exceptional Error : ${e.toString()}"),
      ];
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            errors.first.message ?? '',
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w500,
              fontSize: Dimension.fontSize14,
            ),
          ),
        ),
      );
      onError(errors, null);
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }
  }

  Future<ResponseModel> doPatch({
    required String endPoint,
    dynamic requestData,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required Function(Map<String, dynamic> response) onSuccess,
    required Function(List<Error> error, int? statusCode) onError,
    Function(List<Error> errors)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
    Duration? cacheDuration,
  }) async {
    print("requestData $requestData");

    try {
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      String queryString = '';
      if (queryParams != null) {
        queryString =
            '?' +
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      }
      String url = endPoint + queryString;
      log("endpoint $url");
      changeRequestStatus(requestStatus, RequestStatus.loading);
      var response = await patch(
        url,
        requestData,
        headers: headers ?? getHeader(),
      );
      print("response.statusCode ${response.statusCode}");
      print("response.statusText ${response.statusText}");
      if (response.isOk) {
        print("response.isOkk");
        var baseResponse = BaseResponse.fromJson(response.body);
        if (response.statusCode == 200) {
          onSuccess(response.body);
          log("success.request:${response.body}");

          changeRequestStatus(requestStatus, RequestStatus.success);
          return ResponseModel.withSuccess(response.body);
        } else {
          print("onError");
          onError([
            Error(message: baseResponse.message ?? "Unknown error"),
          ], response.statusCode); // Include statusCode
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }
      } else if (response.hasError) {
        if (response.status.connectionError && onConnectionError != null) {
          final connErrors =
              response.hasError && response.body != null
                  ? [Error(message: extractErrorMessage(response.body))]
                  : [Error(message: "Please Check your internet connection")];
          onConnectionError(connErrors);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }

        dynamic errorRaw =
            response.body['error'] ??
            response.body['detail'] ??
            response.body['message'] ??
            'Unknown error occurred';
        String errorMsg = errorRaw is String ? errorRaw : errorRaw.toString();
        // ...existing code...
        Future.delayed(Duration(milliseconds: 200), () {
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimension.fontSize14,
                ),
              ),
            ),
          );
        });

        // ...existing code...
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError([Error(message: errorMsg)]);
      }
    } catch (e) {
      print("catch error ${e.toString()}");
      List<Error> errors = [
        Error(message: "Exceptional Error : ${e.toString()}"),
      ];
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 8,
          margin: EdgeInsets.all(16.0),
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          message: "Something went wrong",
        ),
      );
      onError(errors, 0); // Include null as statusCode
      changeRequestStatus(requestStatus, RequestStatus.failed);
      return ResponseModel.withError(errors);
    }
    return ResponseModel.withError([]);
  }

  doDelete({
    required String endPoint,
    dynamic requestData,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required Function(Map<String, dynamic> response) onSuccess,
    required Function(List<Error> errors, int? statusCode) onError,
    Function(List<Error> error)? onConnectionError,
    Rx<RequestStatus>? requestStatus,
  }) async {
    try {
      // Token refresh handled by _attemptRefreshToken helper instead of a missing controller
      final token = pref.read("userToken");
      final refreshToken = pref.read("refreshToken");
      final expiration = pref.read("expiration");

      print("🪙 Token => $token");
      print("🔁 RefreshToken => $refreshToken");
      print("⏰ Expiration => $expiration");

      if (token != null) {
        if (isTokenExpired(expiration)) {
          print("🔄 Token expired. Logging out...");
          _handleExpiredToken();
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([Error(message: "Token expired")]);
        }
      }
      String queryString = '';
      if (queryParams != null) {
        queryString =
            '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      }
      String url = endPoint + queryString;

      changeRequestStatus(requestStatus, RequestStatus.loading);
      var response = await request(
        url,
        'DELETE',
        body: requestData,
        headers: headers,
      );
      print("requestData DELETE $requestData");
      print("requestData DELETE ${response.request?.url}");
      print("response DELETE ${response.body.toString()}");

      if (response.isOk) {
        var baseResponse = BaseResponse.fromJson(response.body);

        if (response.statusCode == 200) {
          log("success.request:${response.body}");
          onSuccess(response.body);
          changeRequestStatus(requestStatus, RequestStatus.success);
          return ResponseModel.withSuccess(response.body);
        } else {
          onError([
            Error(message: baseResponse.message ?? "Unknown error"),
          ], response.statusCode);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }
      } else if (response.hasError) {
        if (response.status.connectionError && onConnectionError != null) {
          final connErrors =
              response.hasError && response.body != null
                  ? [Error(message: extractErrorMessage(response.body))]
                  : [Error(message: "Please Check your internet connection")];
          onConnectionError(connErrors);
          changeRequestStatus(requestStatus, RequestStatus.failed);
          return ResponseModel.withError([]);
        }

        dynamic errorRaw =
            response.body['error'] ??
            response.body['detail'] ??
            response.body['message'] ??
            'Unknown error occurred';
        String errorMsg = errorRaw is String ? errorRaw : errorRaw.toString();
        // ...existing code...
        Future.delayed(Duration(milliseconds: 200), () {
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimension.fontSize14,
                ),
              ),
            ),
          );
        });

        // ...existing code...
        changeRequestStatus(requestStatus, RequestStatus.failed);
        return ResponseModel.withError([Error(message: errorMsg)]);
      }
    } catch (e) {
      print("error ${e.toString()}");
      List<Error> errors = [];
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 8,
          margin: EdgeInsets.all(16.0),
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          message: "Something went wrong",
        ),
      );
      errors.add(Error(message: "Exceptional Error : ${e.toString()}"));
      onError(errors, null);
      changeRequestStatus(requestStatus, RequestStatus.failed);
    }
  }

  List<Error> getError(Response<dynamic> response) {
    List<Error> error = [];
    if (response.status.connectionError) {
      error.add(Error(message: "Please Check your internet connection"));
    } else if (response.status.isForbidden) {
      error.add(Error(message: "Forbidden"));
    } else if (response.status.isNotFound) {
      error.add(Error(message: "NotFound"));
    } else if (response.status.isServerError) {
      error.add(Error(message: "ServerError"));
    } else if (response.status.isUnauthorized) {
      error.add(Error(message: "please login to your account."));
      // AppPreferences.clearDataAndLogout();
      //
      // /// clears other db tables
      // EventsDatabaseHelper.db.clearEventsTable();
      // FeedsDatabaseHelper.db.clearFeedsTable();
      // Get.offAllNamed(RouteName.login);
    } else {
      error.add(Error(message: response.body?["message"] ?? "Unknown Error"));
    }
    return error;
  }

  void changeRequestStatus(
    Rx<RequestStatus>? requestStatus,
    RequestStatus toStatus,
  ) {
    if (requestStatus != null) {
      requestStatus.value = toStatus;
    }
  }
}

enum RequestStatus { loading, success, failed, none }

void changeRequestStatus(
  Rx<RequestStatus>? requestStatus,
  RequestStatus status,
) {
  if (requestStatus != null) {
    requestStatus.value = status;
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
        // LoadingAnimationWidget.progressiveDots(size: 50, color: AppColors.whiteColor(context)
        //     // radius: 15,
        //     // animating: true,
        //     ),
      );
    },
  );
}
