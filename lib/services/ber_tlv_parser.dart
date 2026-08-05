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

  //------------------------------------
  // Constructed tag
  //------------------------------------

  static bool _isConstructed(String tag) {
    int firstByte = int.parse(tag.substring(0, 2), radix: 16);

    return (firstByte & 0x20) == 0x20;
  }

  //------------------------------------
  // EMV descriptions
  //------------------------------------

  static String _description(String tag) {
    switch (tag) {
      case "6F":
        return "File Control Information";

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
        return "PAN";

      case "5F24":
        return "Application Expiry Date";

      case "5F25":
        return "Application Effective Date";

      case "5F2D":
        return "Language Preference";

      case "5F20":
        return "Cardholder Name";

      case "5F34":
        return "PAN Sequence Number";

      case "82":
        return "Application Interchange Profile";

      case "87":
        return "Application Priority";

      case "88":
        return "Short File Identifier";

      case "8C":
        return "CDOL1";

      case "8D":
        return "CDOL2";

      case "8E":
        return "Cardholder Verification Method";

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

      case "9F38":
        return "PDOL";

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
