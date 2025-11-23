import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';

class ProductDetailController extends GetxController {
  var isLoading = false.obs;

  final Rx<ProductList?> product = Rx<ProductList?>(null);
  RestRequestProvider apiService = RestRequestProvider();
  final Rx<RequestStatus> requestStatus = RequestStatus.none.obs;

  Future<void> fetchDetail(int productId) async {
    isLoading.value = true;
    try {
      await apiService.doGet(
        headers: apiService.getHeader(),
        endPoint: '${ApiEndPoint.productDetails}?productId=$productId',
        requestStatus: null,
        onSuccess: (responseData) async {
          isLoading.value = false;

          requestStatus.value = RequestStatus.success;

          try {
            product.value = ProductList.fromJson(
              List<dynamic>.from(responseData['data']).first,
            );
            log('---- details 00-- ${product.value}');
            product.refresh();
          } catch (e) {
            log(e.toString());
            // ignore parse errors
          }
        },
        onError: (errors, statusCode) {},
        onConnectionError: (errors) {},
      );
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }
}

class ProductDetailView extends StatefulWidget {
  final int productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  void initState() {
    super.initState();
    controller.fetchDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white24,
                      child: Text(
                        (controller.product.value?.productName ?? '-')[0],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.product.value?.productName ?? '-',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SKU: ${controller.product.value?.sku ?? '-'}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${controller.product.value?.basePrice ?? 0}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax & Pricing',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('CGST: '),
                          Text('${controller.product.value?.cgst ?? 0}%'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('SGST: '),
                          Text('${controller.product.value?.sgst ?? 0}%'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('Internal Price: '),
                          Text(
                            '₹${controller.product.value?.internalPrice ?? 0}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('Weight: '),
                          Text(controller.product.value?.weight ?? '-'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text('HSN Code'),
                  subtitle: Text(controller.product.value?.hsnCode ?? '-'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
