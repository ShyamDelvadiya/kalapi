import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

  @override
  void onInit() {
    super.onInit();
    // Load chart data from assets until backend endpoint is ready
    loadRevenueFromAssets();
  }

  Future<void> loadRevenueFromAssets() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/chart/revenue_chart_example.json',
      );
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      final chart = json['chart'] as Map<String, dynamic>?;
      if (chart == null) return;

      final List<dynamic> series = chart['series'] as List<dynamic>? ?? [];
      if (series.length < 2) return;

      final Map<String, dynamic> s0 = series[0] as Map<String, dynamic>;
      final Map<String, dynamic> s1 = series[1] as Map<String, dynamic>;
      currentLabel.value = (s0['name'] ?? 'Current').toString();
      previousLabel.value = (s1['name'] ?? 'Previous').toString();

      List<double> toThousands(List<dynamic> points) {
        return points
            .map(
              (e) =>
                  (e is Map && e['value'] != null)
                      ? (e['value'] as num).toDouble() / 1000.0
                      : 0.0,
            )
            .toList();
      }

      final List<dynamic> d0 = (s0['data'] as List<dynamic>? ?? []);
      final List<dynamic> d1 = (s1['data'] as List<dynamic>? ?? []);
      revenueCurrent.assignAll(toThousands(d0));
      revenuePrevious.assignAll(toThousands(d1));
    } catch (e) {
      log('Failed to load revenue chart from assets: $e');
    }
  }

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
