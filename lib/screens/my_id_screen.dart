import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';

class MyIdScreen extends StatelessWidget {
  const MyIdScreen({super.key});

  // TODO(backend): replace with the locally generated public key.
  static const String _id = mockMyId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My ID')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: QrImageView(
                  data: _id,
                  size: 220,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Let someone scan this to send you a file.',
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(0.55),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const PeerAvatar(peerId: _id, size: 44),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your ID (public key)',
                          style: text.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SelectableText(
                          _id,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(const ClipboardData(text: _id));
                      messenger.showSnackBar(
                        const SnackBar(content: Text('ID copied')),
                      );
                    },
                    icon: const Icon(PhosphorIconsRegular.copy),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    // TODO: share the ID (no-op for now).
                    onPressed: () {},
                    icon: const Icon(PhosphorIconsRegular.shareNetwork),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ]
              .animate()
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.05, duration: 350.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
