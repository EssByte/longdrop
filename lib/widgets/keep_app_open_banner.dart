import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'mock_transfer.dart';

/// Shown while a transfer is in progress (v1: both apps must stay open).
class KeepAppOpenBanner extends StatelessWidget {
  const KeepAppOpenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.tertiary.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: scheme.tertiary.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              PhosphorIconsFill.warning,
              color: scheme.onTertiaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep the app open until the transfer finishes.',
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Direct P2P stream active · Foreground lock enabled',
                  style: text.labelSmall?.copyWith(
                    color: scheme.onTertiaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Signaling server connection status banner (Process 1 in architecture.md).
class ServerStatusBanner extends StatelessWidget {
  const ServerStatusBanner({
    super.key,
    required this.status,
    this.onCycleStatus,
  });

  final MockServerStatus status;
  final VoidCallback? onCycleStatus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final (
      Color bg,
      Color fg,
      Color dot,
      IconData icon,
      String title,
      String subtitle
    ) = switch (status) {
      MockServerStatus.registered => (
          scheme.secondaryContainer.withOpacity(0.65),
          scheme.onSecondaryContainer,
          const Color(0xFF10B981),
          PhosphorIconsFill.checkCircle,
          'Registered · Signaling Online',
          'WebSocket heartbeat active · Ready for P2P',
        ),
      MockServerStatus.reconnecting => (
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
          scheme.tertiary,
          PhosphorIconsBold.arrowsClockwise,
          'Reconnecting...',
          'Connection dropped · Re-registering public key ID',
        ),
      MockServerStatus.cannotReach => (
          scheme.errorContainer,
          scheme.onErrorContainer,
          scheme.error,
          PhosphorIconsFill.wifiSlash,
          'Cannot reach server',
          'Retrying WebSocket with exponential backoff...',
        ),
      MockServerStatus.notResponding => (
          scheme.errorContainer,
          scheme.onErrorContainer,
          scheme.error,
          PhosphorIconsFill.clockCountdown,
          'Server not responding',
          'REGISTER timed out · Retrying handshake...',
        ),
    };

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onCycleStatus,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dot,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: dot.withOpacity(0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        color: fg.withOpacity(0.82),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (onCycleStatus != null)
                Tooltip(
                  message: 'Tap to preview server status banners (mockup)',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: fg.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Status preview',
                      style: text.labelSmall?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
