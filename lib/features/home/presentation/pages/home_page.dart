import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';

/// Entry point of the application.
///
/// Currently a stub: the full layout (title, difficulty selector, mascot,
/// CTA) lands in the next commits of `feature/create-home-page`.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text(context.l10n.appTitle))),
    );
  }
}
