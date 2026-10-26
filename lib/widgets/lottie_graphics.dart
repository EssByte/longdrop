import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Looping "listening" radar rings with an icon in the middle. Rings follow the
/// theme's primary color.
class PulseRings extends StatelessWidget {
  const PulseRings({
    super.key,
    this.size = 220,
    this.icon = PhosphorIconsRegular.downloadSimple,
  });

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/pulse.json',
            width: size,
            height: size,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(const ['**'], value: scheme.primary),
              ],
            ),
          ),
          Container(
            width: size * 0.32,
            height: size * 0.32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary,
                  scheme.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.28),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: scheme.onPrimary,
              size: size * 0.14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Orbiting P2P nodes around a glowing gradient badge. Used on the Home hero,
/// Onboarding identity badge, and active connection states.
class OrbitBadge extends StatelessWidget {
  const OrbitBadge({
    super.key,
    this.size = 136,
    this.icon = PhosphorIconsFill.paperPlaneTilt,
  });

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/orbit.json',
            width: size,
            height: size,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(const ['**'], value: scheme.primary),
              ],
            ),
          ),
          Container(
            width: size * 0.56,
            height: size * 0.56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [scheme.primary, scheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.26),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: scheme.onPrimary,
              size: size * 0.26,
            ),
          ),
        ],
      ),
    );
  }
}

/// A circle that pops in, expands a halo, and draws a check mark once.
class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Lottie.asset(
      'assets/lottie/success.json',
      width: size,
      height: size,
      repeat: false,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(const ['halo', '**'], value: scheme.primary),
          ValueDelegate.color(const ['circle', '**'], value: scheme.primary),
          ValueDelegate.color(const ['check', '**'], value: scheme.onPrimary),
        ],
      ),
    );
  }
}

/// Animated error/warning graphic that pops in and gently shakes once.
class ErrorAlertGraphic extends StatelessWidget {
  const ErrorAlertGraphic({super.key, this.size = 132});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Lottie.asset(
      'assets/lottie/error_alert.json',
      width: size,
      height: size,
      repeat: false,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(const ['circle', '**'], value: scheme.error),
          ValueDelegate.color(const ['cross', '**'], value: scheme.onError),
        ],
      ),
    );
  }
}
