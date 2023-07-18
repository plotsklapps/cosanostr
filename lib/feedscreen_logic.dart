import 'package:cosanostr/all_imports.dart';

class FeedScreenLogic {
  // Generate new keys and add them to secure storage.
  Future<bool> generateNewKeys(WidgetRef ref) async {
    try {
      // Get the [KeyApi] instance from the [keyApiProvider].
      final KeyApi keyApi = ref.watch(keyApiProvider);

      // Returns a [String] representing the generated private key.
      final String newPrivateKey = keyApi.generatePrivateKey();

      // Returns a [String] representing the generated public key
      // corresponding to the given private key.
      final String newPublicKey = keyApi.getPublicKey(
        newPrivateKey,
      );

      Logger().i('Success! New keys generated!');

      // Update the private and public key in their respective [Providers].
      ref.read(privateKeyProvider.notifier).state = newPrivateKey;
      ref.read(publicKeyProvider.notifier).state = newPublicKey;

      // Add the keys to secure storage.
      return addKeysToStorage(
        ref,
        ref.watch(privateKeyProvider),
        ref.watch(publicKeyProvider),
      );
    } catch (error) {
      Logger().e('Error generating new keys: $error');
      // Return false if the keys were not successfully generated.
      return false;
    }
  }

  // Add keys to secure storage.
  Future<bool> addKeysToStorage(
    WidgetRef ref,
    String privateKey,
    String publicKey,
  ) async {
    try {
      // Get the [FlutterSecureStorage] instance from the
      // [secureStorageProvider].
      final FlutterSecureStorage secureStorage =
          ref.watch(secureStorageProvider);

      // Write the private and public keys to secure storage.
      await Future.wait(<Future<void>>[
        secureStorage.write(key: 'privateKey', value: privateKey),
        secureStorage.write(key: 'publicKey', value: publicKey),
      ]);

      Logger().i('Success! Keys added to secure storage!');

      // Update the keysExist state to true in the [keysExistProvider].
      ref.read(keysExistProvider.notifier).state = true;

      // Return true if the keys were successfully added to secure storage.
      return ref.watch(keysExistProvider);
    } catch (error) {
      Logger().e(
        'Error adding keys to secure storage: $error',
      );
      // Return false if the keys were not successfully added to secure storage.
      return false;
    }
  }

  // Get keys from secure storage.
  Future<void> getKeysFromStorage(WidgetRef ref) async {
    try {
      // Get the [FlutterSecureStorage] instance from the
      // [secureStorageProvider].
      final FlutterSecureStorage secureStorage =
          ref.read(secureStorageProvider);

      // Get the private and public keys from secure storage.
      final String? storedPrivateKey = await secureStorage.read(
        key: 'privateKey',
      );
      final String? storedPublicKey = await secureStorage.read(
        key: 'publicKey',
      );

      // Update the private and public key in their respective [Providers] if
      // they exist in secure storage. Also update the keysExist state to true
      // in the [keysExistProvider].
      if (storedPrivateKey != null && storedPublicKey != null) {
        ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
        ref.read(publicKeyProvider.notifier).state = storedPublicKey;
        ref.read(keysExistProvider.notifier).state = true;

        Logger().i('Success! Keys retrieved from secure storage!');
      } else {
        // If the keys do not exist in secure storage, set the keysExist state
        // to false in the [keysExistProvider].
        ref.read(keysExistProvider.notifier).state = false;

        Logger().i('Keys do not exist in secure storage.');
      }
    } catch (error) {
      Logger().e('Error getting keys from secure storage: $error');
      // Method is void so return nothing.
    }
  }

  // Delete keys from secure storage.
  Future<void> deleteKeysFromStorage(WidgetRef ref) async {
    try {
      // Get the [FlutterSecureStorage] instance from the
      // [secureStorageProvider].
      final FlutterSecureStorage secureStorage =
          ref.read(secureStorageProvider);

      // Delete the private and public keys from secure storage.
      await Future.wait(<Future<void>>[
        secureStorage.delete(key: 'privateKey'),
        secureStorage.delete(key: 'publicKey'),
      ]);

      // Update the private and public key in their respective [Providers] to
      // empty strings. Also update the keysExist state to false in the
      // [keysExistProvider].
      ref.read(privateKeyProvider.notifier).state = '';
      ref.read(publicKeyProvider.notifier).state = '';
      ref.read(keysExistProvider.notifier).state = false;

      Logger().i('Success! Keys deleted from secure storage!');
    } catch (error) {
      Logger().e('Error deleting keys from secure storage: $error');
      // Method is void so return nothing.
    }
  }

  // Connect to the relay.
  Future<Stream<Event>> connectToRelay(WidgetRef ref) async {
    // Get the [RelayApi] instance from the [relayApiProvider].
    final RelayApi relayApi = ref.watch(relayApiProvider);

    // Connect to the relay and return a [Stream] of [Message]s.
    final Stream<Message> stream = await relayApi.connect();

    // Listen for relay events and update the connection status accordingly.
    relayApi.on((RelayEvent event) {
      if (event == RelayEvent.connect) {
        // If the event is "connect", set the isConnected state to true.
        ref.read(isConnectedProvider.notifier).state = true;

        Logger().i('Connected to relay: ${relayApi.relayUrl}');
      } else if (event == RelayEvent.error) {
        // If the event is "error", set the isConnected state to false.
        ref.read(isConnectedProvider.notifier).state = false;

        Logger().e('Error connecting to relay: ${relayApi.relayUrl}');
      } else if (event == RelayEvent.disconnect) {
        // If the event is "disconnect", set the isConnected state to false.
        ref.read(isConnectedProvider.notifier).state = false;

        Logger().e('Disconnected from relay: ${relayApi.relayUrl}');
      }
    });

    // Subscribe to specific filters on the relay API.
    relayApi.sub(<Filter>[
      Filter(
        kinds: <int>[0, 1, 2, 3, 4, 6, 7],
        limit: 100,
      )
    ]);

    // Filter and map the messages stream to get a stream of events.
    return stream.where((Message message) {
      return message.type == 'EVENT';
    }).map((Message message) {
      return message.message as Event;
    });
  }
}
