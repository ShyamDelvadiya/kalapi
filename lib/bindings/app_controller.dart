import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kalapi/api_service/api_service.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  var selectedPgId = ''.obs;
  var selectedRoleId = ''.obs;

  RxBool shimmer = true.obs;

  RxBool isLoading = false.obs;
  RestRequestProvider apiService = RestRequestProvider();
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed) {
    //   _checkAndShowLockIfNeeded();
    // }
  }
}
