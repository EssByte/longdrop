import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/file_card.dart';
import '../widgets/keep_app_open_banner.dart';
import '../widgets/lottie_graphics.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import '../widgets/transfer_progress_bar.dart';

enum _ReceiveState { waiting, request, receiving, done }

/// MOCKUP: incoming requests and transfer are simulated. Wire to providers
/// later.
class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  // TODO(backend): populate from real incoming transfer requests.
  StreamSubscription<double>? _sub;
  _ReceiveState _state = _ReceiveState.waiting;
  double _progress = 0;

  void _accept() {
    setState(() {
      _state = _ReceiveState.receiving;
      _progress = 0;
    });
    _sub = mockProgress().listen(
      (p) => setState(() => _progress = p),
      onDone: () => setState(() => _state = _ReceiveState.done),
    );
  }

  void _cancel() {
    _sub?.cancel();
    setState(() => _state = _ReceiveState.waiting);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive File')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: switch (_state) {
            _ReceiveState.waiting => _buildWaiting(context),
            _ReceiveState.request => _buildRequest(context),
            _ReceiveState.receiving => _buildReceiving(context),
            _ReceiveState.done => _buildDone(context),
          },
        ),
      ),
    );
  }

  List<Widget> _buildWaiting(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return [
      const SizedBox(height: 24),
      const Center(child: PulseRings()),
      const SizedBox(height: 16),
      Text(
        'Waiting for connection...',
        textAlign: TextAlign.center,
        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Text(
        'Keep this screen open. Senders can reach you with your ID.',
        textAlign: TextAlign.center,
        style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      const SizedBox(height: 32),
      TextButton(
        onPressed: () => setState(() => _state = _ReceiveState.request),
        child: const Text('Simulate incoming request (mockup)'),
      ),
    ];
  }

  List<Widget> _buildRequest(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return [
      Card(
        color: scheme.surfaceContainerHighest.withOpacity(0.55),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const PeerAvatar(peerId: mockPeerId, size: 72),
              const SizedBox(height: 14),
              Text(
                'Incoming request',
                style: text.labelLarge?.copyWith(color: scheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                shortId(mockPeerId),
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                'wants to send you a file',
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              const FileCard(name: mockFileName, size: mockFileSize),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          setState(() => _state = _ReceiveState.waiting),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _accept,
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.05, duration: 300.ms),
    ];
  }

  List<Widget> _buildReceiving(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return [
      const KeepAppOpenBanner(),
      const SizedBox(height: 20),
      Row(
        children: [
          const PeerAvatar(peerId: mockPeerId, size: 40),
          const SizedBox(width: 12),
          Text('From ',
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          Text(
            shortId(mockPeerId),
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(height: 14),
      const FileCard(name: mockFileName, size: mockFileSize),
      const SizedBox(height: 32),
      Center(
          child: TransferProgressBar(progress: _progress, label: 'Receiving')),
      const SizedBox(height: 32),
      OutlinedButton(onPressed: _cancel, child: const Text('Cancel')),
    ];
  }

  List<Widget> _buildDone(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return [
      const SizedBox(height: 24),
      const Center(child: SuccessCheck()),
      const SizedBox(height: 12),
      Text(
        'Received',
        textAlign: TextAlign.center,
        style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 20),
      const FileCard(name: mockFileName, size: mockFileSize),
      const SizedBox(height: 28),
      FilledButton(
        onPressed: () => setState(() => _state = _ReceiveState.waiting),
        child: const Text('Done'),
      ),
    ];
  }
}
