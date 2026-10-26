/// MOCKUP ONLY: fake data and transfer progress so screens can be previewed
/// without a backend. Replace with real state from `lib/providers/`.
const mockMyId = '7Kq2mXvR9eTz4WnB8cLdYh3sFpJ6uAaNxG5oEiVt1bM2';
const mockPeerId = '3Fh8Qw2nKxP9aTzLm4VbR7cJ';
const mockFileName = 'holiday_video.mp4';
const mockFileSize = '182 MB';

/// Sample 12-word BIP39 recovery phrase for Process 1 (Registration) mockup.
const List<String> mockBackupWords = [
  'ocean',
  'velvet',
  'timber',
  'glacier',
  'lantern',
  'orbit',
  'meadow',
  'quartz',
  'beacon',
  'canyon',
  'whisper',
  'zenith',
];

/// Sample files that can be cycled through in the Send File mockup.
class MockFileItem {
  const MockFileItem({
    required this.name,
    required this.size,
    required this.mimeLabel,
  });

  final String name;
  final String size;
  final String mimeLabel;
}

const List<MockFileItem> mockSampleFiles = [
  MockFileItem(
    name: mockFileName,
    size: mockFileSize,
    mimeLabel: '4K HEVC Video · Original quality',
  ),
  MockFileItem(
    name: 'dataset_archive.zip',
    size: '640 MB',
    mimeLabel: 'ZIP Archive · Lossless binary',
  ),
  MockFileItem(
    name: 'studio_master_mix.wav',
    size: '94.5 MB',
    mimeLabel: '24-bit PCM Audio · Uncompressed',
  ),
  MockFileItem(
    name: 'architecture_spec.pdf',
    size: '12.4 MB',
    mimeLabel: 'PDF Document · Encrypted chunks',
  ),
];

/// Simulated signaling server connection states from Process 1 diagram.
enum MockServerStatus {
  registered,
  reconnecting,
  cannotReach,
  notResponding,
}

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
