import 'package:flutter/material.dart';

/// A reusable, beautiful custom app bar with gradient background and rounded bottom.
///
/// Usage:
///   appBar: customAppBar(context, title: 'Home', actions: [ ... ])
PreferredSizeWidget customAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  Widget? leading,
}) {
  final theme = Theme.of(context);

  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight + 12),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight + 8,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:
                    leading ??
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.menu, color: Colors.white),
                    ),
              ),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              // Actions
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: actions),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
