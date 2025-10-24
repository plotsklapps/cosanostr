import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:nostr_tools/nostr_tools.dart';

class FeedScreenLogic {
  final KeyApi keyApi = KeyApi();
  final Logger logger = Logger();
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  // Generate new keys and add them to secure storage.
  Future<bool> generateNewKeys() async {
    try {
      // Returns a [String] representing the generated private key.
      final String newPrivateKey = keyApi.generatePrivateKey();

      // Returns a [String] representing the generated public key
      // corresponding to the given private key.
      final String newPublicKey = keyApi.getPublicKey(
        newPrivateKey,
      );

      Logger().i('Success! New keys generated!');

      // Update the private and public key in their respective [Providers].
      sPrivateKey.value = newPrivateKey;
      sPublicKey.value = newPublicKey;

      Logger().i(sPublicKey.value);

      // Add the keys to secure storage.
      return addKeysToStorage(
        sPublicKey.value,
        sPrivateKey.value,
      );
    } catch (error) {
      Logger().e('Error generating new keys: $error');
      // Return false if the keys were not successfully generated.
      return false;
    }
  }

  // Add keys to secure storage.
  Future<bool> addKeysToStorage(
    String privateKey,
    String publicKey,
  ) async {
    try {
      // Write the private and public keys to secure storage.
      await Future.wait(<Future<void>>[
        flutterSecureStorage.write(
          key: 'privateKey',
          value: privateKey,
        ),
        flutterSecureStorage.write(
          key: 'publicKey',
          value: publicKey,
        ),
      ]);

      Logger().i('Success! Keys added to secure storage!');

      // Update the keysExist state to true in the [keysExistProvider].
      sKeysExist.value = true;

      // Return true if the keys were successfully added to secure storage.
      return sKeysExist.value;
    } catch (error) {
      Logger().e(
        'Error adding keys to secure storage: $error',
      );
      // Return false if the keys were not successfully added to secure storage.
      return false;
    }
  }

  // Get keys from secure storage.
  Future<void> getKeysFromStorage() async {
    try {
      // Get the private and public keys from secure storage.
      final String? storedPrivateKey = await flutterSecureStorage.read(
        key: 'privateKey',
      );
      final String? storedPublicKey = await flutterSecureStorage.read(
        key: 'publicKey',
      );

      // Update the private and public key in their respective [Providers] if
      // they exist in secure storage. Also update the keysExist state to true
      // in the [keysExistProvider].
      if (storedPrivateKey != null && storedPublicKey != null) {
        sPrivateKey.value = storedPrivateKey;
        sPublicKey.value = storedPublicKey;
        sKeysExist.value = true;

        Logger().i('Success! Keys retrieved from secure storage!');
      } else {
        // If the keys do not exist in secure storage, set the keysExist state
        // to false in the [keysExistProvider].
        sKeysExist.value = false;

        Logger().i('Keys do not exist in secure storage.');
      }
    } catch (error) {
      Logger().e('Error getting keys from secure storage: $error');
      // Method is void so return nothing.
    }
  }

  // Delete keys from secure storage.
  Future<void> deleteKeysFromStorage() async {
    try {
      // Delete the private and public keys from secure storage.
      await Future.wait(<Future<void>>[
        flutterSecureStorage.delete(key: 'privateKey'),
        flutterSecureStorage.delete(key: 'publicKey'),
      ]);

      // Update the private and public key in their respective [Providers] to
      // empty strings. Also update the keysExist state to false in the
      // [keysExistProvider].
      sPrivateKey.value = '';
      sPublicKey.value = '';
      sKeysExist.value = false;

      Logger().i('Success! Keys deleted from secure storage!');
    } catch (error) {
      Logger().e('Error deleting keys from secure storage: $error');
      // Method is void so return nothing.
    }
  }

  // Connect to the relay.
  Future<Stream<Event>> connectToRelay() async {
    // Get the [RelayApi] instance from the [relayApiProvider].
    // final RelayApi relayApi = ref.watch(relayApiProvider);

    // Connect to the relay and return a [Stream] of [Message]s.
    // final Stream<Message> stream = await relayApi.connect();

    // Get the [RelayPoolApi] instance from the [relayPoolProvider].
    final RelayPoolApi relayPool = sRelayPoolApi.value;

    // Connect to the relayPool and return a [Stream] of [Message}s.
    final Stream<Message> poolStream = await relayPool.connect();

    try {
      // Listen for relay events and update the connection status accordingly.
      relayPool.on((RelayEvent event) {
        if (event == RelayEvent.connect) {
          // If the event is "connect", set the isConnected state to true.
          sConnected.value = true;

          Logger().i('Connected to relay: ${relayPool.connectedRelays}');
        } else if (event == RelayEvent.error) {
          // If the event is "error", set the isConnected state to false.
          sConnected.value = false;

          Logger().e('Error connecting to relay: ${relayPool.failedRelays}');
        } else if (event == RelayEvent.disconnect) {
          // If the event is "disconnect", set the isConnected state to false.
          sConnected.value = false;

          Logger().e('Disconnected from relay: ${relayPool.failedRelays}');
        }
      });

      // Subscribe to specific filters on the relay API.
      relayPool.sub(<Filter>[
        Filter(
          // 0 = Metadata
          // 1 = Short Text Note
          // 3 = Contacts
          // 4 = Encrypted Direct Messages
          // 6 = Repost
          // 7 = Reaction
          kinds: <int>[0, 1, 3, 4, 6, 7],
          // Set a limit to the number of messages to receive, otherwise
          // the app will slow down.
          limit: 30,
        ),
      ]);

      // Filter and map the messages stream to get a stream of events.
      return poolStream.where((Message message) {
        return message.type == 'EVENT';
      }).map((Message message) {
        return message.message as Event;
      });
    } catch (error) {
      Logger().e('Error connecting to relay: $error');
      // Return an empty stream if there is an error.
      return const Stream<Event>.empty();
    }
  }
}
