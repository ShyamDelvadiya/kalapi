import 'dart:developer';

import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/order/model/order_details_api_res.dart';
import 'package:kalapi/view/pages/order/model/order_list_api_res.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingDetails = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final RxList<OrderData> orders = <OrderData>[].obs;

  // Order details
  final Rx<OrderDetailsData?> orderDetails = Rx<OrderDetailsData?>(null);

  // Date range filters
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Branch ID (can be set from user's branch or selected branch)
  final RxInt branchId = 0.obs;

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
    Function()? onSuccess,
  }) async {
    isLoading.value = true;

    try {
      // Use provided dates or fall back to stored dates
      final startDateStr = _formatDate(start ?? startDate.value);
      final endDateStr = _formatDate(end ?? endDate.value);
      final branchIdValue = branch ?? branchId.value;

      final Map<String, dynamic> requestBody = {
        'startDate': startDateStr,
        'endDate': endDateStr,
        'branchId': branchIdValue,
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

          orders.clear();
          if (resp.data != null) {
            orders.addAll(resp.data!);
          }

          log('✅ Fetched ${orders.length} orders');

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
    }
  }

  /// Set date range and refresh orders
  void setDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    getOrderListApiCall();
  }

  /// Set branch ID and refresh orders
  void setBranchId(int id) {
    branchId.value = id;
    getOrderListApiCall();
  }

  /// Refresh orders with current filters
  Future<void> refreshOrders() async {
    await getOrderListApiCall();
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
    orderDetails.value = null;

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

          orderDetails.value = resp.data;

          log('✅ Fetched order details: ${resp.data?.orderNumber}');

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
