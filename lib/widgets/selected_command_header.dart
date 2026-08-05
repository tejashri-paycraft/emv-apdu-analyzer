import 'package:flutter/material.dart';

import '../models/apdu_log.dart';
import '../theme/app_theme.dart';

class SelectedCommandHeader extends StatelessWidget {
  final ApduLog log;
  final int index;

  const SelectedCommandHeader({
    super.key,
    required this.log,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.primary,
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.commandName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: const TextStyle(color: AppTheme.subtitle),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: log.statusWord == "9000"
                  ? Colors.green.withOpacity(.15)
                  : Colors.red.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  log.statusWord == "9000" ? Icons.check_circle : Icons.error,
                  size: 18,
                  color: log.statusWord == "9000" ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  log.statusWord,
                  style: TextStyle(
                    color: log.statusWord == "9000" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
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
