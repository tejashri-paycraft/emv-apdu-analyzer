import '../models/dol_field.dart';

class DolParser {
  /// Parse DOL definition (PDOL/CDOL1/CDOL2)
  ///
  /// Example:
  /// 9F33039F1A029505
  ///
  /// =>
  /// 9F33 Length 3
  /// 9F1A Length 2
  /// 95    Length 5
  static List<MapEntry<String, int>> parseDefinition(String hex) {
    final result = <MapEntry<String, int>>[];

    if (hex.isEmpty) {
      return result;
    }

    int index = 0;

    while (index < hex.length) {
      //------------------------------------
      // Parse Tag
      //------------------------------------

      String tag = hex.substring(index, index + 2);
      index += 2;

      // Multi-byte tag
      if ((int.parse(tag, radix: 16) & 0x1F) == 0x1F) {
        while (index < hex.length) {
          final next = hex.substring(index, index + 2);

          tag += next;
          index += 2;

          if ((int.parse(next, radix: 16) & 0x80) == 0) {
            break;
          }
        }
      }

      //------------------------------------
      // Length
      //------------------------------------

      if (index >= hex.length) {
        break;
      }

      final length = int.parse(hex.substring(index, index + 2), radix: 16);

      index += 2;

      result.add(MapEntry(tag, length));
    }

    return result;
  }

  //------------------------------------------------------------
  // Parse DOL Data
  //------------------------------------------------------------

  static List<DolField> parseData({
    required List<MapEntry<String, int>> definition,
    required String data,
  }) {
    final fields = <DolField>[];

    int offset = 0;

    for (final item in definition) {
      final bytes = item.value * 2;

      if (offset + bytes > data.length) {
        break;
      }

      fields.add(
        DolField(
          tag: item.key,
          length: item.value,
          value: data.substring(offset, offset + bytes),
        ),
      );

      offset += bytes;
    }

    return fields;
  }

  //------------------------------------------------------------
  // Parse GPO Command
  //------------------------------------------------------------

  static List<DolField> parseGpo({
    required String pdolDefinition,
    required String command,
  }) {
    final definition = parseDefinition(pdolDefinition);

    // Remove CLA INS P1 P2 Lc
    String body = command.substring(10);

    // Expect 83
    if (!body.startsWith("83")) {
      return [];
    }

    body = body.substring(2);

    if (body.length < 2) {
      return [];
    }

    // Length
    final length = int.parse(body.substring(0, 2), radix: 16);

    body = body.substring(2);

    final pdolData = body.substring(0, length * 2);

    return parseData(definition: definition, data: pdolData);
  }

  //------------------------------------------------------------
  // Parse Generate AC
  //------------------------------------------------------------

  static List<DolField> parseGenerateAc({
    required String cdolDefinition,
    required String command,
  }) {
    final definition = parseDefinition(cdolDefinition);

    // Remove CLA INS P1 P2 Lc
    String body = command.substring(10);

    // Remove trailing Le
    if (body.endsWith("00")) {
      body = body.substring(0, body.length - 2);
    }

    return parseData(definition: definition, data: body);
  }

  //------------------------------------------------------------
  // Pretty Print
  //------------------------------------------------------------

  static String prettyPrint(List<DolField> fields) {
    final buffer = StringBuffer();

    for (final field in fields) {
      buffer.writeln(
        "${field.tag.padRight(8)}"
        "${field.length.toString().padRight(4)}"
        "${field.value}",
      );
    }

    return buffer.toString();
  }
}
