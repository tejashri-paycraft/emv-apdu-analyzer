import '../models/tlv_node.dart';

class BerTlvParser {
  /// Parse complete TLV response
  static List<TlvNode> parse(String hex) {
    hex = hex.replaceAll(" ", "").toUpperCase();

    final nodes = <TlvNode>[];

    int index = 0;

    while (index < hex.length) {
      final result = _parseNode(hex, index);

      nodes.add(result.node);

      index = result.nextIndex;
    }

    return nodes;
  }

  //----------------------------------------------------------
  // Find first occurrence of a tag
  //----------------------------------------------------------

  static TlvNode? findTag(List<TlvNode> nodes, String tag) {
    for (final node in nodes) {
      if (node.tag.toUpperCase() == tag.toUpperCase()) {
        return node;
      }

      final child = findTag(node.children, tag);

      if (child != null) {
        return child;
      }
    }

    return null;
  }

  //----------------------------------------------------------
  // Find all occurrences of a tag
  //----------------------------------------------------------

  static List<TlvNode> findTags(List<TlvNode> nodes, String tag) {
    final result = <TlvNode>[];

    void walk(List<TlvNode> list) {
      for (final node in list) {
        if (node.tag.toUpperCase() == tag.toUpperCase()) {
          result.add(node);
        }

        walk(node.children);
      }
    }

    walk(nodes);

    return result;
  }

  //----------------------------------------------------------
  // Flatten complete TLV tree
  //----------------------------------------------------------

  static List<TlvNode> flatten(List<TlvNode> nodes) {
    final result = <TlvNode>[];

    void walk(List<TlvNode> list) {
      for (final node in list) {
        result.add(node);

        walk(node.children);
      }
    }

    walk(nodes);

    return result;
  }

  //----------------------------------------------------------
  // Parse single TLV node
  //----------------------------------------------------------

  static _ParseResult _parseNode(String hex, int start) {
    int index = start;

    //------------------------------------
    // TAG
    //------------------------------------

    String tag = hex.substring(index, index + 2);
    index += 2;

    int firstByte = int.parse(tag, radix: 16);

    // Multi-byte tag
    if ((firstByte & 0x1F) == 0x1F) {
      while (true) {
        String next = hex.substring(index, index + 2);

        tag += next;

        index += 2;

        int b = int.parse(next, radix: 16);

        if ((b & 0x80) == 0) {
          break;
        }
      }
    }

    //------------------------------------
    // LENGTH
    //------------------------------------

    String lengthByteHex = hex.substring(index, index + 2);

    index += 2;

    int lengthByte = int.parse(lengthByteHex, radix: 16);

    int valueLength = 0;

    if ((lengthByte & 0x80) == 0) {
      valueLength = lengthByte;
    } else {
      int numberOfBytes = lengthByte & 0x7F;

      String lengthHex = "";

      for (int i = 0; i < numberOfBytes; i++) {
        lengthHex += hex.substring(index, index + 2);

        index += 2;
      }

      valueLength = int.parse(lengthHex, radix: 16);
    }

    //------------------------------------
    // VALUE
    //------------------------------------

    int valueChars = valueLength * 2;

    String value = "";

    if (index + valueChars <= hex.length) {
      value = hex.substring(index, index + valueChars);
    }

    index += valueChars;

    //------------------------------------
    // Constructed ?
    //------------------------------------

    bool constructed = _isConstructed(tag);

    List<TlvNode> children = [];

    if (constructed && value.isNotEmpty) {
      children = parse(value);
    }

    return _ParseResult(
      TlvNode(
        tag: tag,
        length: valueLength,
        value: value,
        description: _description(tag),
        children: children,
      ),
      index,
    );
  }

  //----------------------------------------------------------
  // Constructed tag
  //----------------------------------------------------------

  static bool _isConstructed(String tag) {
    int firstByte = int.parse(tag.substring(0, 2), radix: 16);

    return (firstByte & 0x20) == 0x20;
  }

  //----------------------------------------------------------
  // EMV descriptions
  //----------------------------------------------------------

  static String _description(String tag) {
    switch (tag) {
      case "6F":
        return "File Control Information";

      case "70":
        return "Record Template";

      case "77":
        return "Response Message Template Format 2";

      case "80":
        return "Response Message Template Format 1";

      case "84":
        return "Dedicated File Name";

      case "A5":
        return "FCI Proprietary Template";

      case "BF0C":
        return "FCI Issuer Discretionary Data";

      case "61":
        return "Application Template";

      case "4F":
        return "Application Identifier";

      case "50":
        return "Application Label";

      case "57":
        return "Track 2 Equivalent Data";

      case "5A":
        return "Application PAN";

      case "5F20":
        return "Cardholder Name";

      case "5F24":
        return "Application Expiry Date";

      case "5F25":
        return "Application Effective Date";

      case "5F2D":
        return "Language Preference";

      case "5F34":
        return "PAN Sequence Number";

      case "82":
        return "Application Interchange Profile";

      case "87":
        return "Application Priority Indicator";

      case "88":
        return "Short File Identifier";

      case "8A":
        return "Authorisation Response Code";

      case "8C":
        return "Card Risk Management Data Object List 1 (CDOL1)";

      case "8D":
        return "Card Risk Management Data Object List 2 (CDOL2)";

      case "8E":
        return "Cardholder Verification Method List";

      case "94":
        return "Application File Locator";

      case "95":
        return "Terminal Verification Results";

      case "9F10":
        return "Issuer Application Data";

      case "9F12":
        return "Application Preferred Name";

      case "9F26":
        return "Application Cryptogram";

      case "9F27":
        return "Cryptogram Information Data";

      case "9F36":
        return "Application Transaction Counter";

      case "9F37":
        return "Unpredictable Number";

      case "9F38":
        return "Processing Options Data Object List (PDOL)";

      case "9F33":
        return "Terminal Capabilities";

      case "9F34":
        return "Cardholder Verification Method Results";

      case "9F35":
        return "Terminal Type";

      case "9F40":
        return "Additional Terminal Capabilities";

      case "9F02":
        return "Amount Authorised";

      case "9F03":
        return "Amount Other";

      case "9F1A":
        return "Terminal Country Code";

      case "9F1C":
        return "Terminal Identification";

      case "9F21":
        return "Transaction Time";

      case "9A":
        return "Transaction Date";

      default:
        return "Unknown Tag";
    }
  }
}

class _ParseResult {
  final TlvNode node;

  final int nextIndex;

  _ParseResult(this.node, this.nextIndex);
}
