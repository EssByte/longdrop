import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import '../widgets/responsive_layout.dart';
import 'onboarding_screen.dart';

class MyIdScreen extends StatelessWidget {
  const MyIdScreen({super.key});

  // TODO(backend): replace with the locally generated public key.
  static const String _id = mockMyId;

  void _showShareMockSheet(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Share Public ID (Mockup)',
                  style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your ID is a public key safe to share anywhere. '
                  'Private keys never leave your device.',
                  style:
                      text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _id,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(sheetContext).pop();
                    await Clipboard.setData(const ClipboardData(text: _id));
                    messenger.showSnackBar(
                      const SnackBar(content: Text('ID copied')),
                    );
                  },
                  icon: const Icon(PhosphorIconsRegular.copy),
                  label: const Text('Copy ID to Clipboard'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My ID')),
      body: ResponsiveBody(
        child: ResponsiveSplit(
          leftFlex: 5,
          rightFlex: 6,
          spacing: 24,
          left: _buildQrPanel(context),
          right: _buildDetailsPanel(context),
        )
            .animate()
            .fadeIn(duration: 350.ms)
            .slideY(begin: 0.04, duration: 350.ms, curve: Curves.easeOut),
      ),
    );
  }

  Widget _buildQrPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withOpacity(0.55),
            scheme.secondaryContainer.withOpacity(0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.55)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: QrImageView(
              data: _id,
              size: 210,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Let someone scan this to send you a file.',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(0.55),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PeerAvatar(
                    peerId: _id,
                    size: 48,
                    showOnlineDot: true,
                  ),
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SecurityBadge(
                    icon: PhosphorIconsFill.shieldCheck,
                    label: 'Base58 Public Key',
                  ),
                  _SecurityBadge(
                    icon: PhosphorIconsFill.lockKey,
                    label: 'Hardware Keystore',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
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
                onPressed: () => _showShareMockSheet(context),
                icon: const Icon(PhosphorIconsRegular.shareNetwork),
                label: const Text('Share'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: scheme.secondaryContainer.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const OnboardingScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsFill.notebook,
                    color: scheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '12-Word Recovery Phrase',
                          style: text.labelLarge?.copyWith(
                            color: scheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Preview first-launch backup & reinstall restore flow',
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSecondaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    PhosphorIconsBold.caretRight,
                    size: 16,
                    color: scheme.onSecondaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: text.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
