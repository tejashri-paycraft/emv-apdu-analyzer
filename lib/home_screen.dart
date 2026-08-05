import 'package:flutter/material.dart';

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
import 'widgets/status_panel.dart';
import 'widgets/tag_inspector_panel.dart';
import 'widgets/tlv_tree_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  List<ApduLog> logs = [];

  int selectedIndex = 0;

  TlvNode? selectedTag;

  //------------------------------------------------------------

  void parseLogs() {
    final result = LogParser.parse(controller.text);

    setState(() {
      logs = result;
      selectedIndex = 0;
      selectedTag = null;
    });
  }

  //------------------------------------------------------------

  ApduLog? get selectedLog {
    if (logs.isEmpty) return null;
    return logs[selectedIndex];
  }

  //------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: Row(
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
                // MAIN CONTENT
                //--------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        //--------------------------------------------------
                        // INPUT PANEL
                        //--------------------------------------------------
                        LogInputPanel(
                          controller: controller,
                          onParse: parseLogs,
                          onClear: () {
                            controller.clear();

                            setState(() {
                              logs.clear();
                              selectedTag = null;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        if (selectedLog != null)
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //--------------------------------------------------
                                // CENTER COLUMN
                                //--------------------------------------------------
                                Expanded(
                                  flex: 3,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //--------------------------------------------------
                                        // Selected Command Header
                                        //--------------------------------------------------
                                        SelectedCommandHeader(
                                          log: selectedLog!,
                                          index: selectedIndex,
                                        ),

                                        const SizedBox(height: 16),

                                        //--------------------------------------------------
                                        // Command Details
                                        //--------------------------------------------------
                                        CommandDetailsPanel(log: selectedLog!),

                                        const SizedBox(height: 16),

                                        //--------------------------------------------------
                                        // Raw Command
                                        //--------------------------------------------------
                                        // SizedBox(
                                        //   height: 260,
                                        //   child: RawCommandPanel(
                                        //     log: selectedLog!,
                                        //   ),
                                        // ),

                                        // const SizedBox(height: 16),

                                        //--------------------------------------------------
                                        // Raw Response
                                        //--------------------------------------------------
                                        // SizedBox(
                                        //   height: 300,
                                        //   child: RawResponsePanel(
                                        //     log: selectedLog!,
                                        //   ),
                                        // ),
                                        const SizedBox(height: 16),

                                        //--------------------------------------------------
                                        // TLV Tree
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

                                const SizedBox(width: 16),

                                //--------------------------------------------------
                                // RIGHT PANEL
                                //--------------------------------------------------
                                SizedBox(
                                  width: 340,
                                  child: Column(
                                    children: [
                                      //--------------------------------------------------
                                      // Status
                                      //--------------------------------------------------
                                      Expanded(
                                        flex: 2,
                                        child: StatusPanel(log: selectedLog!),
                                      ),

                                      const SizedBox(height: 16),

                                      //--------------------------------------------------
                                      // Tag Inspector
                                      //--------------------------------------------------
                                      Expanded(
                                        flex: 5,
                                        child: TagInspectorPanel(
                                          node: selectedTag,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
