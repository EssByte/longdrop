import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Longdrop')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => _open(context, const MyIdScreen()),
                icon: const Icon(Icons.badge_outlined),
                label: const Text('My ID'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _open(context, const SendScreen()),
                icon: const Icon(Icons.upload_file),
                label: const Text('Send File'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _open(context, const ReceiveScreen()),
                icon: const Icon(Icons.download),
                label: const Text('Receive File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
