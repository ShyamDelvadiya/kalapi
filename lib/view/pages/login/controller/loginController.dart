import 'dart:developer';
// import 'dart:ui';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/login/model/login_res_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<LoginResModel> loginResponseModel = LoginResModel().obs;
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
          try {
            log("message $responseData");
            requestStatus.value = RequestStatus.success;
            loginResponseModel.value = LoginResModel.fromJson(responseData);
            // Handle login response data
            String userToken = loginResponseModel.value.data?.token ?? '';
            String expiryToken =
                loginResponseModel.value.data?.tokenExpirationTime ?? '';
            String? savedEmail = email ?? '';
            String? savedPassword = password ?? '';
            int? branchNum = loginResponseModel.value.data?.branchID ?? 0;

            final bool isInternalBranch =
                loginResponseModel.value.data?.isInternalBranch ?? false;
            // mark logged in
            // Persist token and expiration under the keys other services expect
            // Save both `expiryToken` (legacy) and `expiration` (used by api_service)
            if (userToken.isNotEmpty) {
              log(" Login Token: $userToken ");
              pref.write("isLoggedIn", true);
              pref.write("userToken", userToken);
              // write legacy key as well
              pref.write("expiryToken", expiryToken);
              // api_service expects `expiration` (ISO string). Save it too.
              pref.write("expiration", expiryToken);
              pref.write("savedEmail", savedEmail);
              pref.write("savedPassword", savedPassword);
              pref.write("isInternalBranch", isInternalBranch);
              pref.write("branchId", branchNum.toString());
            }
          } catch (e) {
            log("Failed to write isLoggedIn: $e");
          }

          // notify caller
          try {
            if (onSuccess != null) onSuccess();
          } catch (e) {
            log("onSuccess callback error: $e");
          }
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
