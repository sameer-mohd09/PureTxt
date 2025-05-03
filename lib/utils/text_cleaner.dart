class TextCleaner {
  /// Removes extra spaces between words and trims each line
  static String removeExtraSpaces(String input) {
    return input
        .split('\n')
        .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
        .join('\n');
  }

  /// Removes entirely blank lines
  static String removeBlankLines(String input) {
    return input
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .join('\n');
  }

  /// Removes timestamps using common patterns
  static String removeTimestamps(String input) {
    final RegExp timestampRegex = RegExp(
      r'(\[?\d{1,2}:\d{2}(?::\d{2})?\s?(AM|PM|am|pm)?\]?)|(\d{4}[-/]\d{2}[-/]\d{2} \d{2}:\d{2}:\d{2})',
    );
    return input.replaceAll(timestampRegex, '');
  }

  /// Removes special characters (non-alphanumeric, keeps spaces)
  static String removeSpecialCharacters(String input) {
    return input.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Converts all text to lowercase
  static String convertToLowerCase(String input) {
    return input.toLowerCase();
  }

  /// You can expand this with custom functions like:
  /// removeDuplicateLines, removeSpecificWords, etc.
}
