import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/basewidget/custom_app_bar/custom_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    branchId = pref.read("branchId") ?? '0';
    homeController.branchDetailsApiCall(branchId: branchId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: customAppBar(
        context,
        leading: const SizedBox(),
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: AppColors.titleColor(context),
            ),
            onPressed: () {
              try {
                pref.erase();
              } catch (_) {}
              Get.offAllNamed(RouteName.login);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColorStudent(context),
        onRefresh: () async {
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
                child: Row(
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
                        // Add more cards here if needed
                      ],
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
