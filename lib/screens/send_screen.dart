import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/keep_app_open_banner.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/transfer_progress_bar.dart';

enum _SendState { idle, sending, done }

/// MOCKUP: file choice and transfer are simulated. Wire to providers later.
class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _peerId = TextEditingController();
  StreamSubscription<double>? _sub;
  _SendState _state = _SendState.idle;
  String? _file;
  double _progress = 0;

  bool get _canConnect => _file != null && _peerId.text.trim().isNotEmpty;

  void _start() {
    setState(() {
      _state = _SendState.sending;
      _progress = 0;
    });
    _sub = mockProgress().listen(
      (p) => setState(() => _progress = p),
      onDone: () => setState(() => _state = _SendState.done),
    );
  }

  void _cancel() {
    _sub?.cancel();
    setState(() {
      _state = _SendState.idle;
      _progress = 0;
    });
  }

  void _reset() {
    setState(() {
      _state = _SendState.idle;
      _progress = 0;
      _file = null;
      _peerId.clear();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _peerId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send File')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (_state) {
          _SendState.idle => _buildForm(),
          _SendState.sending => _buildSending(),
          _SendState.done => _buildDone(),
        },
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          // TODO: real file picker. Mockup picks a fixed fake file.
          onPressed: () => setState(() => _file = 'holiday_video.mp4 · 182 MB'),
          icon: const Icon(Icons.attach_file),
          label: Text(_file ?? 'Choose file'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _peerId,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Peer ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        // TODO(backend): wire to peer connection.
        FilledButton(
          onPressed: _canConnect ? _start : null,
          child: const Text('Connect'),
        ),
      ],
    );
  }

  Widget _buildSending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const KeepAppOpenBanner(),
        const SizedBox(height: 24),
        Text(_file!),
        const SizedBox(height: 12),
        TransferProgressBar(progress: _progress, label: 'Sending'),
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
        Text(
          'Sent $_file',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _reset, child: const Text('Send another')),
      ],
    );
  }
}
