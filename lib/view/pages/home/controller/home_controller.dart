import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/view/pages/home/model/branch_details_api_res.dart';
import 'package:kalapi/view/pages/home/model/graph_api_res.dart';
import 'package:kalapi/view/pages/home/model/hone_res.dart';

RxBool isInternalBranch = false.obs;

class HomeController extends GetxController {
  var isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;
  final Rx<DashboardApiRes> dashboardResponseModel = DashboardApiRes().obs;
  final Rx<BranchDetailsApiRes> branchDetailsResponseModel =
      BranchDetailsApiRes().obs;
  // Revenue chart data (thousands). Replace with API-fed values when available.
  final RxList<double> revenueCurrent =
      <double>[
        152,
        138.5,
        169.8,
        185.3,
        201.2,
        194.7,
        222.4,
        236.9,
        258.1,
        311.5,
        289.3,
        305.8,
      ].obs;
  final RxList<double> revenuePrevious =
      <double>[
        126,
        117.4,
        141.6,
        152.3,
        168.9,
        162.8,
        180.2,
        195.7,
        208.3,
        233.4,
        221.6,
        239.5,
      ].obs;
  final RxString currentLabel = '2025'.obs;
  final RxString previousLabel = '2024'.obs;
  final Rx<GraphApiRes> graphApiRes = GraphApiRes().obs;
  final RxBool isLoadingChart = false.obs;

  // Date filter variables
  DateTime? startDate;
  DateTime? endDate;

  // Getters for date formatting
  String getFormattedStartDate() {
    if (startDate == null) return '';
    return DateFormat('yyyy-MM-dd').format(startDate!);
  }

  String getFormattedEndDate() {
    if (endDate == null) return '';
    return DateFormat('yyyy-MM-dd').format(endDate!);
  }

  @override
  void onInit() {
    super.onInit();
  }

  // Future<void> loadRevenueFromAssets() async {
  //   try {
  //     final jsonStr = await rootBundle.loadString(
  //       'assets/chart/revenue_chart_example.json',
  //     );
  //     final Map<String, dynamic> json = jsonDecode(jsonStr);
  //     final chart = json['chart'] as Map<String, dynamic>?;
  //     if (chart == null) return;

  //     final List<dynamic> series = chart['series'] as List<dynamic>? ?? [];
  //     if (series.length < 2) return;

  //     final Map<String, dynamic> s0 = series[0] as Map<String, dynamic>;
  //     final Map<String, dynamic> s1 = series[1] as Map<String, dynamic>;
  //     currentLabel.value = (s0['name'] ?? 'Current').toString();
  //     previousLabel.value = (s1['name'] ?? 'Previous').toString();

  //     List<double> toThousands(List<dynamic> points) {
  //       return points
  //           .map(
  //             (e) =>
  //                 (e is Map && e['value'] != null)
  //                     ? (e['value'] as num).toDouble() / 1000.0
  //                     : 0.0,
  //           )
  //           .toList();
  //     }

  //     final List<dynamic> d0 = (s0['data'] as List<dynamic>? ?? []);
  //     final List<dynamic> d1 = (s1['data'] as List<dynamic>? ?? []);
  //     revenueCurrent.assignAll(toThousands(d0));
  //     revenuePrevious.assignAll(toThousands(d1));
  //   } catch (e) {
  //     log('Failed to load revenue chart from assets: $e');
  //   }
  // }

