import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/product_detail_view.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final HomeController homeController = Get.find<HomeController>();
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.productApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        final res = productController.productResponseModel.value;
        final items = res.data ?? [];

        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return Center(
            child: Text(
              res.message ?? 'No products available',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth > 900
                      ? 3
                      : (constraints.maxWidth > 600 ? 2 : 1);

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ProductDetailView(productId: item.productId ?? 0),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white24,
                            child: Text(
                              (item.productName ?? '').isNotEmpty
                                  ? item.productName![0]
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.productName ?? '-',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      'SKU: ${item.sku ?? '-'}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${item.weight ?? '-'}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${item.basePrice ?? 0}',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Icon(Icons.chevron_right, color: Colors.white70),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
