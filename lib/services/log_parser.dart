import '../models/apdu_log.dart';

class LogParser {
  /// Parses APDU log text into a list of ApduLog objects.
  ///
  /// Supports logs like:
  ///
  /// Command: 00A404000E325041592E5359532E444446303100
  /// Response: 6F42840E325041592E5359532E44444630319000
  ///
  /// Command: 80A8000023....
  /// Response: 778182190094109000
  ///
  static List<ApduLog> parse(String text) {
    final List<ApduLog> logs = [];

    if (text.trim().isEmpty) {
      return logs;
    }

    // Normalize line endings
    final lines = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n');

    String? command;
    String? response;

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty) continue;

      if (line.toUpperCase().startsWith("COMMAND:")) {
        command = line.substring(8).trim();
      } else if (line.toUpperCase().startsWith("RESPONSE:")) {
        response = line.substring(9).trim();

        if (command != null) {
          logs.add(ApduLog(command: command, response: response));

          command = null;
          response = null;
        }
      }
    }

    return logs;
  }

  /// Pretty print hex into spaced bytes.
  ///
  /// Example:
  /// 00A40400
  /// =>
  /// 00 A4 04 00
  static String formatHex(String hex) {
    hex = hex.replaceAll(' ', '');

    final buffer = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      if (i + 2 <= hex.length) {
        buffer.write(hex.substring(i, i + 2));

        if (i + 2 < hex.length) {
          buffer.write(' ');
        }
      }
    }

    return buffer.toString();
  }

  /// Convert printable ASCII from hex.
  ///
  /// Example:
  /// 32504159
  /// =>
  /// 2PAY
  static String hexToAscii(String hex) {
    hex = hex.replaceAll(' ', '');

    final buffer = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      if (i + 2 > hex.length) break;

      final value = int.parse(hex.substring(i, i + 2), radix: 16);

      if (value >= 32 && value <= 126) {
        buffer.write(String.fromCharCode(value));
      } else {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}
