import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyIdScreen extends StatelessWidget {
  const MyIdScreen({super.key});

  // TODO(backend): replace with the locally generated public key.
  static const String _placeholderId =
      '7Kq2mXvR9eTz4WnB8cLdYh3sFpJ6uAaNxG5oEiVt1bM2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My ID')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Your ID (public key)'),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SelectableText(_placeholderId),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share this with people who want to send you files.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(const ClipboardData(text: _placeholderId));
                messenger.showSnackBar(
                  const SnackBar(content: Text('ID copied')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              // TODO: share the ID (no-op for now).
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
