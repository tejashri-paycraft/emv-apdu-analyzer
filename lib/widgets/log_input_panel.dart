import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'common_panel.dart';

class LogInputPanel extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onParse;
  final VoidCallback onClear;

  const LogInputPanel({
    super.key,
    required this.controller,
    required this.onParse,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CommonPanel(
      title: "APDU Log Input",
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.clear, size: 18),
            label: const Text("Clear"),
          ),

          const SizedBox(width: 10),

          ElevatedButton.icon(
            onPressed: onParse,
            icon: const Icon(Icons.play_arrow),
            label: const Text("Parse"),
          ),
        ],
      ),
      height: 290,
      child: Row(
        children: [
          //------------------------------------------
          // Line Numbers
          //------------------------------------------
          Container(
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xff111827),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "${index + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.subtitle,
                      fontFamily: "monospace",
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          //------------------------------------------
          // Text Editor
          //------------------------------------------
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: TextField(
                controller: controller,
                expands: true,
                maxLines: null,
                minLines: null,
                style: const TextStyle(
                  fontFamily: "monospace",
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText:
                      "Paste APDU logs here...\n\n"
                      "Command: 00A404000E325041592E5359532E444446303100\n"
                      "Response: 6F42840E325041592E5359532E44444630319000",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: "monospace",
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
