import 'package:flutter/material.dart';

/// Circular transfer progress with the percentage inside and an optional
/// status [label] below. [progress] is 0.0–1.0.
class TransferProgressBar extends StatelessWidget {
  const TransferProgressBar({super.key, required this.progress, this.label});

  final double progress;

  /// Optional status text shown under the ring, e.g. "Sending".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          width: 148,
          height: 148,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                backgroundColor: scheme.primaryContainer,
              ),
              Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 14),
          Text(
            label!,
            style: text.titleSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
