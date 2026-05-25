import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictactoe/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tictactoe/features/settings/presentation/pages/settings_page.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

PackageInfo _fakePackageInfo({String version = '1.0.0'}) {
  return PackageInfo(
    appName: 'TicTacToe',
    packageName: 'com.example.tictactoe',
    version: version,
    buildNumber: '1',
  );
}

void main() {
  Future<(ProviderContainer, _RecordingSettingsRepository)> pumpSettingsPage(
    WidgetTester tester, {
    AppSettings initial = const AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    ),
    Locale locale = const Locale('en'),
    PackageInfo? packageInfo,
  }) async {
    final repository = _RecordingSettingsRepository();
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(initial),
        settingsRepositoryProvider.overrideWithValue(repository),
        packageInfoProvider.overrideWithValue(
          packageInfo ?? _fakePackageInfo(),
        ),
      ],
    );
    addTearDown(container.dispose);

    tester.view.physicalSize = const Size(600, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        ),
      ),
    );

    return (container, repository);
  }

  group('SettingsPage', () {
    testWidgets('renders all settings sections', (tester) async {
      await pumpSettingsPage(tester);

      expect(find.text('Settings'), findsOneWidget);

      // Theme section
      expect(find.text('Theme'), findsOneWidget);
      expect(find.byKey(const Key('settings_theme_light')), findsOneWidget);
      expect(find.byKey(const Key('settings_theme_dark')), findsOneWidget);
      expect(find.byKey(const Key('settings_theme_system')), findsOneWidget);

      // Preferences section
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.byKey(const Key('settings_language')), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('EN'), findsOneWidget);
      expect(find.byKey(const Key('settings_haptic_feedback')), findsOneWidget);
      expect(find.text('Haptic feedback'), findsOneWidget);

      // About section
      expect(find.text('About'), findsOneWidget);
      expect(find.byKey(const Key('settings_game_rules')), findsOneWidget);
      expect(find.text('Game rules'), findsOneWidget);
      expect(find.byKey(const Key('settings_version')), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
    });

    testWidgets('renders the app version from PackageInfo', (tester) async {
      await pumpSettingsPage(
        tester,
        packageInfo: _fakePackageInfo(version: '4.2.0'),
      );

      expect(find.byKey(const Key('settings_version')), findsOneWidget);
      expect(find.text('4.2.0'), findsOneWidget);
    });

    testWidgets('tap on French language radio updates state and persists fr', (
      tester,
    ) async {
      final (container, repository) = await pumpSettingsPage(tester);

      await tester.tap(find.byKey(const Key('settings_language')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_language_fr')));
      await tester.pumpAndSettle();

      expect(
        container.read(settingsControllerProvider).language,
        AppLanguage.fr,
      );
      expect(repository.savedLanguages, [AppLanguage.fr]);
    });

    testWidgets('renders French language options in language picker', (
      tester,
    ) async {
      await pumpSettingsPage(tester, locale: const Locale('fr'));

      await tester.tap(find.byKey(const Key('settings_language')));
      await tester.pumpAndSettle();

      expect(find.text('Anglais'), findsOneWidget);
      expect(find.text('Français'), findsOneWidget);
    });

    testWidgets('tap on Dark theme radio updates state and persists dark', (
      tester,
    ) async {
      final (container, repository) = await pumpSettingsPage(tester);

      await tester.tap(find.byKey(const Key('settings_theme_dark')));
      await tester.pumpAndSettle();

      expect(
        container.read(settingsControllerProvider).themeMode,
        AppThemeMode.dark,
      );
      expect(repository.savedThemeModes, [AppThemeMode.dark]);
    });

    testWidgets(
      'tap on haptic feedback switch updates state and persists false',
      (tester) async {
        final (container, repository) = await pumpSettingsPage(tester);

        await tester.tap(find.byKey(const Key('settings_haptic_feedback')));
        await tester.pumpAndSettle();

        expect(
          container.read(settingsControllerProvider).isHapticFeedbackEnabled,
          isFalse,
        );
        expect(repository.savedHapticFeedback, [false]);
      },
    );

    testWidgets('renders French labels under fr locale', (tester) async {
      await pumpSettingsPage(tester, locale: const Locale('fr'));

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Langue'), findsOneWidget);
      expect(find.text('Thème'), findsOneWidget);
      expect(find.text('Clair'), findsOneWidget);
      expect(find.text('Sombre'), findsOneWidget);
      expect(find.text('Système'), findsOneWidget);
      expect(find.text('Préférences'), findsOneWidget);
      expect(find.text('Vibrations'), findsOneWidget);
      expect(find.text('À propos'), findsOneWidget);
      expect(find.text('Règles du jeu'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
    });
  });
}

final class _RecordingSettingsRepository implements SettingsRepository {
  final savedLanguages = <AppLanguage>[];
  final savedThemeModes = <AppThemeMode>[];
  final savedHapticFeedback = <bool>[];

  @override
  Future<AppLanguage?> getLanguage() async => null;

  @override
  Future<AppThemeMode?> getThemeMode() async => null;

  @override
  Future<bool?> getHapticFeedback() async => null;

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    savedLanguages.add(language);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    savedThemeModes.add(themeMode);
  }

  @override
  Future<void> saveHapticFeedback(bool enabled) async {
    savedHapticFeedback.add(enabled);
  }
}