  /// Call GetOrderChartData API to fetch chart data
  Future<void> getOrderChartData({
    required int branchId,
    required String startDate,
    required String endDate,
    Function()? onSuccess,
    bool showLoader = true,
  }) async {
    if (showLoader) {
      isLoadingChart.value = true;
    }
    try {
      await apiService.doPost(
        requestStatus: requestStatus,
        requestData: {
          'BranchId': branchId,
          'StartDate': startDate,
          'EndDate': endDate,
        },
        endPoint: ApiEndPoint.getOrderChartData,
        onSuccess: (responseData) async {
          try {
            log("Chart API Response: $responseData");
            requestStatus.value = RequestStatus.success;
            graphApiRes.value = GraphApiRes.fromJson(responseData);

            // Update chart data from API response
            if (graphApiRes.value.chart != null &&
                graphApiRes.value.chart!.series != null &&
                graphApiRes.value.chart!.series!.isNotEmpty) {
              final series = graphApiRes.value.chart!.series!;

              log("Processing ${series.length} series from API");

              // Update labels
              if (series.length > 0) {
                currentLabel.value = series[0].name ?? 'Current';
                log("Current label: ${currentLabel.value}");
              }
              if (series.length > 1) {
                previousLabel.value = series[1].name ?? 'Previous';
                log("Previous label: ${previousLabel.value}");
              } else {
                // If only one series, clear previous label or set to empty
                previousLabel.value = '';
              }

              // Update revenue data - use actual values without converting to thousands
              // Extract values from data array
              if (series.length > 0 &&
                  series[0].data != null &&
                  series[0].data!.isNotEmpty) {
                // Sort data by date to ensure chronological order
                final sortedData = List<ChartPoint>.from(series[0].data!);
                sortedData.sort((a, b) {
                  if (a.date == null || b.date == null) return 0;
                  return a.date!.compareTo(b.date!);
                });

                // Use actual values without dividing by 1000
                final currentData =
                    sortedData.map((d) => d.value ?? 0.0).toList();
                revenueCurrent.assignAll(currentData);
                log(
                  "Current data points: ${currentData.length}, values: $currentData",
                );
              } else {
                // Clear current data if empty
                revenueCurrent.clear();
                log("No current data available");
              }

              // Handle second series (previous year) if available
              if (series.length > 1 &&
                  series[1].data != null &&
                  series[1].data!.isNotEmpty) {
                // Sort data by date to ensure chronological order
                final sortedData = List<ChartPoint>.from(series[1].data!);
                sortedData.sort((a, b) {
                  if (a.date == null || b.date == null) return 0;
                  return a.date!.compareTo(b.date!);
                });

                // Use actual values without dividing by 1000
                final previousData =
                    sortedData.map((d) => d.value ?? 0.0).toList();
                revenuePrevious.assignAll(previousData);
                log(
                  "Previous data points: ${previousData.length}, values: $previousData",
                );
              } else {
                // Clear previous data if not available (single series case)
                revenuePrevious.clear();
                log(
                  "No previous data available - displaying single series only",
                );
              }
            } else {
              // Clear all data if chart is null or empty
              log("Chart data is null or empty, clearing all data");
              revenueCurrent.clear();
              revenuePrevious.clear();
              currentLabel.value = '';
              previousLabel.value = '';
            }

            if (onSuccess != null) onSuccess();
          } catch (e) {
            log("Failed to parse chart data: $e");
          }
        },
        onError: (errors, statusCode) {
          log("Chart API error: ${errors.first.message}");
        },
        onConnectionError: (errors) {
          log("Chart API connection error: ${errors.first.message}");
        },
      );
    } catch (e) {
      log("Chart API call failed: $e");
    } finally {
      if (showLoader) {
        isLoadingChart.value = false;
      }
    }
  }

  /// Call home API and optionally fetch chart data if dates are provided
  Future<void> homeApiCall({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    Function()? onSuccess,
  }) async {
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

          // If dates are provided, fetch chart data
          if (startDate != null && endDate != null && branchId != null) {
            final branchIdInt = int.tryParse(branchId) ?? 0;
            final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
            final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

            // Call chart data API without showing separate loader
            await getOrderChartData(
              branchId: branchIdInt,
              startDate: startDateStr,
              endDate: endDateStr,
              showLoader: false,
            );
          }

          if (onSuccess != null) onSuccess();
        },
        onError: (errors, statusCode) {},
        onConnectionError: (errors) {},
      );
    } catch (e) {
      log("Home API call failed: $e");
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

          // Robustly extract branch object from {data: [...] } or direct map
          final dynamic dataField = responseData['data'];
          dynamic branchObj;
          if (dataField is List && dataField.isNotEmpty) {
            branchObj = dataField.first;
          } else if (dataField is Map<String, dynamic>) {
            branchObj = dataField;
          } else {
            branchObj = responseData; // fallback to entire map if no data key
          }

          if (branchObj is Map<String, dynamic>) {
            branchDetailsResponseModel.value = BranchDetailsApiRes.fromJson(
              branchObj,
            );
          } else {
            // Unexpected shape — default to empty model
            branchDetailsResponseModel.value = BranchDetailsApiRes();
          }

          isInternalBranch.value =
              branchDetailsResponseModel.value.isInternalBranch ?? false;
          log('---- branch details -- ${branchDetailsResponseModel.value}');
          log('---- isInternalBranch -- ${isInternalBranch.value}');

          // Call homeApiCall with dates if available
          homeApiCall(
            branchId: branchId,
            startDate: startDate,
            endDate: endDate,
          );
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
