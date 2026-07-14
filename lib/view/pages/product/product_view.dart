import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/product/cart_checkout_view.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/product_detail_view.dart';
import 'package:kalapi/view/pages/product/widget/common_quntity.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.put(ProductController());
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    if (isPBBranch.value) {
      productController.selectedCategoryId.value = 1;
    } else {
      productController.selectedCategoryId.value = null;
    }
    productController.productApiCall(
      page: 1,
      size: 10,
      categoryId: productController.selectedCategoryId.value,
    );
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
                            child: const Text('Clear'),
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
    final threshold = 200.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll - current <= threshold) {
      productController.loadMoreProducts();
    }
  }

  void _showQuantityDialog(
    int productId,
    double currentQty, {
    int? categoryId,
  }) {
    final textController = TextEditingController(
      text:
          currentQty == currentQty.toInt()
              ? currentQty.toInt().toString()
              : currentQty.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter Quantity',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            keyboardType:
                categoryId == 2
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                double? val;
                if (categoryId == 2) {
                  val = double.tryParse(text);
                } else {
                  val = int.tryParse(text)?.toDouble();
                }

                if (val != null && val >= 0) {
                  productController.setCartQuantity(productId, val);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColorStudent(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Set',
                style: GoogleFonts.outfit(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.primaryColorStudent(context),
        title: Text(
          'Our Products',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          Obx(() {
            final anySelected = productController.cartSelected.values.any(
              (v) => v == true,
            );
            return anySelected
                ? TextButton(
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
                )
                : const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final selectedCount =
            productController.cartSelected.values
                .where((v) => v == true)
                .length;
        if (selectedCount == 0) return const SizedBox.shrink();
        final total = productController.subtotal.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Items: $selectedCount',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ₹${total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColorStudent(context),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => const CartCheckoutView()),
                icon: const Icon(
                  Icons.shopping_cart_checkout,
                  color: Colors.white,
                ),
                label: Text(
                  'Checkout',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColorStudent(context),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      body: Column(
        children: [
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
                    Obx(() {
                      if (isPBBranch.value) {
                        return const SizedBox.shrink();
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Obx(() {
            if (isPBBranch.value) return const SizedBox.shrink();
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
              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
                      final anySelected = productController.cartSelected.values
                          .any((v) => v == true);
                      if (anySelected) {
                        productController.toggleCartSelection(id);
                        return;
                      }
                      Get.to(
                        () => ProductDetailView(productId: item.productId ?? 0),
                      );
                    },
                    onLongPress: () {
                      productController.toggleCartSelection(id);
                    },
                    child: Container(
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
                            color: AppColors.primaryColorStudent(
                              context,
                            ).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Checkbox, Avatar, and Product Name
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() {
                                final anySelected = productController.cartSelected.values
                                    .any((v) => v == true);
                                if (!anySelected) return const SizedBox.shrink();
                                final sel =
                                    productController.cartSelected[id] ?? false;
                                return GestureDetector(
                                  onTap: () {
                                    productController.toggleCartSelection(id);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      color:
                                          sel ? Colors.white : Colors.transparent,
                                    ),
                                    child:
                                        sel
                                            ? Icon(
                                              Icons.check,
                                              size: 16,
                                              color: AppColors.primaryColorStudent(
                                                context,
                                              ),
                                            )
                                            : null,
                                  ),
                                );
                              }),
                              Container(
                                width: 44,
                                height: 44,
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
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.productName ?? '-',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Bottom Row: Weight tag on the left, Price & Action button on the right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if ((item.weight ?? '').isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.weight!,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                              Obx(() {
                                final selected =
                                    productController.cartSelected[id] ?? false;
                                final double qty =
                                    productController.cartQuantities[id] ?? 0.0;
                                final price =
                                    isPBBranch.value
                                        ? (item.pbPrice ?? 0)
                                        : isInternalBranch.value
                                        ? (item.internalPrice ??
                                            item.basePrice ??
                                            0)
                                        : (item.basePrice ?? 0);

                                if (selected) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹$price',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      QuantityButton(
                                        quantity: qty == 0 ? 1.0 : qty,
                                        onQuantityTap:
                                            () => _showQuantityDialog(
                                              id,
                                              qty == 0 ? 1.0 : qty,
                                              categoryId: item.categoryId,
                                            ),
                                        onIncrement: () {
                                          final double currentQty =
                                              productController
                                                  .cartQuantities[id] ??
                                              0.0;
                                          final double step =
                                              item.categoryId == 2 ? 0.5 : 1.0;
                                          productController.setCartQuantity(
                                            id,
                                            currentQty + step,
                                          );
                                        },
                                        onDecrement: () {
                                          final double cur =
                                              productController
                                                  .cartQuantities[id] ??
                                              1.0;
                                          final double step =
                                              item.categoryId == 2 ? 0.5 : 1.0;
                                          if (cur > step) {
                                            productController.setCartQuantity(
                                              id,
                                              cur - step,
                                            );
                                          } else {
                                            productController.setCartQuantity(
                                              id,
                                              0.0,
                                            );
                                          }
                                        },
                                        bgColor: Colors.white.withOpacity(0.2),
                                        iconColor: Colors.white,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  );
                                }

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₹$price',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final double current =
                                            productController
                                                .cartQuantities[id] ??
                                            0.0;
                                        final double next =
                                            current > 0 ? current + 1.0 : 1.0;
                                        productController.setCartQuantity(
                                          id,
                                          next,
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 16),
                                      label: Text(
                                        'Add',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            AppColors.primaryColorStudent(
                                              context,
                                            ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
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
