import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Looping "listening" rings with an icon in the middle. Rings follow the
/// theme's primary color.
class PulseRings extends StatelessWidget {
  const PulseRings({super.key, this.size = 220});

  final double size;

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
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primaryContainer,
            ),
            child: Icon(
              PhosphorIconsRegular.downloadSimple,
              color: scheme.onPrimaryContainer,
              size: size * 0.14,
            ),
          ),
        ],
      ),
    );
  }
}

/// A circle that pops in and draws a check mark, once.
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
          ValueDelegate.color(const ['circle', '**'], value: scheme.primary),
          ValueDelegate.color(const ['check', '**'], value: scheme.onPrimary),
        ],
      ),
    );
  }
}
