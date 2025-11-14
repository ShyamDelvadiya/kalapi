import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/view/basewidget/custom_app_bar/custom_app_bar.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/product/model/product_list_api_res.dart';
import 'package:kalapi/view/pages/product/product_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  String? branchId;
  @override
  initState() {
    super.initState();
    branchId = pref.read("branchId") ?? '0';
    homeController.homeApiCall(branchId: branchId);
    // You can initiate API calls here if needed
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
  }) {
    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: startColor.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(icon, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
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
      appBar: customAppBar(
        context,
        leading: SizedBox(),
        title: 'Home',
        actions: [
          // keep the logout action, but ensure icon contrasts with gradient
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Clear login pref and go to login
              try {
                pref.erase();
              } catch (_) {}
              Get.offAllNamed(RouteName.login);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          homeController.homeApiCall(branchId: branchId ?? '0');
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Welcome to Farsan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Quick overview of your shop',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Responsive stats grid: 1 column on narrow screens, 2 on medium, 3 on wide
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final int columns =
                      maxWidth > 900 ? 3 : (maxWidth > 600 ? 2 : 1);
                  const double spacing = 12.0;
                  final double totalSpacing = spacing * (columns - 1);
                  final double cardWidth = (maxWidth - totalSpacing) / columns;

                  return Obx(() {
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        // _buildStatCard(
                        //   context,
                        //   label: 'Total Customers',
                        //   value: '1,234',
                        //   icon: Icons.people_alt,
                        //   startColor: const Color(0xFF6A11CB),
                        //   endColor: const Color(0xFF2575FC),
                        //   onTap: () {
                        //     // TODO: navigate to customers
                        //   },
                        //   width: cardWidth,
                        // ),
                        _buildStatCard(
                          context,
                          label: 'Orders',
                          value:
                              homeController
                                  .dashboardResponseModel
                                  .value
                                  .totalOrders
                                  .toString() ??
                              '',
                          icon: Icons.shopping_cart,
                          startColor: const Color(0xFF00B09B),
                          endColor: const Color(0xFF96C93D),
                          onTap: () {
                            // TODO: navigate to orders
                          },
                          width: cardWidth,
                        ),
                        _buildStatCard(
                          context,
                          label: 'Total Products',
                          value:
                              homeController
                                  .dashboardResponseModel
                                  .value
                                  .totalProduct
                                  .toString() ??
                              '',
                          icon: Icons.inventory_2,
                          startColor: const Color(0xFFFF6A00),
                          endColor: const Color(0xFFFF8E53),
                          onTap: () {
                            Get.to(ProductView());
                          },
                          width: cardWidth,
                        ),
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
