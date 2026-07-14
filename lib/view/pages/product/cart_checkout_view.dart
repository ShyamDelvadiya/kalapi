import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';
import 'package:kalapi/view/pages/product/widget/common_quntity.dart';

class CartCheckoutView extends StatefulWidget {
  const CartCheckoutView({super.key});

  @override
  State<CartCheckoutView> createState() => _CartCheckoutViewState();
}

class _CartCheckoutViewState extends State<CartCheckoutView> {
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    // Calculate initial totals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.calculateLocalSubtotal();
      // productController.fetchTotalFromApi();
    });
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
                  productController.calculateLocalSubtotal();
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
      backgroundColor: AppColors.backGroundColor(context),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Checkout',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: Obx(() {
              final cartItems = productController.getCartItemsWithDetails();

              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
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
                itemCount: cartItems.length,
                itemBuilder: (context, i) {
                  final item = cartItems[i];
                  final productId = item['productId'] as int;
                  final name = item['productName'] ?? 'Product $productId';
                  final weight = item['weight'] ?? '';
                  final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                  final qty = (item['quantity'] as num?)?.toDouble() ?? 0.0;
                  final int? categoryId = item['categoryId'] as int?;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Avatar, Full Name, and Branch Tag
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColorStudent(context),
                                    AppColors.primaryColorOwner(context),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(() {
                              final label =
                                  isPBBranch.value
                                      ? 'PB Price'
                                      : isInternalBranch.value
                                      ? 'Internal'
                                      : 'Base';
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColorStudent(
                                    context,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primaryColorStudent(
                                      context,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: AppColors.primaryColorStudent(
                                      context,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Bottom Row: Weight & Price on left, Quantity controls on right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (weight.isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      weight,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  '₹${price.toStringAsFixed(2)}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColorStudent(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            QuantityButton(
                              quantity: qty,
                              onQuantityTap:
                                  () => _showQuantityDialog(
                                    productId,
                                    qty,
                                    categoryId: categoryId,
                                  ),
                              onIncrement: () async {
                                final double step =
                                    categoryId == 2 ? 0.5 : 1.0;
                                productController.setCartQuantity(
                                  productId,
                                  qty + step,
                                );
                                productController.calculateLocalSubtotal();
                              },
                              onDecrement: () async {
                                final double step =
                                    categoryId == 2 ? 0.5 : 1.0;
                                if (qty > step) {
                                  productController.setCartQuantity(
                                    productId,
                                    qty - step,
                                  );
                                } else {
                                  productController.setCartQuantity(
                                    productId,
                                    0.0,
                                  );
                                }
                                productController.calculateLocalSubtotal();
                              },
                              bgColor: AppColors.primaryColorStudent(
                                context,
                              ).withOpacity(0.1),
                              iconColor: AppColors.primaryColorStudent(context),
                              textColor: AppColors.primaryColorStudent(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Bottom Summary Card
          Obx(() {
            final cartItems = productController.getCartItemsWithDetails();
            final localSubtotal = productController.subtotal.value;
            // final apiTotal = productController.apiTotal.value;
            final discount = productController.discount.value;
            final isCalculating = productController.isCalculatingTotal.value;
            final isPlacing = productController.isPlacingOrder.value;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Subtotal Row
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Subtotal',
                  //       style: GoogleFonts.outfit(
                  //         fontSize: 14,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //     Text(
                  //       '₹${localSubtotal.toStringAsFixed(2)}',
                  //       style: GoogleFonts.outfit(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Discount Row (if applicable)
                  if (discount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.green.shade600,
                          ),
                        ),
                        Text(
                          '- ₹${discount.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // const Divider(height: 24),

                  // Total Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${localSubtotal.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColorStudent(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (isPlacing || isCalculating || cartItems.isEmpty)
                              ? null
                              : () async {
                                await productController.fetchTotalFromApi();
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColorStudent(context),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child:
                          isPlacing
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Place Order',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
