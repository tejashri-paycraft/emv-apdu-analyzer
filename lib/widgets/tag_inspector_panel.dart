import 'package:flutter/material.dart';

import '../models/tlv_node.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class TagInspectorPanel extends StatelessWidget {
  final TlvNode? node;

  const TagInspectorPanel({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return CommonPanel(
      title: "Tag Inspector",
      child: node == null
          ? const Center(
              child: Text(
                "Select any TLV tag",
                style: TextStyle(color: AppTheme.subtitle, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------
                  // TAG
                  //------------------------------------------
                  _title("Tag"),

                  _valueChip(node!.tag),

                  const SizedBox(height: 20),

                  //------------------------------------------
                  // DESCRIPTION
                  //------------------------------------------
                  _title("Description"),

                  Text(node!.description, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 20),

                  //------------------------------------------
                  // LENGTH
                  //------------------------------------------
                  _title("Length"),

                  _valueChip("${node!.length} Bytes"),

                  const SizedBox(height: 20),

                  //------------------------------------------
                  // ASCII
                  //------------------------------------------
                  _title("ASCII Value"),

                  _codeBox(_ascii(node!.value)),

                  const SizedBox(height: 20),

                  //------------------------------------------
                  // HEX
                  //------------------------------------------
                  _title("HEX Value"),

                  _codeBox(_format(node!.value)),

                  const SizedBox(height: 20),

                  //------------------------------------------
                  // EMV Meaning
                  //------------------------------------------
                  _title("EMV Meaning"),

                  Text(
                    _meaning(node!.tag),
                    style: const TextStyle(
                      color: AppTheme.subtitle,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _valueChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.indigoAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _codeBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: SelectableText(
        value,
        style: const TextStyle(
          fontFamily: "monospace",
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

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

      return buffer.isEmpty ? "-" : buffer.toString();
    } catch (_) {
      return "-";
    }
  }

  String _format(String hex) {
    if (hex.isEmpty) return "-";

    final buffer = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      buffer.write("${hex.substring(i, i + 2)} ");

      if (((i ~/ 2) + 1) % 8 == 0) {
        buffer.write("\n");
      }
    }

    return buffer.toString();
  }

  String _meaning(String tag) {
    switch (tag) {
      case "6F":
        return "File Control Information template returned after SELECT command.";

      case "84":
        return "Dedicated File Name (DF Name).";

      case "A5":
        return "FCI Proprietary Template.";

      case "BF0C":
        return "Issuer Discretionary Data.";

      case "61":
        return "Application Template.";

      case "4F":
        return "Application Identifier (AID).";

      case "50":
        return "Application Label displayed to cardholder.";

      case "57":
        return "Track-2 Equivalent Data.";

      case "5A":
        return "Primary Account Number (PAN).";

      case "82":
        return "Application Interchange Profile.";

      case "87":
        return "Application Priority Indicator.";

      case "94":
        return "Application File Locator.";

      case "9F10":
        return "Issuer Application Data.";

      case "9F12":
        return "Application Preferred Name.";

      case "9F26":
        return "Application Cryptogram.";

      case "9F36":
        return "Application Transaction Counter.";

      case "9F38":
        return "Processing Options Data Object List (PDOL).";

      default:
        return "No EMV description available.";
    }
  }
}
