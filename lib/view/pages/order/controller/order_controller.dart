import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/order/model/order_details_api_res.dart';
import 'package:kalapi/view/pages/order/model/order_list_api_res.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoadingDetails = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final RxList<OrderData> orders = <OrderData>[].obs;

  // Order details
  final RxList<OrderDetailsData> orderDetails = <OrderDetailsData>[].obs;

  // Date range filters
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Branch ID (can be set from user's branch or selected branch)
  final RxInt branchId = 0.obs;

  // Pagination and filtering
  final RxInt pageNumber = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxBool hasMore = true.obs;
  final RxInt orderStatusId = 0.obs; // 0 for all, or specific ID

  // Order Statuses from DB
  final List<Map<String, dynamic>> orderStatuses = [
    {'id': 0, 'name': 'All'},
    {'id': 1, 'name': 'In Progress'},
    {'id': 2, 'name': 'Ready To Deliver'},
    {'id': 3, 'name': 'Delivered'},
    {'id': 4, 'name': 'Payment Pending'},
    {'id': 5, 'name': 'Complete'},
    {'id': 6, 'name': 'Cancelled'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default date range to current month
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
  }

  /// Fetch order list from API
  Future<void> getOrderListApiCall({
    DateTime? start,
    DateTime? end,
    int? branch,
    int? statusId,
    int page = 1,
    Function()? onSuccess,
  }) async {
    if (page == 1) {
      isLoading.value = true;
      hasMore.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      // Use provided dates or fall back to stored dates
      final startDateStr = _formatDate(start ?? startDate.value);
      final endDateStr = _formatDate(end ?? endDate.value);
      final branchIdValue = branch ?? branchId.value;
      final statusIdValue = statusId ?? orderStatusId.value;

      final Map<String, dynamic> requestBody = {
        'startDate': startDateStr,
        'endDate': endDateStr,
        'branchId': branchIdValue,
        'OrderStatusId': statusIdValue,
        'pageNumber': page,
        'pageSize': pageSize.value,
      };

      log('📤 Fetching orders with: $requestBody');

      await apiService.doPost(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.getOrderList,
        requestData: requestBody,
        onSuccess: (responseData) async {
          requestStatus.value = RequestStatus.success;

          // Parse response into model
          final resp = OrderListApiRes.fromJson(
            Map<String, dynamic>.from(responseData),
          );

          final List<OrderData> newOrders = resp.data ?? [];

          if (page == 1) {
            orders.clear();
            orders.addAll(newOrders);
          } else {
            orders.addAll(newOrders);
          }

          pageNumber.value = page;

          // Check if we have more data
          if (newOrders.length < pageSize.value) {
            hasMore.value = false;
          } else {
            hasMore.value = true;
          }

          log('✅ Fetched ${newOrders.length} orders (Total: ${orders.length})');

          try {
            if (onSuccess != null) onSuccess();
          } catch (e) {
            log("onSuccess callback error: $e");
          }
        },
        onError: (errors, statusCode) {
          log(
            '❌ Error fetching orders: ${errors.map((e) => e.message).join(', ')}',
          );
        },
        onConnectionError: (errors) {
          log('❌ Connection error while fetching orders');
        },
      );
    } catch (e) {
      log("❌ Order API call failed: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Set date range and refresh orders
  void setDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    pageNumber.value = 1;
    getOrderListApiCall(page: 1);
  }

  /// Set branch ID and refresh orders
  void setBranchId(int id) {
    branchId.value = id;
    pageNumber.value = 1;
    getOrderListApiCall(page: 1);
  }

  /// Set order status and refresh orders
  void setOrderStatus(int id) {
    orderStatusId.value = id;
    pageNumber.value = 1;
    isLoading.value = true;
    getOrderListApiCall(page: 1);
  }

  /// Refresh orders with current filters
  Future<void> refreshOrders() async {
    pageNumber.value = 1;
    await getOrderListApiCall(page: 1);
  }

  /// Load next page of orders
  Future<void> loadMoreOrders() async {
    if (!isLoading.value && !isLoadingMore.value && hasMore.value) {
      await getOrderListApiCall(page: pageNumber.value + 1);
    }
  }

  /// Format DateTime to yyyy-MM-dd string
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Fetch order details by ID
  Future<void> getOrderDetailsApiCall({
    required int orderId,
    Function()? onSuccess,
  }) async {
    isLoadingDetails.value = true;
    orderDetails.clear();

    try {
      log('📤 Fetching order details for orderId: $orderId');

      await apiService.doGet(
        headers: apiService.getHeader(),
        requestStatus: requestStatus,
        endPoint: ApiEndPoint.getOrderDetails,
        queryParams: {'orderId': orderId.toString()},
        onSuccess: (responseData) async {
          requestStatus.value = RequestStatus.success;

          // Parse response into model
          final resp = OrderDetailsApiRes.fromJson(
            Map<String, dynamic>.from(responseData),
          );

          if (resp.data != null) {
            orderDetails.addAll(resp.data!);
          }

          log('✅ Fetched ${orderDetails.length} order items');

          try {
            if (onSuccess != null) onSuccess();
          } catch (e) {
            log("onSuccess callback error: $e");
          }
        },
        onError: (errors, statusCode) {
          log(
            '❌ Error fetching order details: ${errors.map((e) => e.message).join(', ')}',
          );
        },
        onConnectionError: (errors) {
          log('❌ Connection error while fetching order details');
        },
      );
    } catch (e) {
      log("❌ Order details API call failed: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  /// Parse date string to DateTime
  DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      log('Error parsing date: $dateStr');
      return null;
    }
  }
}
