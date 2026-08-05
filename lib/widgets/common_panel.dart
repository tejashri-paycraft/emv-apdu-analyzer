import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CommonPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final double? height;

  const CommonPanel({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          //-----------------------------------
          // Header
          //-----------------------------------
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                if (trailing != null) trailing!,
              ],
            ),
          ),

          //-----------------------------------
          // Body
          //-----------------------------------
          Expanded(
            child: Padding(padding: const EdgeInsets.all(14), child: child),
          ),
        ],
      ),
    );
  }
}
