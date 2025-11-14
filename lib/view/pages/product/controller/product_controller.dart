import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<ProductApiRes> productResponseModel = ProductApiRes().obs;
  final RxList<ProductApiRes> productResponseList = <ProductApiRes>[].obs;

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  Future<void> productApiCall({String? branchId, Function()? onSuccess}) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    try {
      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.productList,
        onSuccess: (responseData) async {
          // notify caller
          requestStatus.value = RequestStatus.success;
          productResponseModel.value = ProductApiRes.fromJson(responseData);
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
