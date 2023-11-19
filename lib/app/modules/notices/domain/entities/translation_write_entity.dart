class TranslationWriteEntity {
  final String lang;
  final String? title;
  final String body;
  final DateTime? deadline;

  TranslationWriteEntity({
    this.lang = "en",
    this.title,
    required this.body,
    this.deadline,
  });
}
