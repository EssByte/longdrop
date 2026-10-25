import 'package:flutter/material.dart';

/// Placeholder progress bar. [progress] is 0.0–1.0.
class TransferProgressBar extends StatelessWidget {
  const TransferProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 4),
        Text('${(progress * 100).round()}%'),
      ],
    );
  }
}
