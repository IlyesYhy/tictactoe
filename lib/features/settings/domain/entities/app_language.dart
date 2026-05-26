/// Languages supported by the app for user-selectable localization.
enum AppLanguage {
  en,
  fr;

  String get code => name;

  /// Parses a persisted code back into an [AppLanguage].
  ///
  /// Returns `null` for unknown codes so callers can fall back to a default.
  static AppLanguage? fromCode(String code) {
    return switch (code) {
      'en' => AppLanguage.en,
      'fr' => AppLanguage.fr,
      _ => null,
    };
  }
}
