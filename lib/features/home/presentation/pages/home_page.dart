import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

/// Entry point of the application.
///
/// Currently a skeleton: the title and a temporary CTA. The full layout
/// (mascot, difficulty selector, polished CTA) lands in the next commits
/// of `feature/create-home-page`.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.appTitle,
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                key: const Key('home_new_game_button'),
                onPressed: () => context.goNamed(AppRouteNames.game),
                child: Text(context.l10n.newGame),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
