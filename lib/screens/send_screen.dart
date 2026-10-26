import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/file_card.dart';
import '../widgets/keep_app_open_banner.dart';
import '../widgets/lottie_graphics.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
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
  bool _hasFile = false;
  double _progress = 0;

  bool get _canConnect => _hasFile && _peerId.text.trim().isNotEmpty;

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
      _hasFile = false;
      _peerId.clear();
    });
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final value = data?.text?.trim();
    if (value == null || value.isEmpty) return;
    setState(() => _peerId.text = value);
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: switch (_state) {
            _SendState.idle => _buildForm(context),
            _SendState.sending => _buildSending(context),
            _SendState.done => _buildDone(context),
          },
        ),
      ),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return [
      if (!_hasFile)
        // TODO: real file picker. Mockup picks a fixed fake file.
        Material(
          color: scheme.primaryContainer.withOpacity(0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: scheme.primary.withOpacity(0.5)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () => setState(() => _hasFile = true),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary,
                    ),
                    child: Icon(
                      PhosphorIconsBold.uploadSimple,
                      color: scheme.onPrimary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Choose file',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Any type, any size, original quality',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      else
        FileCard(
          name: mockFileName,
          size: mockFileSize,
          trailing: IconButton(
            tooltip: 'Remove file',
            onPressed: () => setState(() => _hasFile = false),
            icon: const Icon(PhosphorIconsRegular.x),
          ),
        ).animate().fadeIn(duration: 250.ms).scale(
              begin: const Offset(0.97, 0.97),
              duration: 250.ms,
            ),
      const SizedBox(height: 20),
      TextField(
        controller: _peerId,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: 'Peer ID',
          prefixIcon: const Icon(PhosphorIconsRegular.user),
          suffixIcon: IconButton(
            tooltip: 'Paste',
            onPressed: _paste,
            icon: const Icon(PhosphorIconsRegular.clipboardText),
          ),
        ),
      ),
      const SizedBox(height: 24),
      // TODO(backend): wire to peer connection.
      FilledButton(
        onPressed: _canConnect ? _start : null,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIconsFill.paperPlaneTilt, size: 20),
            SizedBox(width: 10),
            Text('Connect'),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildSending(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return [
      const KeepAppOpenBanner(),
      const SizedBox(height: 20),
      Row(
        children: [
          const PeerAvatar(peerId: mockPeerId, size: 40),
          const SizedBox(width: 12),
          Text('To ',
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
      Center(child: TransferProgressBar(progress: _progress, label: 'Sending')),
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
        'Sent successfully',
        textAlign: TextAlign.center,
        style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 20),
      const FileCard(name: mockFileName, size: mockFileSize),
      const SizedBox(height: 28),
      FilledButton(onPressed: _reset, child: const Text('Send another')),
    ];
  }
}
