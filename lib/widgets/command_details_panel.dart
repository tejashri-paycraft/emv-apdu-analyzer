import 'package:flutter/material.dart';

import '../models/apdu_log.dart';
import '../models/dol_field.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class CommandDetailsPanel extends StatelessWidget {
  final ApduLog log;

  /// Parsed GPO/CDOL fields
  final List<DolField> parsedFields;

  /// GPO (PDOL), GENERATE AC1 (CDOL1) etc.
  final String parsedTitle;

  const CommandDetailsPanel({
    super.key,
    required this.log,
    this.parsedFields = const [],
    this.parsedTitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return CommonPanel(
      title: "Command Details",
      height: 560,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------
            // CLA INS P1 P2 LC
            //----------------------------------------------------
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _chip("CLA", log.cla),
                _chip("INS", log.ins),
                _chip("P1", log.p1),
                _chip("P2", log.p2),
                _chip("Lc", log.lc),
              ],
            ),

            const SizedBox(height: 20),

            //----------------------------------------------------
            // Raw Data
            //----------------------------------------------------
            const Text("Data", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: SelectableText(
                _formatHex(log.data),
                style: const TextStyle(fontFamily: "monospace", height: 1.6),
              ),
            ),

            //----------------------------------------------------
            // Parsed DOL
            //----------------------------------------------------
            if (parsedFields.isNotEmpty) ...[
              const SizedBox(height: 24),

              Text(
                parsedTitle.isEmpty ? "Parsed Data" : parsedTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    //--------------------------------------------------
                    // Header
                    //--------------------------------------------------
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppTheme.border),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              "Tag",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Value",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //--------------------------------------------------
                    // Rows
                    //--------------------------------------------------
                    ...parsedFields.map(
                      (field) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.border,
                              width: .5,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: SelectableText(
                                field.tag,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "monospace",
                                ),
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                field.value,
                                style: const TextStyle(fontFamily: "monospace"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------

  Widget _chip(String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
          SelectableText(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "monospace",
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------

  String _formatHex(String hex) {
    if (hex.isEmpty) return "-";

    final buffer = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      if (i + 2 <= hex.length) {
        buffer.write(hex.substring(i, i + 2));

        if (i + 2 < hex.length) {
          buffer.write(" ");
        }
      }
    }

    return buffer.toString();
  }
}
