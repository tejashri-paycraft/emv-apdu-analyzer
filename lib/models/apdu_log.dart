class ApduLog {
  final String command;
  final String response;

  ApduLog({required this.command, required this.response});

  /// Command Name
  String get commandName {
    final cmd = command.toUpperCase();

    if (cmd.startsWith("00A40400")) {
      // PPSE
      if (cmd.contains("325041592E5359532E4444463031")) {
        return "SELECT PPSE";
      }

      return "SELECT APPLICATION";
    }

    if (cmd.startsWith("80A80000")) {
      return "GET PROCESSING OPTIONS";
    }

    if (cmd.startsWith("00B2")) {
      return "READ RECORD";
    }

    if (cmd.startsWith("80AE")) {
      return "GENERATE AC";
    }

    if (cmd.startsWith("80CA")) {
      return "GET DATA";
    }

    if (cmd.startsWith("80E2")) {
      return "STORE DATA";
    }

    return "UNKNOWN COMMAND";
  }

  /// Human Readable Description
  String get description {
    switch (commandName) {
      case "SELECT PPSE":
        return "Select Payment System Environment.";

      case "SELECT APPLICATION":
        return "Select payment application using AID.";

      case "GET PROCESSING OPTIONS":
        return "Retrieve AIP and AFL from ICC.";

      case "READ RECORD":
        return "Read record from application.";

      case "GENERATE AC":
        return "Generate Application Cryptogram.";

      case "GET DATA":
        return "Read data object.";

      case "STORE DATA":
        return "Store issuer script data.";

      default:
        return "Unknown APDU command.";
    }
  }

  /// CLA
  String get cla => command.length >= 2 ? command.substring(0, 2) : "";

  /// INS
  String get ins => command.length >= 4 ? command.substring(2, 4) : "";

  /// P1
  String get p1 => command.length >= 6 ? command.substring(4, 6) : "";

  /// P2
  String get p2 => command.length >= 8 ? command.substring(6, 8) : "";

  /// LC
  String get lc => command.length >= 10 ? command.substring(8, 10) : "";

  /// Command Data
  String get data {
    if (command.length <= 10) return "";

    return command.substring(10);
  }

  /// Status Word
  String get statusWord {
    if (response.length < 4) {
      return "";
    }

    return response.substring(response.length - 4);
  }

  /// Status Description
  String get statusDescription {
    switch (statusWord.toUpperCase()) {
      case "9000":
        return "Success";

      case "6985":
        return "Conditions Not Satisfied";

      case "6982":
        return "Security Status Not Satisfied";

      case "6700":
        return "Wrong Length";

      case "6A82":
        return "File Not Found";

      case "6A83":
        return "Record Not Found";

      case "6A84":
        return "Not Enough Memory";

      case "6A86":
        return "Incorrect Parameters";

      default:
        return "Unknown Status";
    }
  }

  /// Response without Status Word
  String get responseData {
    if (response.length <= 4) {
      return "";
    }

    return response.substring(0, response.length - 4);
  }

  @override
  String toString() {
    return '''
Command : $command

Response : $response

Command Name : $commandName

Status : $statusWord
''';
  }
}
