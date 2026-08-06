class EmvTagDictionary {
  static const Map<String, String> tags = {
    //==========================================================
    // Application Tags
    //==========================================================
    "4F": "Application Identifier (AID)",
    "50": "Application Label",
    "57": "Track 2 Equivalent Data",
    "5A": "Application PAN",
    "5F20": "Cardholder Name",
    "5F24": "Application Expiration Date",
    "5F25": "Application Effective Date",
    "5F28": "Issuer Country Code",
    "5F2A": "Transaction Currency Code",
    "5F2D": "Language Preference",
    "5F30": "Service Code",
    "5F34": "PAN Sequence Number",
    "5F50": "Issuer URL",

    //==========================================================
    // EMV Template Tags
    //==========================================================
    "61": "Application Template",
    "6F": "FCI Template",
    "70": "Record Template",
    "71": "Issuer Script Template 1",
    "72": "Issuer Script Template 2",
    "73": "Directory Discretionary Template",
    "77": "Response Message Template Format 2",
    "80": "Response Message Template Format 1",
    "A5": "FCI Proprietary Template",
    "BF0C": "FCI Issuer Discretionary Data",

    //==========================================================
    // DOL
    //==========================================================
    "8C": "Card Risk Management Data Object List 1 (CDOL1)",
    "8D": "Card Risk Management Data Object List 2 (CDOL2)",
    "8F": "Certification Authority Public Key Index",
    "9F38": "Processing Options Data Object List (PDOL)",
    "9F49": "Dynamic Data Authentication Data Object List (DDOL)",
    "9F4F": "Log Format",
    "9F69": "Card Authentication Related Data",

    //==========================================================
    // Application Data
    //==========================================================
    "82": "Application Interchange Profile",
    "84": "Dedicated File Name",
    "87": "Application Priority Indicator",
    "88": "Short File Identifier",
    "8A": "Authorisation Response Code",
    "90": "Issuer Public Key Certificate",
    "92": "Issuer Public Key Remainder",
    "93": "Signed Static Application Data",
    "94": "Application File Locator",
    "95": "Terminal Verification Results",

    //==========================================================
    // 9F Tags
    //==========================================================
    "9F01": "Acquirer Identifier",
    "9F02": "Amount Authorised",
    "9F03": "Amount Other",
    "9F04": "Amount Other Binary",
    "9F05": "Application Discretionary Data",
    "9F06": "Application Identifier",
    "9F07": "Application Usage Control",
    "9F08": "Application Version Number",
    "9F09": "Application Version Number",
    "9F0D": "Issuer Action Code Default",
    "9F0E": "Issuer Action Code Denial",
    "9F0F": "Issuer Action Code Online",
    "9F10": "Issuer Application Data",
    "9F11": "Issuer Code Table Index",
    "9F12": "Application Preferred Name",
    "9F13": "Last Online ATC Register",
    "9F14": "Lower Consecutive Offline Limit",
    "9F15": "Merchant Category Code",
    "9F16": "Merchant Identifier",
    "9F17": "PIN Try Counter",
    "9F1A": "Terminal Country Code",
    "9F1C": "Terminal Identification",
    "9F1D": "Terminal Risk Management Data",
    "9F1E": "Interface Device Serial Number",
    "9F1F": "Track 1 Discretionary Data",
    "9F21": "Transaction Time",
    "9F26": "Application Cryptogram",
    "9F27": "Cryptogram Information Data",
    "9F2A": "Kernel Identifier",
    "9F2D": "ICC PIN Encipherment Public Key Certificate",
    "9F2E": "ICC PIN Encipherment Public Key Exponent",
    "9F2F": "ICC PIN Encipherment Public Key Remainder",
    "9F32": "Issuer Public Key Exponent",
    "9F33": "Terminal Capabilities",
    "9F34": "Cardholder Verification Method Results",
    "9F35": "Terminal Type",
    "9F36": "Application Transaction Counter",
    "9F37": "Unpredictable Number",
    "9F39": "POS Entry Mode",
    "9F3A": "Amount Reference Currency",
    "9F3B": "Application Reference Currency",
    "9F40": "Additional Terminal Capabilities",
    "9F41": "Transaction Sequence Counter",
    "9F42": "Application Currency Code",
    "9F44": "Application Currency Exponent",
    "9F45": "Data Authentication Code",
    "9F46": "ICC Public Key Certificate",
    "9F47": "ICC Public Key Exponent",
    "9F48": "ICC Public Key Remainder",
    "9F4A": "Static Data Authentication Tag List",
    "9F4B": "Signed Dynamic Application Data",
    "9F4C": "ICC Dynamic Number",
    "9F53": "Transaction Category Code",
    "9F66": "Terminal Transaction Qualifiers",

    //==========================================================
    // DF Tags (Common Kernel Tags)
    //==========================================================
    "DF15": "Kernel Configuration",
    "DF16": "Kernel Identifier",
    "DF22": "Terminal Action Code",
    "DF23": "Reader Capabilities",
    "DF3A": "Kernel Capability",
    "DF45": "Kernel Proprietary Data",
  };

  static String getName(String tag) {
    return tags[tag.toUpperCase()] ?? "Unknown Tag";
  }
}
