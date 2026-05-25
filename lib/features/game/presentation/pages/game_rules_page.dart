import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({super.key});

  static const _horizontalPadding = 24.0;
  static const _sectionGap = 24.0;
  static const _bulletGap = 12.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameRulesTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: _horizontalPadding,
        ),
        children: [
          _SectionHeader(label: l10n.gameRulesObjective),
          const SizedBox(height: _bulletGap),
          Text(l10n.gameRulesObjectiveDescription),
          const SizedBox(height: _sectionGap),
          _SectionHeader(label: l10n.gameRulesHowToPlay),
          const SizedBox(height: _bulletGap),
          _Bullet(text: l10n.gameRulesStart),
          const SizedBox(height: _bulletGap),
          _Bullet(text: l10n.gameRulesWin),
          const SizedBox(height: _bulletGap),
          _Bullet(text: l10n.gameRulesDraw),
          const SizedBox(height: _sectionGap),
          _SectionHeader(label: l10n.gameRulesDifficulty),
          const SizedBox(height: _bulletGap),
          _Bullet(text: l10n.gameRulesEasy),
          const SizedBox(height: _bulletGap),
          _Bullet(text: l10n.gameRulesHard),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 12),
          child: Icon(
            Icons.circle,
            size: 6,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(child: Text(text)),
      ],
    );
  }
}
