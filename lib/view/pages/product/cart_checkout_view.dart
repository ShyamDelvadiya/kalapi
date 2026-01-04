import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/widget/common_quntity.dart';

class CartCheckoutView extends StatelessWidget {
  const CartCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    // Calculate initial totals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.calculateLocalSubtotal();
      // productController.fetchTotalFromApi();
    });

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
                  final qty = item['quantity'] as int;

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
                    child: Row(
                      children: [
                        // Product Avatar
                        Container(
                          width: 50,
                          height: 50,
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Product Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                weight,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${price.toStringAsFixed(2)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColorStudent(context),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Controls
                        QuantityButton(
                          quantity: qty,
                          onIncrement: () async {
                            productController.setCartQuantity(
                              productId,
                              qty + 1,
                            );
                            // Update local subtotal only. Final API calculation
                            // for the order will be performed when placing the order.
                            productController.calculateLocalSubtotal();
                          },
                          onDecrement: () async {
                            if (qty > 1) {
                              productController.setCartQuantity(
                                productId,
                                qty - 1,
                              );
                            } else {
                              // Remove item from cart
                              productController.setCartQuantity(productId, 0);
                            }
                            // Update local subtotal only. Final API calculation
                            // for the order will be performed when placing the order.
                            productController.calculateLocalSubtotal();
                          },
                          bgColor: Colors.grey.shade200,
                          iconColor: Colors.black,
                          textColor: Colors.black,
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
                      isCalculating
                          ? Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColorStudent(context),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Calculating...',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                          : Text(
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
