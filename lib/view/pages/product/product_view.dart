import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/product/cart_checkout_view.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/product_detail_view.dart';
import 'package:kalapi/view/basewidget/textformfield/custom_text_form_field.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/product/widget/common_quntity.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final HomeController homeController = Get.find<HomeController>();
  final ProductController productController = Get.put(ProductController());
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    productController.productApiCall(page: 1, size: 10);
    productController.fetchCategories();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    productController.searchQuery.value = '';
    super.dispose();
  }

  void _openCategorySheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Obx(() {
            final cats = productController.categories;
            final selected = productController.selectedCategoryId.value;
            // constrain height so the sheet can scroll when content is long
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select category',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              productController.setCategory(null);
                              Navigator.pop(context);
                            },
                            child: Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('All'),
                      trailing:
                          selected == null ? const Icon(Icons.check) : null,
                      onTap: () {
                        productController.setCategory(null);
                        Navigator.pop(context);
                      },
                    ),
                    ...cats.map(
                      (c) => ListTile(
                        title: Text(c.category ?? '-'),
                        trailing:
                            (selected == c.categoryId)
                                ? const Icon(Icons.check)
                                : null,
                        onTap: () {
                          productController.setCategory(c.categoryId);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200.0; // px from bottom to trigger
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll - current <= threshold) {
      // attempt load more
      if (!productController.isLoadingMore.value &&
          productController.hasMore.value) {
        final nextPage = productController.currentPage.value + 1;
        productController.productApiCall(
          page: nextPage,
          size: productController.pageSize.value,
          categoryId: productController.selectedCategoryId.value,
          search: productController.searchQuery.value,
        );
      }
    }
  }

  // Selection/quantities are stored in ProductController.cartSelected / cartQuantities

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Obx(() {
            final anySelected = productController.cartSelected.values.any(
              (v) => v == true,
            );
            if (!anySelected) return const SizedBox.shrink();
            return TextButton(
              onPressed: () {
                productController.clearCartSelection();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.black)),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        final anySelected = productController.cartSelected.values.any(
          (v) => v == true,
        );
        if (!anySelected) return const SizedBox.shrink();

        final selectedItems =
            productController.cartSelected.entries
                .where((e) => e.value == true)
                .map((e) {
                  final id = e.key;
                  final product = productController.items.firstWhere(
                    (p) => p.productId == id,
                    // orElse:
                    //     () =>
                    //         productController.items.isNotEmpty
                    //             ? productController.items[0]
                    //             : null,
                  );
                  return {
                    "productId": id,
                    "productName": product?.productName,
                    "weight": product?.weight,
                    "price": product?.basePrice,
                    "quantity": productController.cartQuantities[id] ?? 1,
                  };
                })
                .toList();

        return FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => CartCheckoutView(orderItems: selectedItems));
          },
          label: Text(
            "Proceed",
            style: GoogleFonts.mulish(color: AppColors.whiteColor(context)),
          ),
          icon: Icon(Icons.arrow_forward, color: AppColors.whiteColor(context)),
          backgroundColor: Colors.deepOrange,
        );
      }),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search field and category filter (always visible)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextFormField(
                    controller: _searchController,
                    hintText: 'Search products',
                    textInputAction: TextInputAction.search,
                    prefixImage: const Icon(Icons.search, color: Colors.black),
                    fillColor: AppColors.fillColor(context),
                    fillColorBool: true,
                    hintstyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    textStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    suffixImage: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.black),
                      onPressed: _openCategorySheet,
                    ),
                    onChanged: (val) => productController.setSearch(val),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 12),

            // If a category filter is selected, show it as a removable chip below the search field
            Obx(() {
              final sel = productController.selectedCategoryId.value;
              if (sel == null) return const SizedBox.shrink();
              String selectedName = '';
              for (var c in productController.categories) {
                if (c.categoryId == sel) {
                  selectedName = c.category ?? '';
                  break;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InputChip(
                    label: Text(
                      selectedName.isNotEmpty ? selectedName : 'Selected',
                    ),
                    onDeleted: () {
                      productController.setCategory(null);
                    },
                    deleteIcon: const Icon(Icons.close),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white10
                            : Colors.grey.shade200,
                  ),
                ),
              );
            }),

            // Main content area below filters: loader, empty message or grid
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value &&
                    productController.items.isEmpty) {
                  // initial loading spinner
                  return const Center(child: CircularProgressIndicator());
                }

                if (productController.items.isEmpty) {
                  return Center(
                    child: Text(
                      'No products available',
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
                      controller: _scrollController,
                      itemCount:
                          productController.items.length +
                          (productController.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= productController.items.length) {
                          return Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        final item = productController.items[index];
                        final id = item.productId ?? index;

                        return GestureDetector(
                          onTap: () {
                            final anySelected = productController
                                .cartSelected
                                .values
                                .any((v) => v == true);
                            if (anySelected) {
                              // toggle selection via controller
                              productController.toggleCartSelection(id);
                              return;
                            }

                            // normal open detail
                            Get.to(
                              () => ProductDetailView(
                                productId: item.productId ?? 0,
                              ),
                            );
                          },
                          onLongPress: () {
                            // enter selection mode and toggle
                            productController.toggleCartSelection(id);
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
                                Obx(() {
                                  final anySelected = productController
                                      .cartSelected
                                      .values
                                      .any((v) => v == true);
                                  if (!anySelected)
                                    return const SizedBox.shrink();
                                  final sel =
                                      productController.cartSelected[id] ??
                                      false;
                                  return GestureDetector(
                                    onTap: () {
                                      productController.toggleCartSelection(id);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        color:
                                            sel
                                                ? Colors.white
                                                : Colors.transparent,
                                      ),
                                      child:
                                          sel
                                              ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.blue,
                                              )
                                              : null,
                                    ),
                                  );
                                }),

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
                                // If this product is selected show +/- buttons bound to the controller
                                Obx(() {
                                  final selected =
                                      productController.cartSelected[id] ??
                                      false;
                                  final qty =
                                      productController.cartQuantities[id] ?? 0;
                                  if (selected) {
                                    return QuantityButton(
                                      quantity: qty == 0 ? 1 : qty,
                                      onIncrement: () {
                                        final newQty =
                                            (productController
                                                    .cartQuantities[id] ??
                                                0) +
                                            1;
                                        productController.setCartQuantity(
                                          id,
                                          newQty,
                                        );
                                      },
                                      onDecrement: () {
                                        final cur =
                                            productController
                                                .cartQuantities[id] ??
                                            1;
                                        if (cur > 1) {
                                          productController.setCartQuantity(
                                            id,
                                            cur - 1,
                                          );
                                        } else {
                                          productController.setCartQuantity(
                                            id,
                                            0,
                                          );
                                        }
                                      },
                                      bgColor: Colors.white24,
                                      iconColor: Colors.white,
                                      textColor: Colors.white,
                                    );
                                  }

                                  // default: price + chevron
                                  return Column(
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
                                  );
                                }),
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
      ),
    );
  }
}
