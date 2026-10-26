import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend/key_service.dart';

/// Provides the [KeyService] backend.
///
/// `KeyService` is still an abstract stub, so there is nothing to construct
/// yet. Once the owner adds a concrete implementation, replace the body with
/// e.g. `(ref) => KeyServiceImpl()`.
final keyServiceProvider = Provider<KeyService>((ref) {
  throw UnimplementedError(
    'KeyService has no implementation yet (lib/backend/ is still a stub).',
  );
});

/// The user's public key, which is also their permanent ID.
final publicKeyProvider = FutureProvider<String>((ref) {
  return ref.watch(keyServiceProvider).getPublicKey();
});
