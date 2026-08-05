class TlvNode {
  /// Tag
  final String tag;

  /// Length in bytes
  final int length;

  /// Value in Hex
  final String value;

  /// EMV Description
  final String description;

  /// Child TLVs
  final List<TlvNode> children;

  TlvNode({
    required this.tag,
    required this.length,
    required this.value,
    required this.description,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;

  bool get isConstructed => children.isNotEmpty;

  /// Printable ASCII if available
  String get ascii {
    final buffer = StringBuffer();

    try {
      for (int i = 0; i < value.length; i += 2) {
        final code = int.parse(value.substring(i, i + 2), radix: 16);

        if (code >= 32 && code <= 126) {
          buffer.write(String.fromCharCode(code));
        }
      }
    } catch (_) {}

    return buffer.toString();
  }

  /// Pretty print tree
  String pretty([String indent = ""]) {
    final buffer = StringBuffer();

    buffer.writeln(
      "$indent$tag  $description"
      "${value.isNotEmpty ? " : $value" : ""}",
    );

    for (final child in children) {
      buffer.write(child.pretty("$indent   "));
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return pretty();
  }

  Map<String, dynamic> toJson() {
    return {
      "tag": tag,
      "length": length,
      "value": value,
      "ascii": ascii,
      "description": description,
      "children": children.map((e) => e.toJson()).toList(),
    };
  }
}
