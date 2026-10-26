import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/keep_app_open_banner.dart';
import '../widgets/mock_transfer.dart';
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
  static const _fileName = 'holiday_video.mp4 · 182 MB';
  static const _peer = '3Fh8…Qw2n';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (_state) {
          _ReceiveState.waiting => _buildWaiting(),
          _ReceiveState.request => _buildRequest(),
          _ReceiveState.receiving => _buildReceiving(),
          _ReceiveState.done => _buildDone(),
        },
      ),
    );
  }

  Widget _buildWaiting() {
    return Column(
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
        const SizedBox(height: 32),
        TextButton(
          onPressed: () => setState(() => _state = _ReceiveState.request),
          child: const Text('Simulate incoming request (mockup)'),
        ),
      ],
    );
  }

  Widget _buildRequest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Incoming request'),
            const SizedBox(height: 8),
            const Text(_fileName),
            const Text('from $_peer'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      setState(() => _state = _ReceiveState.waiting),
                  child: const Text('Decline'),
                ),
                FilledButton(onPressed: _accept, child: const Text('Accept')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiving() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const KeepAppOpenBanner(),
        const SizedBox(height: 24),
        const Text(_fileName),
        const SizedBox(height: 12),
        TransferProgressBar(progress: _progress, label: 'Receiving'),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: _cancel, child: const Text('Cancel')),
      ],
    );
  }

  Widget _buildDone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, size: 64),
        const SizedBox(height: 12),
        const Text('Received $_fileName', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => setState(() => _state = _ReceiveState.waiting),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
