import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../widgets/file_card.dart';
import '../widgets/keep_app_open_banner.dart';
import '../widgets/lottie_graphics.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import '../widgets/responsive_layout.dart';
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
      body: ResponsiveBody(
        child: switch (_state) {
          _ReceiveState.waiting => _buildWaiting(context),
          _ReceiveState.request => _buildRequest(context),
          _ReceiveState.receiving => _buildReceiving(context),
          _ReceiveState.done => _buildDone(context),
        },
      ),
    );
  }

  Widget _buildWaiting(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ResponsiveSplit(
      leftFlex: 5,
      rightFlex: 6,
      spacing: 24,
      left: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withOpacity(0.5),
              scheme.secondaryContainer.withOpacity(0.45),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            const Center(child: PulseRings(size: 210)),
            const SizedBox(height: 12),
            Text(
              'Waiting for connection...',
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Keep this screen open. Senders can reach you with your ID.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      right: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Receiver Status',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const PeerAvatar(
                    peerId: mockMyId,
                    size: 44,
                    showOnlineDot: true,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Listening as ${shortId(mockMyId)}',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Signaling WebSocket open · STUN/TURN ready',
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => setState(() => _state = _ReceiveState.request),
              icon: const Icon(PhosphorIconsRegular.bellRinging),
              label: const Text('Simulate incoming request (mockup)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequest(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Card(
          color: scheme.surfaceContainerHighest.withOpacity(0.55),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                const PeerAvatar(
                  peerId: mockPeerId,
                  size: 76,
                  showOnlineDot: true,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Incoming request',
                    style: text.labelLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  shortId(mockPeerId),
                  style: text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'wants to send you a file',
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                const FileCard(name: mockFileName, size: mockFileSize),
                const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildReceiving(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
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
                label: 'Receiving',
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
                    const PeerAvatar(
                      peerId: mockPeerId,
                      size: 44,
                      showOnlineDot: true,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'From ',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      shortId(mockPeerId),
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const FileCard(name: mockFileName, size: mockFileSize),
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
                'Received',
                textAlign: TextAlign.center,
                style:
                    text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Decrypted and verified locally with original file quality.',
                textAlign: TextAlign.center,
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              const FileCard(name: mockFileName, size: mockFileSize),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => setState(() => _state = _ReceiveState.waiting),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
