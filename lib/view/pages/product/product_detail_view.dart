import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/api_service/api_service.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
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

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.primaryColorStudent(context)),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.subTitleColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.titleColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    IconData? titleIcon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColorStudent(context).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (titleIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorStudent(
                      context,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    titleIcon,
                    size: 20,
                    color: AppColors.primaryColorStudent(context),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.dividerColor(context), height: 1),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryColorStudent(context),
              ),
            ),
          );
        }

        final product = controller.product.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Product Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColorStudent(context),
                      AppColors.primaryColorOwner(context),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColorStudent(
                        context,
                      ).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (product?.productName ?? '?').isNotEmpty
                                ? product!.productName![0].toUpperCase()
                                : '?',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.productName ?? '-',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SKU: ${product?.sku ?? '-'}',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      final price =
                          isInternalBranch.value
                              ? (product?.internalPrice ??
                                  product?.basePrice ??
                                  0)
                              : (product?.basePrice ?? 0);
                      final priceLabel =
                          isInternalBranch.value ? 'Price' : 'Price';
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              priceLabel,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹$price',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tax & Pricing Section
              _buildSectionCard(
                context: context,
                title: 'Tax & Pricing',
                titleIcon: Icons.receipt_long_outlined,
                children: [
                  _buildInfoRow(
                    context: context,
                    label: 'CGST',
                    value: '${product?.cgst ?? 0}%',
                    icon: Icons.percent,
                  ),
                  _buildInfoRow(
                    context: context,
                    label: 'SGST',
                    value: '${product?.sgst ?? 0}%',
                    icon: Icons.percent,
                  ),
                  _buildInfoRow(
                    context: context,
                    label: 'Price',
                    value:
                        '₹${isInternalBranch.value ? (product?.internalPrice ?? product?.basePrice ?? 0) : (product?.basePrice ?? 0)}',
                    icon: Icons.currency_rupee,
                  ),
                ],
              ),

              // Product Information Section
              _buildSectionCard(
                context: context,
                title: 'Product Information',
                titleIcon: Icons.info_outline,
                children: [
                  _buildInfoRow(
                    context: context,
                    label: 'Weight',
                    value: product?.weight ?? '-',
                    icon: Icons.scale_outlined,
                  ),
                  _buildInfoRow(
                    context: context,
                    label: 'HSN Code',
                    value: product?.hsnCode ?? '-',
                    icon: Icons.qr_code,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
