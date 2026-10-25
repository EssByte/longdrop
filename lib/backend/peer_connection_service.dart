// STUB — to be implemented by the project owner. Signatures only.

abstract class PeerConnectionService {
  // TODO(backend): signaling + WebRTC connection to a peer by ID.
  Future<void> connect(String peerId);

  // TODO(backend): encrypt, chunk and send a file over the connection.
  Future<void> sendFile(String path);

  // TODO(backend): listen for incoming connections / transfer requests.
  Future<void> listen();

  // TODO(backend): close the connection.
  Future<void> disconnect();
}
