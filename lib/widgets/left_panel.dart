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
      width: 320,
      decoration: const BoxDecoration(
        color: AppTheme.panel,
        border: Border(right: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          //--------------------------------------------------
          // Header
          //--------------------------------------------------
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "APDU Exchanges",
                          style: TextStyle(
                            color: AppTheme.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: " (${logs.length})",
                          style: const TextStyle(
                            color: AppTheme.subtitle,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.filter_list_rounded,
                  color: AppTheme.subtitle,
                  size: 18,
                ),
              ],
            ),
          ),

          //--------------------------------------------------
          // APDU List
          //--------------------------------------------------
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      "No APDU Logs",
                      style: TextStyle(color: AppTheme.subtitle),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: logs.length,
                    itemBuilder: (_, index) {
                      final log = logs[index];
                      final selected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => onSelected(index),
                          child: Stack(
                            children: [
                              if (selected)
                                Positioned(
                                  left: 0,
                                  top: 8,
                                  bottom: 8,
                                  child: Container(
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.only(
                                  left: selected ? 7 : 0,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xff303851)
                                        : Color(0xff0F172A),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? Colors.white24
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //------------------------------------------------
                                      // Number
                                      //------------------------------------------------
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      //------------------------------------------------
                                      // Text
                                      //------------------------------------------------
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              log.commandName.toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppTheme.text,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            Text(
                                              _formatCommand(log.command),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xff8F97AF),
                                                fontSize: 12,
                                                fontFamily: "monospace",
                                                letterSpacing: .3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      //------------------------------------------------
                                      // Status
                                      //------------------------------------------------
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff14392F),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xff29D391),
                                          ),
                                        ),
                                        child: Text(
                                          log.statusWord,
                                          style: const TextStyle(
                                            color: Color(0xff56F0B0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          //--------------------------------------------------
          // Footer
          //--------------------------------------------------
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Text(
                  "Total: ${logs.length}",
                  style: const TextStyle(color: AppTheme.subtitle),
                ),
                const Spacer(),
                const Icon(Icons.check, color: AppTheme.success, size: 16),
                const SizedBox(width: 4),
                Text(
                  "${logs.where((e) => e.statusWord == "9000").length}",
                  style: const TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
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
    if (command.length <= 18) {
      return command;
    }

    return "${command.substring(0, 18)}...";
  }
}
