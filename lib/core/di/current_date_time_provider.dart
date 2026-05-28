import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Clock indirection so callers can inject a stable timestamp instead of the
/// system clock. Production resolves to [DateTime.now].
///
/// Lives in [core] because the clock is a transverse concern — features
/// (stats, game, ...) and the composition root all consume it without owning
/// it.
final currentDateTimeProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
