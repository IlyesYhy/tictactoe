import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class VictoryConfetti extends StatefulWidget {
  const VictoryConfetti({required this.active, super.key});

  final bool active;

  @override
  State<VictoryConfetti> createState() => _VictoryConfettiState();
}

class _VictoryConfettiState extends State<VictoryConfetti> {
  static const _duration = Duration(milliseconds: 500);
  static const _numberOfParticles = 20;

  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: _duration);

    if (widget.active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.play();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant VictoryConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.active && widget.active) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: const Alignment(0, -0.8),
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: _numberOfParticles,
        emissionFrequency: 0.05,
        colors: [
          colorScheme.primary,
          colorScheme.secondary,
          colorScheme.tertiary,
        ],
      ),
    );
  }
}
