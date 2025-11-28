import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/view/pages/product/controller/product_controller.dart';
import 'package:kalapi/view/pages/product/widget/common_quntity.dart';

class CartCheckoutView extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;

  const CartCheckoutView({super.key, required this.orderItems});

  @override
  State<CartCheckoutView> createState() => _CartCheckoutViewState();
}

class _CartCheckoutViewState extends State<CartCheckoutView> {
  late List<Map<String, dynamic>> items;

  bool _placing = false;
  bool loadingTotal = false;

  final ProductController productController = Get.put(ProductController());
  dynamic apiTotal = 0;

  @override
  void initState() {
    super.initState();

    // Convert selected items into editable list
    items = widget.orderItems.map((e) => Map<String, dynamic>.from(e)).toList();

    // Initialize shared controller state for these items so other screens reflect quantities
    for (final it in items) {
      final pid = it['productId'] as int;
      final qty = (it['quantity'] as int?) ?? 1;
      productController.cartSelected[pid] = true;
      productController.cartQuantities[pid] = qty;
    }
    productController.cartSelected.refresh();
    productController.cartQuantities.refresh();

    // Get first API total
    _fetchTotalFromApi();
  }

  // --------------------------------------------
  //   API TOTAL CALCULATION
  // --------------------------------------------
  Future<void> _fetchTotalFromApi() async {
    loadingTotal = true;
    setState(() {});

    var branchId = pref.read("branchId") ?? 0;

    final body = {
      "orderId": null,
      "branchId": branchId,
      "orderDate": null,
      "orderDetails":
          items.map((it) {
            return {"productId": it["productId"], "quantity": it["quantity"]};
          }).toList(),
    };

    await productController.checkOutApiCall(
      body: body,
      onSuccess: () {
        apiTotal = productController.checkOutResponses.value.totalAmount ?? 0.0;
        loadingTotal = false;
        setState(() {});
      },
    );
  }

  // --------------------------------------------
  //   PLACE ORDER
  // --------------------------------------------
  Future<void> _placeOrder() async {
    setState(() => _placing = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final response = {
      "code": 200,
      "message": "Order created successfully.",
      "orderId": 8,
      "totalAmount": apiTotal, // API TOTAL
    };

    setState(() => _placing = false);

    Get.toNamed('/order_confirmation', arguments: response);
  }

  // --------------------------------------------
  //   UI BUILD
  // --------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final it = items[i];
                final name = it['productName'] ?? "Product ${it['productId']}";
                final weight = it['weight'] ?? "";
                final price = (it['price'] as num?)?.toDouble() ?? 0.0;
                final qty = it['quantity'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              weight,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "₹${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      QuantityButton(
                        quantity: qty,
                        onIncrement: () async {
                          items[i]['quantity'] =
                              (items[i]['quantity'] as int? ?? 0) + 1;
                          // sync to shared controller
                          final pid = items[i]['productId'] as int;
                          productController.setCartQuantity(
                            pid,
                            items[i]['quantity'] as int,
                          );
                          setState(() {});
                          // await _fetchTotalFromApi();
                        },
                        onDecrement: () async {
                          final cur = items[i]['quantity'] as int? ?? 1;

                          if (cur > 1) {
                            items[i]['quantity'] = cur - 1;
                            final pid = items[i]['productId'] as int;
                            productController.setCartQuantity(
                              pid,
                              items[i]['quantity'] as int,
                            );
                          } else {
                            // REMOVE ITEM WHEN QUANTITY REACHES 0
                            final pid = items[i]['productId'] as int;
                            productController.setCartQuantity(pid, 0);
                            items.removeAt(i);
                          }

                          setState(() {});

                          if (items.isEmpty) {
                            apiTotal = 0;
                            setState(() {});
                            return;
                          }

                          // await _fetchTotalFromApi();
                        },
                        bgColor: Colors.grey.shade200,
                        iconColor: Colors.black,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --------------------------------------------
          //   BOTTOM SUMMARY CARD
          // --------------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    loadingTotal
                        ? const Text(
                          "Calculating...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                        : Text(
                          "₹${apiTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placing || loadingTotal ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child:
                        _placing
                            ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "Place Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
