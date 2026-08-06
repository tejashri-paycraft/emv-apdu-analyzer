import '../models/apdu_log.dart';
import '../models/dol_field.dart';
import '../models/tlv_node.dart';
import 'ber_tlv_parser.dart';
import 'dol_parser.dart';

class EmvTransactionParser {
  String? _pdolDefinition;
  String? _cdol1Definition;
  String? _cdol2Definition;

  int _generateAcCount = 0;

  /// Parsed DOL fields for each APDU index
  final Map<int, List<DolField>> parsedDol = {};

  /// Type of parsed data
  /// GPO / GENERATE AC1 / GENERATE AC2
  final Map<int, String> dolType = {};

  //----------------------------------------------------------
  // Main Entry
  //----------------------------------------------------------

  void parse(List<ApduLog> logs) {
    _pdolDefinition = null;
    _cdol1Definition = null;
    _cdol2Definition = null;
    _generateAcCount = 0;

    parsedDol.clear();
    dolType.clear();

    for (int i = 0; i < logs.length; i++) {
      final log = logs[i];

      //------------------------------------------
      // Parse Response TLVs
      //------------------------------------------

      if (log.responseData.isNotEmpty) {
        final tlvs = BerTlvParser.parse(log.responseData);

        _extractDefinitions(tlvs);
      }

      //------------------------------------------
      // Parse Command
      //------------------------------------------

      switch (log.ins.toUpperCase()) {
        case "A8":
          _parseGpo(i, log);
          break;

        case "AE":
          _parseGenerateAc(i, log);
          break;
      }
    }
  }

  //----------------------------------------------------------
  // Extract PDOL / CDOL1 / CDOL2
  //----------------------------------------------------------

  void _extractDefinitions(List<TlvNode> nodes) {
    final pdol = BerTlvParser.findTag(nodes, "9F38");

    if (pdol != null) {
      _pdolDefinition = pdol.value;
    }

    final cdol1 = BerTlvParser.findTag(nodes, "8C");

    if (cdol1 != null) {
      _cdol1Definition = cdol1.value;
    }

    final cdol2 = BerTlvParser.findTag(nodes, "8D");

    if (cdol2 != null) {
      _cdol2Definition = cdol2.value;
    }
  }

  //----------------------------------------------------------
  // Parse GPO
  //----------------------------------------------------------

  //----------------------------------------------------------
  // Parse GPO
  //----------------------------------------------------------

  void _parseGpo(int index, ApduLog log) {
    if (_pdolDefinition == null) {
      return;
    }

    try {
      final fields = DolParser.parseGpo(
        pdolDefinition: _pdolDefinition!,
        command: log.command,
      );

      if (fields.isNotEmpty) {
        parsedDol[index] = fields;
        dolType[index] = "GPO (PDOL)";
      }
    } catch (e) {
      // Ignore malformed APDU
    }
  }

  //----------------------------------------------------------
  // Parse Generate AC
  //----------------------------------------------------------

  void _parseGenerateAc(int index, ApduLog log) {
    _generateAcCount++;

    try {
      //------------------------------------------------------
      // First Generate AC -> CDOL1
      //------------------------------------------------------

      if (_generateAcCount == 1 && _cdol1Definition != null) {
        final fields = DolParser.parseGenerateAc(
          cdolDefinition: _cdol1Definition!,
          command: log.command,
        );

        if (fields.isNotEmpty) {
          parsedDol[index] = fields;
          dolType[index] = "GENERATE AC 1 (CDOL1)";
        }

        return;
      }

      //------------------------------------------------------
      // Second Generate AC -> CDOL2
      //------------------------------------------------------

      if (_generateAcCount == 2 && _cdol2Definition != null) {
        final fields = DolParser.parseGenerateAc(
          cdolDefinition: _cdol2Definition!,
          command: log.command,
        );

        if (fields.isNotEmpty) {
          parsedDol[index] = fields;
          dolType[index] = "GENERATE AC 2 (CDOL2)";
        }

        return;
      }

      //------------------------------------------------------
      // More than 2 Generate AC
      //------------------------------------------------------

      if (_cdol2Definition != null) {
        final fields = DolParser.parseGenerateAc(
          cdolDefinition: _cdol2Definition!,
          command: log.command,
        );

        if (fields.isNotEmpty) {
          parsedDol[index] = fields;
          dolType[index] = "GENERATE AC $_generateAcCount";
        }
      }
    } catch (e) {
      // Ignore malformed APDU
    }
  }

  //----------------------------------------------------------
  // Public Helper
  //----------------------------------------------------------

  List<DolField> fieldsFor(int index) {
    return parsedDol[index] ?? [];
  }

  String typeFor(int index) {
    return dolType[index] ?? "";
  }
}
