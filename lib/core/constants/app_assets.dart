/// Centralized asset paths used by the presentation layer.
///
/// Keeping asset paths here avoids duplicated string literals across widgets
/// and makes asset renames easier to apply safely.
abstract final class AppAssets {
  static const botLightHappy = 'assets/bot/bot-light-happy.png';
  static const botDarkHappy = 'assets/bot/bot-dark-happy.png';

  static const botLightAngry = 'assets/bot/bot-light-angry.png';
  static const botDarkAngry = 'assets/bot/bot-dark-angry.png';

  static const botLightRules = 'assets/bot/bot-light-rules.png';
  static const botDarkRules = 'assets/bot/bot-dark-rules.png';
  static const botLightRulesEnd = 'assets/bot/bot-light-rules-end.png';
  static const botDarkRulesEnd = 'assets/bot/bot-dark-rules-end.png';

  static const botLightSettings = 'assets/bot/bot-light-settings.png';
  static const botDarkSettings = 'assets/bot/bot-dark-settings.png';

  static const botLightStats = 'assets/bot/bot-light-stats.png';
  static const botDarkStats = 'assets/bot/bot-dark-stats.png';
}
