import 'package:flutter/material.dart';

/// Placeholder progress bar. [progress] is 0.0–1.0.
class TransferProgressBar extends StatelessWidget {
  const TransferProgressBar({super.key, required this.progress, this.label});

  final double progress;

  /// Optional status text shown before the percentage, e.g. "Sending".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final percent = '${(progress * 100).round()}%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 4),
        Text(label == null ? percent : '$label · $percent'),
      ],
    );
  }
}
