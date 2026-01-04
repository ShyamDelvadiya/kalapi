import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/order/controller/order_controller.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailView extends StatefulWidget {
  final int orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    orderController.getOrderDetailsApiCall(orderId: widget.orderId);
  }

  Widget _buildShimmerCard({double height = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        height: height,
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: AppColors.primaryColorStudent(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
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
          'Order Details',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (orderController.isLoadingDetails.value) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildShimmerCard(height: 150),
                _buildShimmerCard(height: 120),
                _buildShimmerCard(height: 200),
                _buildShimmerCard(height: 150),
              ],
            ),
          );
        }

        if (orderController.orderDetails.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Order not found',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // Use the first item for general order info
        final firstItem = orderController.orderDetails.first;

        final orderDate = orderController.parseDate(firstItem.orderDate);
        final formattedDate =
            orderDate != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(orderDate)
                : '-';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header Card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            firstItem.orderNumber ?? '-',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            '₹${firstItem.orderTotalAmount?.toStringAsFixed(2) ?? '0.00'}',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Order Items
              _buildInfoCard(
                title: 'Order Items (${orderController.orderDetails.length})',
                icon: Icons.shopping_bag_outlined,
                children: [
                  ...orderController.orderDetails.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.productName ?? '-',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${item.orderItemAmount?.toStringAsFixed(2) ?? '0.00'}',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColorStudent(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Qty: ${item.quantity ?? 0}',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Unit Price: ₹${item.unitPrice?.toStringAsFixed(2) ?? '0.00'}',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),

              // Price Breakdown
              _buildInfoCard(
                title: 'Price Breakdown',
                icon: Icons.receipt_long_outlined,
                children: [
                  _buildInfoRow(
                    'Total Amount',
                    '₹${firstItem.orderTotalAmount?.toStringAsFixed(2) ?? '0.00'}',
                    isBold: true,
                  ),
                ],
              ),

              // Branch Information
              if (firstItem.branchName != null &&
                  firstItem.branchName!.isNotEmpty)
                _buildInfoCard(
                  title: 'Branch',
                  icon: Icons.store_outlined,
                  children: [
                    _buildInfoRow('Branch Name', firstItem.branchName!),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}
