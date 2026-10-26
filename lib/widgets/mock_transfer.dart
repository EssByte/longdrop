/// MOCKUP ONLY: fake transfer progress (0.0–1.0) so screens can be previewed
/// without a backend. Replace with real transfer state from `lib/providers/`.
Stream<double> mockProgress({
  Duration total = const Duration(seconds: 4),
}) async* {
  const steps = 40;
  final tick = total ~/ steps;
  for (var i = 1; i <= steps; i++) {
    await Future<void>.delayed(tick);
    yield i / steps;
  }
}
