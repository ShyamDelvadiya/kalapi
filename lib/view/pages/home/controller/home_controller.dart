import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/home/model/branch_details_api_res.dart';
import 'package:kalapi/view/pages/home/model/hone_res.dart';

RxBool isInternalBranch = false.obs;

class HomeController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<DashboardApiRes> dashboardResponseModel = DashboardApiRes().obs;
  final Rx<BranchDetailsApiRes> branchDetailsResponseModel =
      BranchDetailsApiRes().obs;

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  Future<void> homeApiCall({String? branchId, Function()? onSuccess}) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    try {
      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: '${ApiEndPoint.home}?isBranch=true&branchId=$branchId',
        onSuccess: (responseData) async {
          // notify caller
          requestStatus.value = RequestStatus.success;
          dashboardResponseModel.value = DashboardApiRes.fromJson(responseData);
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

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  branchDetailsApiCall({String? branchId, Function()? onSuccess}) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    try {
      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: '${ApiEndPoint.branchDetails}?id=$branchId',
        onSuccess: (responseData) async {
          // notify caller
          requestStatus.value = RequestStatus.success;
          branchDetailsResponseModel.value = BranchDetailsApiRes.fromJson(
            responseData,
          );
          log('---- branch details -- ${branchDetailsResponseModel.value}');
          homeApiCall(branchId: branchId);
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
