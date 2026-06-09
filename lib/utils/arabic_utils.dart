String stripTashkeel(String text) {
  return text.replaceAll(RegExp(
    r'[\u064B-\u0652\u0670]',
  ), '');
}

String normalizeArabic(String text) {
  final noTashkeel = stripTashkeel(text);
  return noTashkeel
      .replaceAll(RegExp(r'[\u0622\u0623\u0625\u0671]'), '\u0627')
      .replaceAll('\u0629', '\u0647')
      .replaceAll('\u0626', '\u064A')
      .replaceAll('\u0624', '\u0648');
}
