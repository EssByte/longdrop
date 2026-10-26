/// MOCKUP ONLY: fake data and transfer progress so screens can be previewed
/// without a backend. Replace with real state from `lib/providers/`.
const mockMyId = '7Kq2mXvR9eTz4WnB8cLdYh3sFpJ6uAaNxG5oEiVt1bM2';
const mockPeerId = '3Fh8Qw2nKxP9aTzLm4VbR7cJ';
const mockFileName = 'holiday_video.mp4';
const mockFileSize = '182 MB';

/// Fake transfer progress (0.0–1.0).
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
