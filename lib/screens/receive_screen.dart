import 'package:flutter/material.dart';

import '../widgets/transfer_progress_bar.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive File')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Waiting for connection...'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // TODO(backend): populate from real incoming transfer requests.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Incoming request (placeholder)'),
                    const Text('example.pdf from <peer-id>'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Decline')),
                        FilledButton(onPressed: () {}, child: const Text('Accept')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const TransferProgressBar(progress: 0),
          ],
        ),
      ),
    );
  }
}
