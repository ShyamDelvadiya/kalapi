import 'dart:developer';
// import 'dart:ui';

import 'package:get/get.dart';
import 'package:my_pg/api_service/api_service.dart';
import 'package:my_pg/main.dart';
import 'package:my_pg/utils/app_constrants.dart';
import 'package:my_pg/view/pages/login/model/login_res_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;

  void login(String username, String password) async {
    isLoading.value = true;
    // Simulate a login API call
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
    // Handle login success or failure
  }

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  Future<void> loginApiCall({
    String? email,
    String? password,
    Function()? onSuccess,
  }) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    try {
      await apiService.doPost(
        requestStatus: requestStatus,
        requestData: {'email': email, 'password': password},
        endPoint: ApiEndPoint.login,
        onSuccess: (responseData) async {
          log("message $responseData");
          requestStatus.value = RequestStatus.success;
          LoginResModel loginRes = LoginResModel.fromJson(
            responseData as Map<String, dynamic>,
          );

          // Handle login response data
          String userToken = loginRes.data?.token ?? '';
          String expiryToken = loginRes.data?.tokenExpirationTime ?? '';
          final bool isInternalBranch =
              loginRes.data?.isInternalBranch ?? false;
          // mark logged in
          try {
            pref.write("isLoggedIn", true);
            pref.write("userToken", userToken);
            pref.write("expiryToken", expiryToken);
            pref.write("isInternalBranch", isInternalBranch);
          } catch (e) {
            log("Failed to write isLoggedIn: $e");
          }

          // notify caller
          try {
            if (onSuccess != null) onSuccess();
          } catch (e) {
            log("onSuccess callback error: $e");
          }

          // print("UserToken => $userToken");
          // print("userId => $userId");
        },
        onError: (errors, statusCode) {},
        onConnectionError: (errors) {},
      );
    } catch (e) {
      log("Login API call failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
