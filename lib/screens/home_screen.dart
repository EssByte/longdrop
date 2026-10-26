import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import 'my_id_screen.dart';
import 'receive_screen.dart';
import 'send_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Longdrop')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.secondary],
                  ),
                ),
                child: Icon(
                  PhosphorIconsFill.paperPlaneTilt,
                  color: scheme.onPrimary,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Send files, privately.',
              textAlign: TextAlign.center,
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'End-to-end encrypted. No account. Full quality.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            _ActionCard(
              icon: PhosphorIconsFill.paperPlaneTilt,
              title: 'Send File',
              subtitle: 'Pick a file and a recipient',
              filled: true,
              onTap: () => _open(context, const SendScreen()),
            ),
            const SizedBox(height: 14),
            _ActionCard(
              icon: PhosphorIconsFill.downloadSimple,
              title: 'Receive File',
              subtitle: 'Wait for an incoming transfer',
              onTap: () => _open(context, const ReceiveScreen()),
            ),
            const SizedBox(height: 14),
            _IdCard(onTap: () => _open(context, const MyIdScreen())),
          ]
              .animate()
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.06, duration: 350.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final bg = filled ? scheme.primary : scheme.secondaryContainer;
    final fg = filled ? scheme.onPrimary : scheme.onSecondaryContainer;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: fg.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: fg, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        color: fg.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIconsBold.caretRight, color: fg, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  const _IdCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Material(
      color: scheme.surfaceContainerHighest.withOpacity(0.55),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const PeerAvatar(peerId: mockMyId, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My ID',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      shortId(mockMyId),
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIconsRegular.qrCode, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
