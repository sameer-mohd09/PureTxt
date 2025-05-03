class TextSplitter {
  /// Splits the text by the specified number of lines
  static List<String> splitByLines(String input, int lineCount) {
    List<String> lines = input.split('\n');
    List<String> splitParts = [];
    for (int i = 0; i < lines.length; i += lineCount) {
      splitParts.add(lines.sublist(i, i + lineCount > lines.length ? lines.length : i + lineCount).join('\n'));
    }
    return splitParts;
  }

  /// Splits the text by the specified number of characters
  static List<String> splitByCharacters(String input, int charCount) {
    List<String> splitParts = [];
    for (int i = 0; i < input.length; i += charCount) {
      splitParts.add(input.substring(i, i + charCount > input.length ? input.length : i + charCount));
    }
    return splitParts;
  }
}
