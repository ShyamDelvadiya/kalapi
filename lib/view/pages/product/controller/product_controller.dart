import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';
import 'package:kalapi/view/pages/product/model/product_category_res.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<ProductApiRes> productResponseModel = ProductApiRes().obs;
  final RxList<ProductApiRes> productResponseList = <ProductApiRes>[].obs;
  final RxList<ProductCategoryList> categories = <ProductCategoryList>[].obs;
  final RxnInt selectedCategoryId = RxnInt();
  final RxString searchQuery = ''.obs;

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  Future<void> productApiCall({
    String? branchId,
    int? categoryId,
    String? search,
    Function()? onSuccess,
  }) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    try {
      final Map<String, dynamic> queryParams = {};
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (search != null && search.trim().isNotEmpty)
        queryParams['search'] = search.trim();

      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.productList,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
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

  /// Fetch product categories used by the category filter dropdown.
  Future<void> fetchCategories() async {
    try {
      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.productCategoryList,
        onSuccess: (responseData) {
          final res = ProductCategoryApiRes.fromJson(
            Map<String, dynamic>.from(responseData),
          );
          categories.clear();
          if (res.data != null) categories.addAll(res.data!);
        },
        onError: (errors, statusCode) {
          log(
            'Failed to load categories: ${errors.map((e) => e.message).join(', ')}',
          );
        },
        onConnectionError: (errors) {
          log('Connection error while fetching categories');
        },
      );
    } catch (e) {
      log('Exception fetching categories: $e');
    }
  }

  void setCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    productApiCall(categoryId: categoryId, search: searchQuery.value);
  }

  void setSearch(String value) {
    searchQuery.value = value;
    // Debounce could be added; for now call immediately.
    productApiCall(categoryId: selectedCategoryId.value, search: value);
  }
}
