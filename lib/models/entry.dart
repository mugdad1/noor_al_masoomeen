class Entry {
  final String id;
  final String category;
  final int masoomIndex;
  final String arabicText;
  final String englishText;
  final String? source;
  final String? titleEn;
  final String? titleAr;
  final bool isDailyEligible;

  const Entry({
    required this.id,
    required this.category,
    required this.masoomIndex,
    required this.arabicText,
    required this.englishText,
    this.source,
    this.titleEn,
    this.titleAr,
    this.isDailyEligible = true,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'] as String,
      category: json['category'] as String,
      masoomIndex: json['masoomIndex'] as int,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String,
      source: json['source'] as String?,
      titleEn: json['titleEn'] as String?,
      titleAr: json['titleAr'] as String?,
      isDailyEligible: json['isDailyEligible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'masoomIndex': masoomIndex,
      'arabicText': arabicText,
      'englishText': englishText,
      'source': source,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'isDailyEligible': isDailyEligible,
    };
  }
}
