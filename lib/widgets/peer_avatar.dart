import 'package:flutter/material.dart';

/// "3Fh8Qw2nKxP9…" -> "3Fh8…xP9": a short, readable form of a peer ID.
String shortId(String id) => id.length <= 10
    ? id
    : '${id.substring(0, 4)}…${id.substring(id.length - 4)}';

/// Deterministic gradient avatar derived from a peer ID, so the same ID always
/// looks the same (a quick visual check that you are sending to the right person).
class PeerAvatar extends StatelessWidget {
  const PeerAvatar({super.key, required this.peerId, this.size = 48});

  final String peerId;
  final double size;

  Color _color(int shift) {
    final hash =
        peerId.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) & 0xFFFFFF);
    return HSLColor.fromAHSL(1, ((hash + shift) % 360).toDouble(), 0.62, 0.52)
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final letters = peerId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final initials =
        (letters.length >= 2 ? letters.substring(0, 2) : letters).toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color(0), _color(55)],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
