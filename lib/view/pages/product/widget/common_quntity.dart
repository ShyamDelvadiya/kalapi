import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color bgColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onQuantityTap;

  const QuantityButton({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.bgColor = const Color(0x22FFFFFF),
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.onQuantityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(Icons.remove, size: 18, color: iconColor),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onQuantityTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$quantity",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(Icons.add, size: 18, color: iconColor),
          ),
        ),
      ],
    );
  }
}
