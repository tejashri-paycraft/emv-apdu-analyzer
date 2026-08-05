import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/apdu_log.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class RawResponsePanel extends StatelessWidget {
  final ApduLog log;

  const RawResponsePanel({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final rows = _rows(log.responseData);

    return CommonPanel(
      title: "Raw Response",
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: log.statusWord == "9000"
                  ? Colors.green.withOpacity(.15)
                  : Colors.red.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              log.statusWord,
              style: TextStyle(
                color: log.statusWord == "9000" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: log.response));

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Response copied")));
            },
          ),
        ],
      ),
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff111827),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Text(
                    "Length : ${(log.responseData.length / 2).toInt()} Bytes",
                    style: const TextStyle(color: AppTheme.subtitle),
                  ),

                  const Spacer(),

                  Text(
                    log.statusDescription,
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (_, index) {
                  final row = rows[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade900),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            row.offset,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontFamily: "monospace",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: SelectableText(
                            row.hex,
                            style: const TextStyle(
                              fontFamily: "monospace",
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            row.ascii,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: "monospace",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_HexRow> _rows(String hex) {
    final rows = <_HexRow>[];

    for (int i = 0; i < hex.length; i += 32) {
      final chunk = hex.substring(i, i + 32 > hex.length ? hex.length : i + 32);

      final bytes = <String>[];
      final ascii = StringBuffer();

      for (int j = 0; j < chunk.length; j += 2) {
        final b = chunk.substring(j, j + 2);

        bytes.add(b);

        final value = int.parse(b, radix: 16);

        if (value >= 32 && value <= 126) {
          ascii.write(String.fromCharCode(value));
        } else {
          ascii.write(".");
        }
      }

      rows.add(
        _HexRow(
          offset: (i ~/ 2).toRadixString(16).padLeft(4, "0"),
          hex: bytes.join(" "),
          ascii: ascii.toString(),
        ),
      );
    }

    return rows;
  }
}

class _HexRow {
  final String offset;
  final String hex;
  final String ascii;

  _HexRow({required this.offset, required this.hex, required this.ascii});
}
