import 'package:flutter/material.dart';

import '../widgets/transfer_progress_bar.dart';

class SendScreen extends StatelessWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send File')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              // TODO: file picker (no-op placeholder).
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose file'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Peer ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // TODO(backend): enable and wire to peer connection.
            const FilledButton(onPressed: null, child: Text('Connect')),
            const SizedBox(height: 24),
            const TransferProgressBar(progress: 0),
          ],
        ),
      ),
    );
  }
}
