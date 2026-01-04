import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/product/cart_checkout_view.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/product_detail_view.dart';
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
        title: Text(
          'Our Products',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
        elevation: 0,
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
              child: Text(
                'Clear',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        final anySelected = productController.cartSelected.values.any(
          (v) => v == true,
        );
        if (!anySelected) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => const CartCheckoutView());
          },
          label: Text(
            "Proceed to Checkout",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
          backgroundColor: AppColors.primaryColorOwner(context),
        );
      }),

      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColorStudent(context),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          style: GoogleFonts.outfit(color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Search for snacks...',
                            hintStyle: GoogleFonts.outfit(
                              color: Colors.black38,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.orange,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (val) => productController.setSearch(val),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          color: Colors.orange,
                        ),
                        onPressed: _openCategorySheet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Selected Category Chip
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    selectedName.isNotEmpty ? selectedName : 'Selected',
                    style: GoogleFonts.outfit(
                      color: AppColors.primaryColorStudent(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onDeleted: () {
                    productController.setCategory(null);
                  },
                  deleteIcon: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.primaryColorStudent(context),
                  ),
                  backgroundColor: Colors.orange.shade50,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }),

          // Product Grid
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value &&
                  productController.items.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColorStudent(context),
                    ),
                  ),
                );
              }

              if (productController.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cookie_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No snacks found',
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount =
                      constraints.maxWidth > 900
                          ? 3
                          : (constraints.maxWidth > 600 ? 2 : 1);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 3.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColorStudent(context),
                              ),
                            ),
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
                            productController.toggleCartSelection(id);
                            return;
                          }
                          Get.to(
                            () => ProductDetailView(
                              productId: item.productId ?? 0,
                            ),
                          );
                        },
                        onLongPress: () {
                          productController.toggleCartSelection(id);
                        },
                        child: Container(
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
                                color: AppColors.primaryColorStudent(
                                  context,
                                ).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Selection Checkbox
                              Obx(() {
                                final anySelected = productController
                                    .cartSelected
                                    .values
                                    .any((v) => v == true);
                                if (!anySelected)
                                  return const SizedBox.shrink();
                                final sel =
                                    productController.cartSelected[id] ?? false;
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
                                            ? Icon(
                                              Icons.check,
                                              size: 16,
                                              color:
                                                  AppColors.primaryColorStudent(
                                                    context,
                                                  ),
                                            )
                                            : null,
                                  ),
                                );
                              }),

                              // Product Initial Avatar
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  (item.productName ?? '').isNotEmpty
                                      ? item.productName![0]
                                      : '?',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.productName ?? '-',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            item.weight ?? '-',
                                            style: GoogleFonts.outfit(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'SKU: ${item.sku ?? '-'}',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Price or Quantity Controls
                              Obx(() {
                                final selected =
                                    productController.cartSelected[id] ?? false;
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
                                    bgColor: Colors.white.withOpacity(0.2),
                                    iconColor: Colors.white,
                                    textColor: Colors.white,
                                  );
                                }

                                return Obx(() {
                                  final price =
                                      isInternalBranch.value
                                          ? (item.internalPrice ??
                                              item.basePrice ??
                                              0)
                                          : (item.basePrice ?? 0);
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹$price',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white54,
                                        size: 14,
                                      ),
                                    ],
                                  );
                                });
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
    );
  }
}
