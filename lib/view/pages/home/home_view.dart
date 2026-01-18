import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/basewidget/custom_app_bar/custom_app_bar.dart';
import 'package:kalapi/view/basewidget/revenue_chart_card.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/order/order_view.dart';
import 'package:kalapi/view/pages/product/product_view.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  String? branchId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    branchId = pref.read("branchId") ?? '0';
    // Initialize dates to default range (last 30 days)
    _endDate = DateTime.now();
    _startDate = _endDate!.subtract(Duration(days: 30));
    homeController.startDate = _startDate;
    homeController.endDate = _endDate;
    // branchDetailsApiCall will internally call homeApiCall which loads chart data
    homeController.branchDetailsApiCall(branchId: branchId);
  }

  void _loadChartData() {
    if (_startDate != null && _endDate != null && branchId != null) {
      // Call homeApiCall with dates to fetch both dashboard and chart data
      final branchIdInt = int.tryParse(branchId!) ?? 0;
      final startDateStr = DateFormat('yyyy-MM-dd').format(_startDate!);
      final endDateStr = DateFormat('yyyy-MM-dd').format(_endDate!);
      homeController.getOrderChartData(
        branchId: branchIdInt,
        startDate: startDateStr,
        endDate: endDateStr,
      );
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: _endDate ?? DateTime.now(),
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
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // If end date is null or before start date, set it to start date + 1 day
        if (_endDate == null || _startDate!.isAfter(_endDate!)) {
          _endDate = _startDate!.add(Duration(days: 1));
          if (_endDate!.isAfter(DateTime.now())) {
            _endDate = DateTime.now();
          }
        }
      });
      homeController.startDate = _startDate;
      homeController.endDate = _endDate;
      // Only load chart data if both dates are set
      if (_startDate != null && _endDate != null) {
        _loadChartData();
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    // If start date is not selected, show a message
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select start date first'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      homeController.endDate = _endDate;
      // Load chart data when end date is selected
      if (_startDate != null && _endDate != null) {
        _loadChartData();
      }
    }
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color startColor,
    required Color endColor,
    VoidCallback? onTap,
    double? width,
    bool isLoading = false,
  }) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: startColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: card);
    }

    return Expanded(child: card);
  }

  Widget _buildAmountCard(
    BuildContext context, {
    required String label,
    required dynamic amount,
    required IconData icon,
  }) {
    final amountValue = amount is num ? amount.toDouble() : 0.0;
    final formattedAmount = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(amountValue);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedAmount,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isRequired = false,
    bool isDisabled = false,
  }) {
    final bool isEmpty = date == null;
    final bool hasError = isRequired && isEmpty && !isDisabled;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                isDisabled
                    ? AppColors.backGroundColor(context).withOpacity(0.5)
                    : AppColors.backGroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  hasError
                      ? Colors.red.withOpacity(0.5)
                      : AppColors.primaryColorStudent(context).withOpacity(0.3),
              width: hasError ? 2.0 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isDisabled
                          ? Colors.grey.withOpacity(0.2)
                          : AppColors.primaryColorStudent(
                            context,
                          ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color:
                      isDisabled
                          ? Colors.grey
                          : AppColors.primaryColorStudent(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color:
                                isDisabled
                                    ? AppColors.titleColor(
                                      context,
                                    ).withOpacity(0.4)
                                    : AppColors.titleColor(
                                      context,
                                    ).withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isRequired && !isDisabled)
                          Text(
                            ' *',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: hasError ? Colors.red : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date != null
                          ? DateFormat('MMM dd, yyyy').format(date)
                          : isDisabled
                          ? 'Select start date first'
                          : 'Select date',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color:
                            date != null
                                ? AppColors.titleColor(context)
                                : isDisabled
                                ? AppColors.titleColor(context).withOpacity(0.3)
                                : AppColors.titleColor(
                                  context,
                                ).withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isDisabled ? Icons.lock_outline : Icons.arrow_drop_down,
                color:
                    isDisabled
                        ? Colors.grey
                        : AppColors.primaryColorStudent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: customAppBar(
        context,
        title: 'Dashboard',
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Get.toNamed(RouteName.legal),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColorStudent(context),
        onRefresh: () async {
          // branchDetailsApiCall will internally reload chart data
          homeController.branchDetailsApiCall(branchId: branchId ?? '0');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
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
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back!',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kalapi Farsan',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Manage your shop efficiently',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                              'assets/images/logo 1.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Order Amount Information
                    Obx(() {
                      final dashboard =
                          homeController.dashboardResponseModel.value;
                      final currentMonthAmount =
                          dashboard.currentMonthOrderAmount ?? 0.0;
                      final totalAmount = dashboard.totalOrderAmount ?? 0.0;

                      return Column(
                        children: [
                          _buildAmountCard(
                            context,
                            label: 'Current Month Order Value',
                            amount: currentMonthAmount,
                            icon: Icons.calendar_today_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildAmountCard(
                            context,
                            label: 'Total Order Value',
                            amount: totalAmount,
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Overview',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor(context),
                ),
              ),
              const SizedBox(height: 16),

              // Responsive stats grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final int columns =
                      maxWidth > 900 ? 3 : (maxWidth > 600 ? 2 : 1);
                  const double spacing = 16.0;
                  final double totalSpacing = spacing * (columns - 1);
                  final double cardWidth = (maxWidth - totalSpacing) / columns;

                  return Obx(() {
                    final isLoading =
                        homeController
                            .isLoading
                            .value; // Assuming controller has isLoading

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        _buildStatCard(
                          context,
                          label: 'Total Orders',
                          value:
                              homeController
                                  .dashboardResponseModel
                                  .value
                                  .totalOrders
                                  ?.toString() ??
                              '0',
                          icon: Icons.shopping_bag_outlined,
                          startColor: const Color(0xFFFF6F00), // Amber 900
                          endColor: const Color(0xFFFF8F00), // Amber 800
                          onTap: () {
                            Get.to(() => const OrderView());
                          },
                          width: cardWidth,
                          isLoading: isLoading,
                        ),
                        _buildStatCard(
                          context,
                          label: 'Total Products',
                          value:
                              homeController
                                  .dashboardResponseModel
                                  .value
                                  .totalProduct
                                  ?.toString() ??
                              '0',
                          icon: Icons.inventory_2_outlined,
                          startColor: const Color(
                            0xFFD84315,
                          ), // Deep Orange 800
                          endColor: const Color(0xFFFF5722), // Deep Orange 500
                          onTap: () {
                            Get.to(() => const ProductView());
                          },
                          width: cardWidth,
                          isLoading: isLoading,
                        ),
                      ],
                    );
                  });
                },
              ),

              const SizedBox(height: 24),

              // Date Filter Section
              Obx(() {
                final isLoading = homeController.isLoading.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chart Filters',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(20),
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
                                Icon(
                                  Icons.date_range_outlined,
                                  color: AppColors.primaryColorStudent(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Select Date Range',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.titleColor(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDatePickerButton(
                                    context,
                                    label: 'Start Date',
                                    date: _startDate,
                                    onTap: () => _selectStartDate(context),
                                    isRequired: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDatePickerButton(
                                    context,
                                    label: 'End Date',
                                    date: _endDate,
                                    onTap: () => _selectEndDate(context),
                                    isRequired: true,
                                    isDisabled: _startDate == null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // Chart Section
              Obx(() {
                final isLoading = homeController.isLoading.value;
                if (isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }
                return RevenueChartCard(
                  current: homeController.revenueCurrent.toList(),
                  previous: homeController.revenuePrevious.toList(),
                  currentLabel: homeController.currentLabel.value,
                  previousLabel: homeController.previousLabel.value,
                  graphData: homeController.graphApiRes.value,
                );
              }),

              // const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
