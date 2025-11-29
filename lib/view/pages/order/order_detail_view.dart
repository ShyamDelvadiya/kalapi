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

        final order = orderController.orderDetails.value;

        if (order == null) {
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

        final orderDate = orderController.parseDate(order.orderDate);
        final formattedDate =
            orderDate != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(orderDate)
                : '-';

        // Determine status color
        Color statusColor;
        switch (order.status?.toLowerCase()) {
          case 'completed':
            statusColor = Colors.green;
            break;
          case 'pending':
            statusColor = Colors.orange;
            break;
          case 'cancelled':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.blue;
        }

        // Payment status color
        Color paymentStatusColor;
        switch (order.paymentStatus?.toLowerCase()) {
          case 'paid':
            paymentStatusColor = Colors.green;
            break;
          case 'pending':
            paymentStatusColor = Colors.orange;
            break;
          case 'failed':
            paymentStatusColor = Colors.red;
            break;
          default:
            paymentStatusColor = Colors.grey;
        }

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
                            order.orderNumber ?? '-',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status ?? '-',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
                            '₹${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}',
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

              // Customer Information
              _buildInfoCard(
                title: 'Customer Information',
                icon: Icons.person_outline,
                children: [
                  _buildInfoRow('Name', order.customerName ?? '-'),
                  _buildInfoRow('Phone', order.customerPhone ?? '-'),
                  if (order.customerEmail != null &&
                      order.customerEmail!.isNotEmpty)
                    _buildInfoRow('Email', order.customerEmail!),
                  if (order.deliveryAddress != null &&
                      order.deliveryAddress!.isNotEmpty)
                    _buildInfoRow('Address', order.deliveryAddress!),
                ],
              ),

              // Payment Information
              _buildInfoCard(
                title: 'Payment Information',
                icon: Icons.payment_outlined,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Status',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: paymentStatusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.paymentStatus ?? '-',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (order.paymentMethod != null &&
                      order.paymentMethod!.isNotEmpty)
                    _buildInfoRow('Payment Method', order.paymentMethod!),
                ],
              ),

              // Order Items
              _buildInfoCard(
                title: 'Order Items (${order.orderItems?.length ?? 0})',
                icon: Icons.shopping_bag_outlined,
                children: [
                  if (order.orderItems != null && order.orderItems!.isNotEmpty)
                    ...order.orderItems!.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
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
                                  '₹${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColorStudent(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (item.sku != null && item.sku!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'SKU: ${item.sku}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                if (item.weight != null &&
                                    item.weight!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.weight!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: Colors.orange[900],
                                      ),
                                    ),
                                  ),
                                const Spacer(),
                                Text(
                                  'Qty: ${item.quantity ?? 0}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  else
                    Text(
                      'No items',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),

              // Price Breakdown
              _buildInfoCard(
                title: 'Price Breakdown',
                icon: Icons.receipt_long_outlined,
                children: [
                  _buildInfoRow(
                    'Subtotal',
                    '₹${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  if (order.discount != null && order.discount! > 0)
                    _buildInfoRow(
                      'Discount',
                      '- ₹${order.discount?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    'Final Amount',
                    '₹${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}',
                    isBold: true,
                  ),
                ],
              ),

              // Additional Information
              if (order.remarks != null && order.remarks!.isNotEmpty)
                _buildInfoCard(
                  title: 'Remarks',
                  icon: Icons.note_outlined,
                  children: [
                    Text(
                      order.remarks!,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

              // Branch Information
              if (order.branchName != null && order.branchName!.isNotEmpty)
                _buildInfoCard(
                  title: 'Branch',
                  icon: Icons.store_outlined,
                  children: [_buildInfoRow('Branch Name', order.branchName!)],
                ),
            ],
          ),
        );
      }),
    );
  }
}
