// STUB — to be implemented by the project owner. Signatures only.

abstract class KeyService {
  // TODO(backend): plug in key generation here.
  Future<void> generateKeyPair();

  // TODO(backend): return the public key (also the user's ID).
  Future<String> getPublicKey();
}
