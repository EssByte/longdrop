import 'package:flutter/material.dart';

class MyIdScreen extends StatelessWidget {
  const MyIdScreen({super.key});

  // TODO(backend): replace with the locally generated public key.
  static const String _placeholderId = '<your-public-key-will-appear-here>';

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
            const SizedBox(height: 16),
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
