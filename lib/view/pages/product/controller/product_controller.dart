import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/product/model/checkout_api_res.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';
import 'package:kalapi/view/pages/product/model/product_category_res.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<ProductApiRes> productResponseModel = ProductApiRes().obs;
  // Flattened list used by the UI for paging
  final RxList<ProductList> items = <ProductList>[].obs;
  final RxInt currentPage = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxList<ProductCategoryList> categories = <ProductCategoryList>[].obs;
  final Rx<CheckOutApiRes> checkOutResponses = CheckOutApiRes().obs;
  final RxnInt selectedCategoryId = RxnInt();
  final RxString searchQuery = ''.obs;
  // Cart / selection shared state so different screens can read/write quantities
  final RxMap<int, int> cartQuantities = <int, int>{}.obs;
  final RxMap<int, bool> cartSelected = <int, bool>{}.obs;

  /// Set quantity for a product in the shared cart state. If qty <= 0 the product is removed.
  void setCartQuantity(int productId, int qty) {
    if (qty <= 0) {
      cartQuantities.remove(productId);
      cartSelected.remove(productId);
    } else {
      cartQuantities[productId] = qty;
      // keep selected flag true if quantity is set
      cartSelected[productId] = true;
    }
    cartQuantities.refresh();
    cartSelected.refresh();
  }

  /// Toggle whether a product is selected for checkout
  void toggleCartSelection(int productId) {
    final cur = cartSelected[productId] ?? false;
    cartSelected[productId] = !cur;
    if (!(cartSelected[productId] ?? false)) {
      cartQuantities.remove(productId);
    } else {
      cartQuantities[productId] = cartQuantities[productId] ?? 1;
    }
    cartSelected.refresh();
    cartQuantities.refresh();
  }

  void clearCartSelection() {
    cartSelected.clear();
    cartQuantities.clear();
    cartSelected.refresh();
    cartQuantities.refresh();
  }

  /// Build order items payload from current selection
  List<Map<String, dynamic>> getSelectedOrderItems() {
    final List<Map<String, dynamic>> out = [];
    for (final entry in cartSelected.entries) {
      if (entry.value == true) {
        final pid = entry.key;
        final qty = cartQuantities[pid] ?? 1;
        out.add({'productId': pid, 'quantity': qty});
      }
    }
    return out;
  }

  /// Call login API. If [onSuccess] is provided it will be invoked after a successful login.
  /// Fetch product list. Supports pagination via [page] and [size].
  Future<void> productApiCall({
    int page = 1,
    int size = 10,
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortDirection,
    Function()? onSuccess,
  }) async {
    // If requesting a page >1, set loadingMore flag; otherwise primary loading
    if (page > 1) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      hasMore.value = true; // reset
    }

    try {
      final Map<String, dynamic> requestBody = {
        'search': search ?? '',
        'categoryId': categoryId ?? 0,
        'sortBy': sortBy ?? '',
        'sortDirection': sortDirection ?? '',
        'pageNumber': page,
        'pageSize': size,
      };

      await apiService.doPost(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.productList,
        requestData: requestBody,
        onSuccess: (responseData) async {
          requestStatus.value = RequestStatus.success;

          // Parse response into model
          final resp = ProductApiRes.fromJson(
            Map<String, dynamic>.from(responseData),
          );
          final List<ProductList> fetched = resp.data ?? [];

          if (page == 1) {
            items.clear();
            items.addAll(fetched);
          } else {
            items.addAll(fetched);
          }

          // update pagination trackers
          currentPage.value = page;
          pageSize.value = size;
          // If fewer items returned than requested pageSize, no more pages
          hasMore.value = fetched.length >= size;

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
      log("Product API call failed: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
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
    isLoading.value = true;
    selectedCategoryId.value = categoryId;
    productApiCall(categoryId: categoryId, search: searchQuery.value);
  }

  void setSearch(String value) {
    searchQuery.value = value;
    // Debounce could be added; for now call immediately.
    productApiCall(categoryId: selectedCategoryId.value, search: value);
  }

  Future<void> checkOutApiCall({var body, Function()? onSuccess}) async {
    try {
      await apiService.doPost(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.checkOut,
        requestData: body,
        onSuccess: (responseData) async {
          requestStatus.value = RequestStatus.success;
          checkOutResponses.value = CheckOutApiRes.fromJson((responseData));
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
      log("Product API call failed: $e");
    } finally {}
  }
}
