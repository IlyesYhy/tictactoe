import 'package:equatable/equatable.dart';

import '../../domain/entities/game_session.dart';

final class GameControllerState extends Equatable {
  const GameControllerState({
    required this.session,
    required this.isCpuThinking,
  });

  final GameSession session;
  final bool isCpuThinking;

  GameControllerState copyWith({GameSession? session, bool? isCpuThinking}) {
    return GameControllerState(
      session: session ?? this.session,
      isCpuThinking: isCpuThinking ?? this.isCpuThinking,
    );
  }

  @override
  List<Object?> get props => [session, isCpuThinking];
}
