import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../widgets/keep_app_open_banner.dart';
import '../widgets/lottie_graphics.dart';
import '../widgets/mock_transfer.dart';
import '../widgets/peer_avatar.dart';
import '../widgets/responsive_layout.dart';
import 'my_id_screen.dart';
import 'onboarding_screen.dart';
import 'receive_screen.dart';
import 'send_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MockServerStatus _serverStatus = MockServerStatus.registered;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  void _cycleServerStatus() {
    setState(() {
      const values = MockServerStatus.values;
      final next = (_serverStatus.index + 1) % values.length;
      _serverStatus = values[next];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showRail = Breakpoints.isExpanded(constraints.maxWidth);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Longdrop'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ActionChip(
                  avatar: const Icon(PhosphorIconsRegular.key, size: 16),
                  label: const Text('12-Word Setup'),
                  tooltip: 'Preview first-launch 12-word backup & restore flow',
                  onPressed: () => _open(context, const OnboardingScreen()),
                ),
              ),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showRail) _buildDesktopRail(context),
              Expanded(
                child: ResponsiveBody(
                  child: ResponsiveSplit(
                    leftFlex: 5,
                    rightFlex: 6,
                    spacing: 24,
                    left: _buildHeroPanel(context),
                    right: _buildActionsColumn(context),
                  ).animate().fadeIn(duration: 350.ms).slideY(
                        begin: 0.04,
                        duration: 350.ms,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopRail(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: scheme.outlineVariant.withOpacity(0.45)),
        ),
      ),
      child: NavigationRail(
        selectedIndex: 0,
        labelType: NavigationRailLabelType.none,
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              _open(context, const SendScreen());
            case 2:
              _open(context, const ReceiveScreen());
            case 3:
              _open(context, const MyIdScreen());
            case 4:
              _open(context, const OnboardingScreen());
          }
        },
        destinations: const [
          NavigationRailDestination(
            icon: Tooltip(
              message: 'Home Hub',
              child: Icon(PhosphorIconsRegular.house),
            ),
            selectedIcon: Tooltip(
              message: 'Home Hub',
              child: Icon(PhosphorIconsFill.house),
            ),
            label: Text('Hub'),
          ),
          NavigationRailDestination(
            icon: Tooltip(
              message: 'Send File',
              child: Icon(PhosphorIconsRegular.paperPlaneTilt),
            ),
            label: Text('Send'),
          ),
          NavigationRailDestination(
            icon: Tooltip(
              message: 'Receive File',
              child: Icon(PhosphorIconsRegular.downloadSimple),
            ),
            label: Text('Receive'),
          ),
          NavigationRailDestination(
            icon: Tooltip(
              message: 'My ID',
              child: Icon(PhosphorIconsRegular.qrCode),
            ),
            label: Text('ID'),
          ),
          NavigationRailDestination(
            icon: Tooltip(
              message: 'Identity & 12-Word Backup',
              child: Icon(PhosphorIconsRegular.shieldCheck),
            ),
            label: Text('Backup'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withOpacity(0.55),
            scheme.secondaryContainer.withOpacity(0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.55),
        ),
      ),
      child: Column(
        children: [
          const OrbitBadge(
            size: 124,
            icon: PhosphorIconsFill.paperPlaneTilt,
          ),
          const SizedBox(height: 16),
          Text(
            'Send files, privately.',
            textAlign: TextAlign.center,
            style: text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'End-to-end encrypted. No account. Full quality.',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _FeaturePill(
                icon: PhosphorIconsFill.lockKey,
                label: 'E2EE X25519',
              ),
              _FeaturePill(
                icon: PhosphorIconsFill.globeHemisphereWest,
                label: 'Cross-Border P2P',
              ),
              _FeaturePill(
                icon: PhosphorIconsFill.sparkle,
                label: 'Uncompressed',
              ),
            ],
          ),
          const SizedBox(height: 20),
          ServerStatusBanner(
            status: _serverStatus,
            onCycleStatus: _cycleServerStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionCard(
          icon: PhosphorIconsFill.paperPlaneTilt,
          title: 'Send File',
          subtitle: 'Pick a file and a recipient',
          badgeText: 'Direct WebRTC',
          filled: true,
          onTap: () => _open(context, const SendScreen()),
        ),
        const SizedBox(height: 14),
        _ActionCard(
          icon: PhosphorIconsFill.downloadSimple,
          title: 'Receive File',
          subtitle: 'Wait for an incoming transfer',
          badgeText: 'Listen Mode',
          onTap: () => _open(context, const ReceiveScreen()),
        ),
        const SizedBox(height: 14),
        _IdCard(onTap: () => _open(context, const MyIdScreen())),
      ],
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: text.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
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
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: fg.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: fg, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: text.titleMedium?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: fg.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              badgeText!,
                              style: text.labelSmall?.copyWith(
                                color: fg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
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
              Icon(PhosphorIconsBold.caretRight, color: fg, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  const _IdCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Material(
      color: scheme.surfaceContainerHighest.withOpacity(0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const PeerAvatar(
                peerId: mockMyId,
                size: 48,
                showOnlineDot: true,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My ID',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${shortId(mockMyId)} · Public key & QR',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIconsRegular.qrCode,
                  color: scheme.onPrimaryContainer,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
