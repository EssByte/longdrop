import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend/peer_connection_service.dart';

/// Provides the [PeerConnectionService] backend.
///
/// `PeerConnectionService` is still an abstract stub, so there is nothing to
/// construct yet. Once the owner adds a concrete implementation, replace the
/// body with e.g. `(ref) => PeerConnectionServiceImpl()`.
final peerConnectionServiceProvider = Provider<PeerConnectionService>((ref) {
  throw UnimplementedError(
    'PeerConnectionService has no implementation yet '
    '(lib/backend/ is still a stub).',
  );
});
