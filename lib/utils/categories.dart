import 'dart:ui' show Color;

enum LangOrder { arFirst, enFirst }

enum EntryCategory {
  manqabah('manqabah', 'Manqabah', 'منقبة', Color(0xFFD4A843)),
  hadith('hadith', 'Hadith', 'حديث', Color(0xFF2E7D32)),
  khisal('khisal', 'Khisal', 'خصال', Color(0xFF00897B));

  final String key;
  final String labelEn;
  final String labelAr;
  final Color badgeColor;

  const EntryCategory(this.key, this.labelEn, this.labelAr, this.badgeColor);

  static EntryCategory fromKey(String key) {
    return values.firstWhere((c) => c.key == key);
  }
}
