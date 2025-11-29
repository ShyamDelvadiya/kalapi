import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/order/controller/order_controller.dart';
import 'package:kalapi/view/pages/order/model/order_list_api_res.dart';
import 'package:kalapi/view/pages/order/order_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Get branch ID from storage
    final branchId = pref.read("branchId");
    if (branchId != null) {
      orderController.branchId.value = int.tryParse(branchId.toString()) ?? 0;
    }
    // Fetch initial orders
    orderController.getOrderListApiCall();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: orderController.startDate.value ?? DateTime.now(),
        end: orderController.endDate.value ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColorStudent(context),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      orderController.setDateRange(picked.start, picked.end);
    }
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 180,
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderData? order) {
    final orderDate = orderController.parseDate(order?.orderDate);
    final formattedDate =
        orderDate != null
            ? DateFormat('dd MMM yyyy, hh:mm a').format(orderDate)
            : '-';

    // Determine status color
    Color statusColor;
    switch (order?.status?.toLowerCase()) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColorStudent(context),
            AppColors.primaryColorOwner(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColorStudent(context).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to order details screen
            if (order?.orderId != null) {
              Get.to(() => OrderDetailView(orderId: order?.orderId ?? 0));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order?.orderNumber ?? '-',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
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
                        order?.status ?? '-',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Customer Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order?.customerName ?? 'Unknown Customer',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (order?.customerPhone != null)
                              Text(
                                order?.customerPhone ?? '',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white.withOpacity(0.8),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${order?.orderItems?.length ?? 0} items',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${order?.finalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: AppBar(
        title: Text(
          'Orders',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: _selectDateRange,
            tooltip: 'Select Date Range',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColorStudent(context),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Obx(() {
              final start = orderController.startDate.value;
              final end = orderController.endDate.value;
              final startStr =
                  start != null ? DateFormat('dd MMM yyyy').format(start) : '-';
              final endStr =
                  end != null ? DateFormat('dd MMM yyyy').format(end) : '-';

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$startStr - $endStr',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),

          // Orders List
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryColorStudent(context),
              onRefresh: () => orderController.refreshOrders(),
              child: Obx(() {
                if (orderController.isLoading.value &&
                    orderController.orders.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  );
                }

                if (orderController.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting the date range',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
