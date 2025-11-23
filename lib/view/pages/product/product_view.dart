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
    productController.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        final res = productController.productResponseModel.value;
        // Apply filters locally by re-fetching via controller or filtering the current payload.
        List items = res.data ?? [];

        // If a category is selected or search query present, the controller would have
        // refetched results. However as a fallback, apply an in-memory filter here
        // for quick responsiveness (non-destructive):
        final selectedCat = productController.selectedCategoryId.value;
        final searchQ =
            productController.searchQuery.value.trim().toLowerCase();

        if (selectedCat != null) {
          items =
              items.where((p) {
                try {
                  // Try to match categoryId if present on the item; be defensive.
                  final cid = (p as dynamic).categoryId;
                  if (cid != null) return cid == selectedCat;
                } catch (_) {}
                return true; // if item has no categoryId, keep it (server-side filter preferred)
              }).toList();
        }

        if (searchQ.isNotEmpty) {
          items =
              items.where((p) {
                final name =
                    ((p as dynamic).productName ?? '').toString().toLowerCase();
                return name.contains(searchQ);
              }).toList();
        }

        // Remove early returns: always show filters and place content (loader/empty/grid)
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Search field and category filter (always visible)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        prefixIcon: Icon(Icons.search),
                        suffix: Icon(Icons.filter_alt_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                      ),
                      onChanged: (val) => productController.setSearch(val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Expanded(
                  //   flex: 1,
                  //   child: Obx(() {
                  //     final cats = productController.categories;
                  //     return DropdownButtonFormField<int?>(
                  //       value: productController.selectedCategoryId.value,
                  //       items: [
                  //         DropdownMenuItem<int?>(
                  //           value: null,
                  //           child: Text('All'),
                  //         ),
                  //         ...cats.map(
                  //           (c) => DropdownMenuItem<int?>(
                  //             value: c.categoryId,
                  //             child: Text(c.category ?? '-'),
                  //           ),
                  //         ),
                  //       ],
                  //       onChanged: (v) => productController.setCategory(v),
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         contentPadding: EdgeInsets.symmetric(
                  //           vertical: 0,
                  //           horizontal: 12,
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),
              const SizedBox(height: 12),

              // Main content area below filters: loader, empty message or grid
              Expanded(
                child: Obx(() {
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

                  return LayoutBuilder(
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
                                () => ProductDetailView(
                                  productId: item.productId ?? 0,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6A11CB),
                                    Color(0xFF2575FC),
                                  ],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${item.weight ?? '-'}',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
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
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
