import 'package:flutter/material.dart';

import '../models/apdu_log.dart';
import '../theme/app_theme.dart';

class LeftPanel extends StatelessWidget {
  final List<ApduLog> logs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const LeftPanel({
    super.key,
    required this.logs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: AppTheme.panel,
        border: Border(right: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          //------------------------------------------
          // Header
          //------------------------------------------
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Text(
                  "APDU Exchanges (${logs.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          //------------------------------------------
          // List
          //------------------------------------------
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      "No APDU Logs",
                      style: TextStyle(color: AppTheme.subtitle),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: logs.length,
                    itemBuilder: (_, index) {
                      final log = logs[index];

                      final selected = index == selectedIndex;

                      return GestureDetector(
                        onTap: () => onSelected(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xff263449)
                                : AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.border,
                              width: selected ? 1.4 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              //----------------------------------
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppTheme.primary,
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Text(
                                      log.commandName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppTheme.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.success.withOpacity(.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      log.statusWord,
                                      style: const TextStyle(
                                        color: AppTheme.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formatCommand(log.command),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppTheme.subtitle,
                                    fontSize: 12,
                                    fontFamily: "monospace",
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  selected
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppTheme.subtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          //------------------------------------------
          // Footer
          //------------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Text(
                  "Total : ${logs.length}",
                  style: const TextStyle(color: AppTheme.subtitle),
                ),
                const Spacer(),
                Text(
                  "✓ ${logs.where((e) => e.statusWord == "9000").length}",
                  style: const TextStyle(
                    color: AppTheme.success,
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

  String _formatCommand(String command) {
    if (command.length <= 34) {
      return command;
    }

    return "${command.substring(0, 34)}...";
  }
}
