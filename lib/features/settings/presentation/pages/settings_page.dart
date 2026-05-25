import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _SectionHeader(label: context.l10n.settingsLanguage),
          RadioGroup<AppLanguage>(
            groupValue: settings.language,
            onChanged: (selected) {
              if (selected == null) return;
              unawaited(controller.selectLanguage(selected));
            },
            child: Column(
              children: [
                for (final language in AppLanguage.values)
                  RadioListTile<AppLanguage>(
                    key: Key('settings_language_${language.code}'),
                    title: Text(_languageLabel(context.l10n, language)),
                    value: language,
                  ),
              ],
            ),
          ),
          _SectionHeader(label: context.l10n.settingsTheme),
          RadioGroup<AppThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (selected) {
              if (selected == null) return;
              unawaited(controller.selectThemeMode(selected));
            },
            child: Column(
              children: [
                for (final themeMode in AppThemeMode.values)
                  RadioListTile<AppThemeMode>(
                    key: Key('settings_theme_${themeMode.name}'),
                    title: Text(_themeLabel(context.l10n, themeMode)),
                    value: themeMode,
                  ),
              ],
            ),
          ),
          _SectionHeader(label: context.l10n.settingsPreferences),
          SwitchListTile(
            key: const Key('settings_haptic_feedback'),
            title: Text(context.l10n.settingsHapticFeedback),
            value: settings.isHapticFeedbackEnabled,
            onChanged: (enabled) {
              unawaited(controller.setHapticFeedback(enabled));
            },
          ),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return switch (language) {
      AppLanguage.en => l10n.settingsLanguageEnglish,
      AppLanguage.fr => l10n.settingsLanguageFrench,
    };
  }

  String _themeLabel(AppLocalizations l10n, AppThemeMode themeMode) {
    return switch (themeMode) {
      AppThemeMode.light => l10n.settingsThemeLight,
      AppThemeMode.dark => l10n.settingsThemeDark,
      AppThemeMode.system => l10n.settingsThemeSystem,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        label,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
