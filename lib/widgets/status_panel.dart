import 'package:flutter/material.dart';

import '../models/apdu_log.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class StatusPanel extends StatelessWidget {
  final ApduLog log;

  const StatusPanel({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final bool success = log.statusWord == "9000";

    return CommonPanel(
      title: "Status:   ${success ? "SUCCESS" : "FAILED"}",
      height: 220,
      child: ListView(
        children: [
          //---------------------------------------------------------
          // Status Badge
          //---------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: success
                  ? Colors.green.withOpacity(.10)
                  : Colors.red.withOpacity(.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: success
                    ? Colors.green.withOpacity(.4)
                    : Colors.red.withOpacity(.4),
              ),
            ),
            child: Text(
              success
                  ? "✓ EMV Command Executed Successfully"
                  : "✗ EMV Command Failed",
              style: TextStyle(
                color: success ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _infoTile(title: "Status Word", value: log.statusWord),

          const Divider(color: AppTheme.border),

          _infoTile(title: "Description", value: log.statusDescription),

          const Divider(color: AppTheme.border),

          _infoTile(
            title: "Response Length",
            value: "${log.responseData.length ~/ 2} Bytes",
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------

  Widget _infoTile({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(color: AppTheme.subtitle),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
