class DolField {
  /// EMV Tag
  final String tag;

  /// Length in bytes
  final int length;

  /// Raw value (Hex)
  final String value;

  const DolField({
    required this.tag,
    required this.length,
    required this.value,
  });

  @override
  String toString() {
    return "$tag ($length) : $value";
  }
}
