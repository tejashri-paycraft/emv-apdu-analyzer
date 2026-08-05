import 'package:flutter/material.dart';

import '../models/apdu_log.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class CommandDetailsPanel extends StatelessWidget {
  final ApduLog log;

  const CommandDetailsPanel({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return CommonPanel(
      title: "Command Details",
      // trailing: IconButton(
      //   tooltip: "Copy Command",
      //   icon: const Icon(Icons.copy, size: 20),
      //   onPressed: () {
      //     Clipboard.setData(ClipboardData(text: log.command));
      //
      //     ScaffoldMessenger.of(
      //       context,
      //     ).showSnackBar(const SnackBar(content: Text("Command copied")));
      //   },
      // ),
      height: 290,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------
            // CLA INS P1 P2 LC
            //------------------------------------
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _chip("CLA", log.cla),
                _chip("INS", log.ins),
                _chip("P1", log.p1),
                _chip("P2", log.p2),
                _chip("Lc", log.lc),
                _chip("Data", log.data),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Data Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: SelectableText(
                _ascii(log.data),
                style: const TextStyle(
                  fontFamily: "monospace",
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------

  Widget _chip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: AppTheme.subtitle, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  //---------------------------------------------------------

  String _formatHex(String hex) {
    if (hex.isEmpty) return "-";

    final buffer = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      buffer.write(hex.substring(i, i + 2));
      buffer.write(" ");

      if (((i ~/ 2) + 1) % 8 == 0) {
        buffer.write("\n");
      }
    }

    return buffer.toString();
  }

  //---------------------------------------------------------

  String _ascii(String hex) {
    if (hex.isEmpty) return "-";

    try {
      final buffer = StringBuffer();

      for (int i = 0; i < hex.length; i += 2) {
        final c = int.parse(hex.substring(i, i + 2), radix: 16);

        if (c >= 32 && c <= 126) {
          buffer.write(String.fromCharCode(c));
        }
      }

      return buffer.isEmpty ? hex : buffer.toString();
    } catch (_) {
      return hex;
    }
  }
}
