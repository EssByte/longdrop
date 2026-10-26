import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/lottie_graphics.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import '../widgets/responsive_layout.dart';

enum _OnboardingStep { chooseMode, newPhrase, restorePhrase, ready }

/// MOCKUP: First-launch identity generation & 12-word BIP39 backup/restore flow
/// from Process 1 (Registration) in `docs/architecture.md`.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  _OnboardingStep _step = _OnboardingStep.chooseMode;
  bool _confirmedSaved = false;
  bool _restoredMode = false;
  final TextEditingController _restoreController = TextEditingController();

  int get _enteredWordCount {
    final raw = _restoreController.text.trim();
    if (raw.isEmpty) return 0;
    return raw.split(RegExp(r'\s+')).length;
  }

  @override
  void dispose() {
    _restoreController.dispose();
    super.dispose();
  }

  void _fillSamplePhrase() {
    setState(() {
      _restoreController.text = mockBackupWords.join(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity & Backup'),
      ),
      body: ResponsiveBody(
        child: ResponsiveSplit(
          leftFlex: 5,
          rightFlex: 7,
          left: _buildOverviewCard(context),
          right: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: switch (_step) {
                _OnboardingStep.chooseMode => _buildChooseMode(context),
                _OnboardingStep.newPhrase => _buildNewPhrase(context),
                _OnboardingStep.restorePhrase => _buildRestorePhrase(context),
                _OnboardingStep.ready => _buildReady(context),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withOpacity(0.65),
            scheme.secondaryContainer.withOpacity(0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: OrbitBadge(
              size: 132,
              icon: PhosphorIconsFill.shieldCheck,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Key-Based Identity',
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Longdrop has no accounts or servers storing your profile. '
            'A 128-bit random seed generates your permanent public key ID locally on this device.',
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          const _InfoRow(
            icon: PhosphorIconsFill.key,
            title: 'X25519 + Ed25519 Keys',
            subtitle: 'Stored in Android Keystore / iOS Keychain',
          ),
          const SizedBox(height: 12),
          const _InfoRow(
            icon: PhosphorIconsFill.notebook,
            title: '12-Word BIP39 Recovery',
            subtitle: 'Restore your exact ID on a new phone without a server',
          ),
        ],
      ),
    );
  }

  Widget _buildChooseMode(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
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
            'First Launch Setup (Mockup)',
            style: text.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Do you have a 12-word backup phrase?',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Preview both branches of Process 1 (Registration) from architecture.md.',
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _ModeOptionCard(
            icon: PhosphorIconsFill.sparkle,
            title: 'Generate New Identity',
            subtitle:
                'Create a fresh 128-bit seed and view your 12-word recovery phrase once.',
            filled: true,
            onTap: () => setState(() {
              _confirmedSaved = false;
              _restoredMode = false;
              _step = _OnboardingStep.newPhrase;
            }),
          ),
          const SizedBox(height: 14),
          _ModeOptionCard(
            icon: PhosphorIconsFill.arrowCounterClockwise,
            title: 'Restore from 12-Word Phrase',
            subtitle:
                'Reinstall recovery: enter your 12 BIP39 words to regenerate the same ID.',
            onTap: () => setState(() {
              _restoredMode = true;
              _step = _OnboardingStep.restorePhrase;
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.04, duration: 250.ms);
  }

  Widget _buildNewPhrase(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
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
                  'Your 12-Word Backup Phrase',
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await Clipboard.setData(
                    ClipboardData(text: mockBackupWords.join(' ')),
                  );
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Backup phrase copied')),
                  );
                },
                icon: const Icon(PhosphorIconsRegular.copy, size: 18),
                label: const Text('Copy'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIconsFill.warning,
                  color: scheme.onTertiaryContainer,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Write this down, it is the ONLY way to recover your ID.',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onTertiaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth >= 360 ? 3 : 2;
              const spacing = 8.0;
              final itemWidth =
                  (constraints.maxWidth - (spacing * (cols - 1))) / cols;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(mockBackupWords.length, (index) {
                  return SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: text.labelSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              mockBackupWords[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: _confirmedSaved,
            onChanged: (v) => setState(() => _confirmedSaved = v ?? false),
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'I have written down these 12 words in a safe place',
              style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => _step = _OnboardingStep.chooseMode),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _confirmedSaved
                      ? () => setState(() => _step = _OnboardingStep.ready)
                      : null,
                  child: const Text('Derive Keys'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestorePhrase(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final count = _enteredWordCount;
    final valid = count == 12;

    return Container(
      padding: const EdgeInsets.all(24),
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
                  'Restore 12-Word Phrase',
                  style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: _fillSamplePhrase,
                icon: const Icon(PhosphorIconsRegular.magicWand, size: 18),
                label: const Text('Fill sample phrase'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your 12 BIP39 words separated by spaces to recover the exact same 128-bit seed and permanent ID.',
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _restoreController,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: '12-word recovery phrase',
              hintText: 'ocean velvet timber glacier ...',
              helperText: '$count / 12 words entered',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => _step = _OnboardingStep.chooseMode),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: valid
                      ? () => setState(() => _step = _OnboardingStep.ready)
                      : null,
                  child: const Text('Recover ID'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReady(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: SuccessCheck(size: 120)),
          const SizedBox(height: 12),
          Text(
            _restoredMode
                ? 'Identity Recovered & Registered'
                : 'Identity Created & Registered',
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Private keys stored in secure hardware. Signaling server returned REGISTER_OK.',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
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
                  size: 46,
                  showOnlineDot: true,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permanent Public Key ID',
                        style: text.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const SelectableText(
                        mockMyId,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => _step = _OnboardingStep.chooseMode),
                  child: const Text('Replay Flow'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Return Home'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.surface.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: scheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  const _ModeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final bg = filled ? scheme.primary : scheme.secondaryContainer;
    final fg = filled ? scheme.onPrimary : scheme.onSecondaryContainer;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: fg.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: fg, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        color: fg.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(PhosphorIconsBold.caretRight, color: fg, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
