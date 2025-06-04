extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringCleaner on String {
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
}
