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
import '../widgets/responsive_layout.dart';
import '../widgets/transfer_progress_bar.dart';

enum _SendState { idle, sending, error, done }

/// Simulated outcomes from Process 2 (Connection Setup) in `docs/architecture.md`.
enum _MockSendOutcome {
  success,
  peerOffline,
  peerDeclined,
  serverTimeout,
}

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
  _MockSendOutcome _outcome = _MockSendOutcome.success;
  bool _hasFile = false;
  int _selectedFileIndex = 0;
  double _progress = 0;

  MockFileItem get _currentFile => mockSampleFiles[_selectedFileIndex];

  bool get _canConnect => _hasFile && _peerId.text.trim().isNotEmpty;

  void _start() {
    if (_outcome != _MockSendOutcome.success) {
      setState(() {
        _state = _SendState.error;
        _progress = 0;
      });
      return;
    }
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
      _selectedFileIndex = 0;
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
      body: ResponsiveBody(
        child: switch (_state) {
          _SendState.idle => _buildForm(context),
          _SendState.sending => _buildSending(context),
          _SendState.error => _buildError(context),
          _SendState.done => _buildDone(context),
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return ResponsiveSplit(
      leftFlex: 6,
      rightFlex: 6,
      spacing: 24,
      left: _buildFileSelectionPanel(context),
      right: _buildPeerPanel(context),
    );
  }

  Widget _buildFileSelectionPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_hasFile)
          // TODO: real file picker. Mockup picks a fixed fake file.
          Material(
            color: scheme.primaryContainer.withOpacity(0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(
                color: scheme.primary.withOpacity(0.45),
                width: 1.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => setState(() => _hasFile = true),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [scheme.primary, scheme.secondary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withOpacity(0.24),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        PhosphorIconsBold.uploadSimple,
                        color: scheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose file',
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Any type, any size, original quality',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          FileCard(
            name: _currentFile.name,
            size: _currentFile.size,
            subtitle: _currentFile.mimeLabel,
            trailing: IconButton(
              tooltip: 'Remove file',
              onPressed: () => setState(() => _hasFile = false),
              icon: const Icon(PhosphorIconsRegular.x),
            ),
          ).animate().fadeIn(duration: 250.ms).scale(
                begin: const Offset(0.97, 0.97),
                duration: 250.ms,
              ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(mockSampleFiles.length, (i) {
              final item = mockSampleFiles[i];
              return ChoiceChip(
                label: Text(item.name),
                selected: _selectedFileIndex == i,
                onSelected: (_) => setState(() => _selectedFileIndex = i),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildPeerPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final trimmedPeer = _peerId.text.trim();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recipient',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ActionChip(
                avatar: const Icon(PhosphorIconsRegular.qrCode, size: 16),
                label: const Text('Scan QR (mock)'),
                onPressed: () => setState(() => _peerId.text = mockPeerId),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
          if (trimmedPeer.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                PeerAvatar(peerId: trimmedPeer, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Visual fingerprint for ${shortId(trimmedPeer)}',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Mockup scenario (Process 2):',
            style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Accept & Send'),
                selected: _outcome == _MockSendOutcome.success,
                onSelected: (_) =>
                    setState(() => _outcome = _MockSendOutcome.success),
              ),
              ChoiceChip(
                label: const Text('Peer Offline'),
                selected: _outcome == _MockSendOutcome.peerOffline,
                onSelected: (_) =>
                    setState(() => _outcome = _MockSendOutcome.peerOffline),
              ),
              ChoiceChip(
                label: const Text('Declined'),
                selected: _outcome == _MockSendOutcome.peerDeclined,
                onSelected: (_) =>
                    setState(() => _outcome = _MockSendOutcome.peerDeclined),
              ),
              ChoiceChip(
                label: const Text('Timeout'),
                selected: _outcome == _MockSendOutcome.serverTimeout,
                onSelected: (_) =>
                    setState(() => _outcome = _MockSendOutcome.serverTimeout),
              ),
            ],
          ),
          const SizedBox(height: 22),
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
        ],
      ),
    );
  }

  Widget _buildSending(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final targetId =
        _peerId.text.trim().isNotEmpty ? _peerId.text.trim() : mockPeerId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const KeepAppOpenBanner(),
        const SizedBox(height: 20),
        ResponsiveSplit(
          leftFlex: 5,
          rightFlex: 6,
          spacing: 24,
          left: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
            ),
            child: Center(
              child: TransferProgressBar(
                progress: _progress,
                label: 'Sending',
              ),
            ),
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    PeerAvatar(
                      peerId: targetId,
                      size: 44,
                      showOnlineDot: true,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'To ',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      shortId(targetId),
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FileCard(
                name: _currentFile.name,
                size: _currentFile.size,
                subtitle: _currentFile.mimeLabel,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _cancel,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final (String title, String detail) = switch (_outcome) {
      _MockSendOutcome.peerOffline => (
          'Receiver is not online right now',
          'Server returned PEER_OFFLINE. Ask the recipient to open Longdrop and stay online.',
        ),
      _MockSendOutcome.peerDeclined => (
          'Receiver declined the transfer',
          'The recipient tapped Decline on the incoming transfer request.',
        ),
      _MockSendOutcome.serverTimeout => (
          'Could not reach server, try again',
          'The signaling server did not respond within the 10-second timeout.',
        ),
      _MockSendOutcome.success => ('Transfer interrupted', ''),
    };

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: ErrorAlertGraphic(size: 120)),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                detail,
                textAlign: TextAlign.center,
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => setState(() => _state = _SendState.idle),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDone(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: SuccessCheck()),
              const SizedBox(height: 12),
              Text(
                'Sent successfully',
                textAlign: TextAlign.center,
                style:
                    text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Verified end-to-end encrypted transfer completed with zero compression.',
                textAlign: TextAlign.center,
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              FileCard(
                name: _currentFile.name,
                size: _currentFile.size,
                subtitle: _currentFile.mimeLabel,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _reset,
                child: const Text('Send another'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
