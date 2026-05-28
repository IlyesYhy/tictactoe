/// Centralized asset paths used by the presentation layer.
///
/// Keeping asset paths here avoids duplicated string literals across widgets
/// and makes asset renames easier to apply safely.
abstract final class AppAssets {
  static const botLightHappy = 'assets/bot-light-happy.png';
  static const botDarkHappy = 'assets/bot-dark-happy.png';

  static const botLightAngry = 'assets/bot-light-angry.png';
  static const botDarkAngry = 'assets/bot-dark-angry.png';

  static const botLightRules = 'assets/bot-light-rules.png';
  static const botDarkRules = 'assets/bot-dark-rules.png';
  static const botLightRulesEnd = 'assets/bot-light-rules-end.png';
  static const botDarkRulesEnd = 'assets/bot-dark-rules-end.png';

  static const botLightSettings = 'assets/bot-light-settings.png';
  static const botDarkSettings = 'assets/bot-dark-settings.png';

  static const botLightStats = 'assets/bot-light-stats.png';
  static const botDarkStats = 'assets/bot-dark-stats.png';
}
