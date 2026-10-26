import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Circular transfer progress with the percentage inside, an optional
/// status [label] below, and simulated E2EE chunk stats. [progress] is 0.0–1.0.
class TransferProgressBar extends StatelessWidget {
  const TransferProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.routeLabel = 'Direct WebRTC P2P · E2EE',
  });

  final double progress;

  /// Optional status text shown under the ring, e.g. "Sending".
  final String? label;

  /// Connection path indicator shown beneath the ring.
  final String routeLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final pct = (progress * 100).round();
    const totalChunks = 64;
    final currentChunk = (progress * totalChunks).clamp(0, totalChunks).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 168,
          height: 168,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                strokeCap: StrokeCap.round,
                backgroundColor: scheme.primaryContainer.withOpacity(0.55),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$pct%',
                      style: text.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Chunk $currentChunk/$totalChunks',
                      style: text.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 16),
          Text(
            label!,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.secondaryContainer.withOpacity(0.65),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIconsFill.shieldCheck,
                size: 15,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  routeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
