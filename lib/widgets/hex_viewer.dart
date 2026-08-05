import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HexViewer extends StatelessWidget {
  final String hex;

  const HexViewer({super.key, required this.hex});

  @override
  Widget build(BuildContext context) {
    final rows = _rows(hex);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (_, index) {
          final row = rows[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade900)),
            ),
            child: Row(
              children: [
                //--------------------------------
                // Offset
                //--------------------------------
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

                //--------------------------------
                // HEX
                //--------------------------------
                Expanded(
                  flex: 3,
                  child: SelectableText(
                    row.hex,
                    style: const TextStyle(
                      fontFamily: "monospace",
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),

                //--------------------------------
                // ASCII
                //--------------------------------
                Expanded(
                  child: SelectableText(
                    row.ascii,
                    style: const TextStyle(
                      fontFamily: "monospace",
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        final byte = chunk.substring(j, j + 2);

        bytes.add(byte);

        final value = int.parse(byte, radix: 16);

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
