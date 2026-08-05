import 'package:flutter/material.dart';

import '../models/tlv_node.dart';
import '../theme/app_theme.dart';
import 'common_panel.dart';

class TlvTreePanel extends StatelessWidget {
  final List<TlvNode> nodes;
  final Function(TlvNode)? onNodeSelected;

  const TlvTreePanel({super.key, required this.nodes, this.onNodeSelected});

  @override
  Widget build(BuildContext context) {
    return CommonPanel(
      title: "Parsed TLV Tree",
      child: nodes.isEmpty
          ? const Center(
              child: Text(
                "No TLV Data",
                style: TextStyle(color: AppTheme.subtitle),
              ),
            )
          : ListView(
              children: nodes
                  .map(
                    (e) => _TreeNodeWidget(
                      node: e,
                      level: 0,
                      onTap: onNodeSelected,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final TlvNode node;
  final int level;
  final Function(TlvNode)? onTap;

  const _TreeNodeWidget({required this.node, required this.level, this.onTap});

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final hasChild = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            // Only select the node.
            widget.onTap?.call(node);
          },
          child: Container(
            margin: EdgeInsets.only(left: widget.level * 20, bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //----------------------------------------------------------
                // Expand / Collapse Arrow
                //----------------------------------------------------------
                if (hasChild)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 22),

                //----------------------------------------------------------
                // Tag Icon
                //----------------------------------------------------------
                Icon(
                  hasChild ? Icons.folder_open : Icons.label,
                  color: hasChild ? Colors.orange : Colors.lightBlueAccent,
                  size: 18,
                ),

                const SizedBox(width: 8),

                //----------------------------------------------------------
                // Tag
                //----------------------------------------------------------
                SizedBox(
                  width: 55,
                  child: Text(
                    node.tag,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                //----------------------------------------------------------
                // Value
                //----------------------------------------------------------
                Expanded(
                  child: SelectableText(
                    node.value,
                    style: const TextStyle(color: AppTheme.subtitle),
                  ),
                ),

                const SizedBox(width: 10),

                //----------------------------------------------------------
                // Length Badge
                //----------------------------------------------------------
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${node.length} B",
                    style: const TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        //----------------------------------------------------------
        // Children
        //----------------------------------------------------------
        if (expanded)
          ...node.children.map(
            (child) => _TreeNodeWidget(
              node: child,
              level: widget.level + 1,
              onTap: widget.onTap,
            ),
          ),
      ],
    );
  }
}
