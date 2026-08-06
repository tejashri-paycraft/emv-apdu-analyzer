import 'package:flutter/material.dart';
import 'package:tlv_parser/services/emv_transaction_parse.dart'
    show EmvTransactionParser;

import 'models/apdu_log.dart';
import 'models/tlv_node.dart';
import 'services/ber_tlv_parser.dart';
import 'services/log_parser.dart';
import 'theme/app_theme.dart';
import 'widgets/app_header.dart';
import 'widgets/command_details_panel.dart';
import 'widgets/left_panel.dart';
import 'widgets/log_input_panel.dart';
import 'widgets/selected_command_header.dart';
import 'widgets/tag_inspector_panel.dart';
import 'widgets/tlv_tree_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final EmvTransactionParser transactionParser = EmvTransactionParser();
  List<ApduLog> logs = [];

  int selectedIndex = 0;

  TlvNode? selectedTag;

  //--------------------------------------------------------------

  void parseLogs() {
    final result = LogParser.parse(controller.text);

    transactionParser.parse(result);

    setState(() {
      logs = result;
      selectedIndex = 0;
      selectedTag = null;
    });
  }

  //--------------------------------------------------------------

  ApduLog? get selectedLog {
    if (logs.isEmpty) return null;
    return logs[selectedIndex];
  }

  //--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //--------------------------------------------------
                // LEFT PANEL
                //--------------------------------------------------
                LeftPanel(
                  logs: logs,
                  selectedIndex: selectedIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                      selectedTag = null;
                    });
                  },
                ),

                //--------------------------------------------------
                // CENTER PANEL
                //--------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        //--------------------------------------------------
                        // APDU INPUT
                        //--------------------------------------------------
                        LogInputPanel(
                          controller: controller,
                          onParse: parseLogs,
                          onClear: () {
                            controller.clear();

                            transactionParser.parse([]);

                            setState(() {
                              logs.clear();
                              selectedTag = null;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        if (selectedLog != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //--------------------------------------------------
                                  // SELECTED COMMAND HEADER
                                  //--------------------------------------------------
                                  SelectedCommandHeader(
                                    log: selectedLog!,
                                    index: selectedIndex,
                                  ),

                                  const SizedBox(height: 16),

                                  //--------------------------------------------------
                                  // COMMAND DETAILS
                                  //--------------------------------------------------
                                  CommandDetailsPanel(
                                    log: selectedLog!,
                                    parsedFields: transactionParser.fieldsFor(
                                      selectedIndex,
                                    ),
                                    parsedTitle: transactionParser.typeFor(
                                      selectedIndex,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  //--------------------------------------------------
                                  // TLV TREE
                                  //--------------------------------------------------
                                  SizedBox(
                                    height: 500,
                                    child: TlvTreePanel(
                                      nodes: BerTlvParser.parse(
                                        selectedLog!.responseData,
                                      ),
                                      onNodeSelected: (node) {
                                        setState(() {
                                          selectedTag = node;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                //--------------------------------------------------
                // RIGHT PANEL
                //--------------------------------------------------
                Container(
                  width: 340,
                  decoration: const BoxDecoration(
                    color: AppTheme.panel,
                    border: Border(left: BorderSide(color: AppTheme.border)),
                  ),
                  child: TagInspectorPanel(node: selectedTag),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
