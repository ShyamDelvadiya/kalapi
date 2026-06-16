import 'dart:async';
import 'dart:developer';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/home/home_view.dart';
import 'package:kalapi/view/pages/product/model/checkout_api_res.dart';
import 'package:kalapi/view/pages/product/model/product_category_res.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';

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
  final RxMap<int, double> cartQuantities = <int, double>{}.obs;
  final RxMap<int, bool> cartSelected = <int, bool>{}.obs;

  // Reactive calculation properties
  final RxDouble subtotal = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble apiTotal = 0.0.obs;
  final RxBool isCalculatingTotal = false.obs;
  final RxBool isPlacingOrder = false.obs;

  // Debounce timer for API calls
  // Note: We no longer auto-call the checkout API from product screen.
  // Debounced API calls were removed so totals are calculated only at checkout.

  /// Set quantity for a product in the shared cart state. If qty <= 0 the product is removed.
  void setCartQuantity(int productId, double qty) {
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

    // Trigger calculation update (local only). API total will be fetched at checkout.
    calculateLocalSubtotal();
  }

  /// Toggle whether a product is selected for checkout
  void toggleCartSelection(int productId) {
    final cur = cartSelected[productId] ?? false;
    cartSelected[productId] = !cur;
    if (!(cartSelected[productId] ?? false)) {
      cartQuantities.remove(productId);
    } else {
      cartQuantities[productId] = cartQuantities[productId] ?? 1.0;
    }
    cartSelected.refresh();
    cartQuantities.refresh();

    // Trigger calculation update (local only). API total will be fetched at checkout.
    calculateLocalSubtotal();
  }

  void clearCartSelection() {
    cartSelected.clear();
    cartQuantities.clear();
    cartSelected.refresh();
    cartQuantities.refresh();

    // Reset calculations
    subtotal.value = 0.0;
    apiTotal.value = 0.0;
    discount.value = 0.0;
  }

  /// Build order items payload from current selection
  List<Map<String, dynamic>> getSelectedOrderItems() {
    final List<Map<String, dynamic>> out = [];
    for (final entry in cartSelected.entries) {
      if (entry.value == true) {
        final pid = entry.key;
        final qty = cartQuantities[pid] ?? 1.0;
        // Attach chosen unit price for API (internal vs base)
        final product = items.firstWhereOrNull((p) => p.productId == pid);
        double unitPrice = 0.0;
        if (product != null) {
          num? baseNum;
          num? internalNum;
          // Safely coerce dynamic values to num
          if (product.basePrice is num) {
            baseNum = product.basePrice as num?;
          } else if (product.basePrice != null) {
            baseNum = num.tryParse(product.basePrice.toString());
          }

          if (product.internalPrice is num) {
            internalNum = product.internalPrice as num?;
          } else if (product.internalPrice != null) {
            internalNum = num.tryParse(product.internalPrice.toString());
          }

          unitPrice =
              isPBBranch.value
                  ? (product.pbPrice ?? 0).toDouble()
                  : isInternalBranch.value
                  ? ((internalNum ?? baseNum) ?? 0).toDouble()
                  : (baseNum ?? 0).toDouble();
        }

        out.add({
          'productId': pid,
          'quantity': qty,
          'deliveredQuantity': null,
          'unitPrice': unitPrice,
        });
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

  /// Load the next page of products if possible
  void loadMoreProducts() {
    if (!isLoading.value && !isLoadingMore.value && hasMore.value) {
      final nextPage = currentPage.value + 1;
      productApiCall(
        page: nextPage,
        size: pageSize.value,
        categoryId: selectedCategoryId.value,
        search: searchQuery.value,
      );
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

  Future<bool> checkOutApiCall({
    var body,
    Future<void> Function()? onSuccess,
  }) async {
    final completer = Completer<bool>();

    try {
      await apiService.doPost(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.checkOut,
        requestData: body,
        onSuccess: (responseData) async {
          try {
            requestStatus.value = RequestStatus.success;
            checkOutResponses.value = CheckOutApiRes.fromJson((responseData));
            if (onSuccess != null) {
              await onSuccess();
            }
            if (!completer.isCompleted) completer.complete(true);
          } catch (e) {
            log("onSuccess callback error: $e");
            if (!completer.isCompleted) completer.complete(false);
          }
        },
        onError: (errors, statusCode) {
          log(
            'Order placement failed: ${errors.map((e) => e.message).join(', ')}',
          );
          if (!completer.isCompleted) completer.complete(false);
        },
        onConnectionError: (errors) {
          log(
            'Connection error while placing order: ${errors.map((e) => e.message).join(', ')}',
          );
          if (!completer.isCompleted) completer.complete(false);
        },
      );
    } catch (e) {
      log("Product API call failed: $e");
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => false,
    );
  }

  /// Calculate local subtotal from cart items
  void calculateLocalSubtotal() {
    double total = 0.0;

    for (final entry in cartSelected.entries) {
      if (entry.value == true) {
        final productId = entry.key;
        final quantity = cartQuantities[productId] ?? 0.0;

        // Find product in items list
        final product = items.firstWhereOrNull((p) => p.productId == productId);
        if (product != null) {
          // Use pbPrice for PB branches, internalPrice for internal branches, basePrice otherwise
          final price =
              isPBBranch.value
                  ? (product.pbPrice ?? 0.0)
                  : isInternalBranch.value
                  ? (product.internalPrice?.toDouble() ??
                      product.basePrice?.toDouble() ??
                      0.0)
                  : (product.basePrice?.toDouble() ?? 0.0);
          total += price * quantity;
        }
      }
    }

    subtotal.value = total;
  }

  /// Get cart items with full product details
  List<Map<String, dynamic>> getCartItemsWithDetails() {
    final List<Map<String, dynamic>> cartItems = [];

    for (final entry in cartSelected.entries) {
      if (entry.value == true) {
        final productId = entry.key;
        final quantity = cartQuantities[productId] ?? 0.0;

        // Find product in items list
        final product = items.firstWhereOrNull((p) => p.productId == productId);
        if (product != null) {
          // Use pbPrice for PB branches, internalPrice for internal branches, basePrice otherwise
          final price =
              isPBBranch.value
                  ? product.pbPrice
                  : isInternalBranch.value
                  ? (product.internalPrice ?? product.basePrice)
                  : product.basePrice;
          cartItems.add({
            'productId': productId,
            'productName': product.productName,
            'weight': product.weight,
            'price': price,
            'quantity': quantity,
            'categoryId': product.categoryId,
          });
        }
      }
    }

    return cartItems;
  }

  /// Fetch total from API
  Future<void> fetchTotalFromApi() async {
    if (cartSelected.values.every((v) => v == false)) {
      apiTotal.value = 0.0;
      return;
    }

    isCalculatingTotal.value = true;
    isPlacingOrder.value = true;

    try {
      final branchId = pref.read("branchId") ?? 0;

      final body = {
        "orderId": null,
        "branchId": branchId,
        "orderDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "orderDetails": getSelectedOrderItems(),
      };

      await checkOutApiCall(
        body: body,
        onSuccess: () async {
          apiTotal.value =
              checkOutResponses.value.totalAmount?.toDouble() ?? 0.0;
          discount.value = checkOutResponses.value.discount?.toDouble() ?? 0.0;

          // Show snackbar BEFORE navigation to ensure it's queued properly
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: const Text('Order placed successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 800));

          clearCartSelection();

          await Get.offAll(() => HomeView());
        },
      );
    } catch (e) {
      log('Error fetching total from API: $e');
    } finally {
      isCalculatingTotal.value = false;
      isPlacingOrder.value = false;
    }
  }

  @override
  void onClose() {
    // No timers to cancel; totals are fetched at checkout.
    super.onClose();
  }
}
