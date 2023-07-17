import 'package:cosanostr/all_imports.dart';

class FeedScreenLogic {
  // Generate new keys and add them to secure storage.
  Future<bool> generateNewKeys(WidgetRef ref) async {
    final String newPrivateKey = ref.watch(keyApiProvider).generatePrivateKey();
    final String newPublicKey = ref.watch(keyApiProvider).getPublicKey(
          newPrivateKey,
        );

    return FeedScreenLogic().addKeysToStorage(
      ref,
      newPrivateKey,
      newPublicKey,
    );
  }

  // Add keys to secure storage.
  Future<bool> addKeysToStorage(
    WidgetRef ref,
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    await Future.wait(<Future<void>>[
      ref
          .read(secureStorageProvider)
          .write(key: 'privateKey', value: privateKeyHex),
      ref
          .read(secureStorageProvider)
          .write(key: 'publicKey', value: publicKeyHex),
    ]);
    ref.read(privateKeyProvider.notifier).state = privateKeyHex;
    ref.read(publicKeyProvider.notifier).state = publicKeyHex;
    ref.read(keysExistProvider.notifier).state = true;

    return ref.watch(keysExistProvider);
  }

  // Get keys from secure storage.
  Future<void> getKeysFromStorage(WidgetRef ref) async {
    final String? storedPrivateKey =
        await ref.read(secureStorageProvider).read(key: 'privateKey');
    final String? storedPublicKey =
        await ref.read(secureStorageProvider).read(key: 'publicKey');

    if (storedPrivateKey != null && storedPublicKey != null) {
      ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
      ref.read(publicKeyProvider.notifier).state = storedPublicKey;
      ref.read(keysExistProvider.notifier).state = true;
    }
  }

  // Delete keys from secure storage.
  Future<void> deleteKeysFromStorage(WidgetRef ref) async {
    await Future.wait(<Future<void>>[
      ref.read(secureStorageProvider).delete(key: 'privateKey'),
      ref.read(secureStorageProvider).delete(key: 'publicKey'),
    ]);
    ref.read(privateKeyProvider.notifier).state = '';
    ref.read(publicKeyProvider.notifier).state = '';
    ref.read(keysExistProvider.notifier).state = false;
  }

  // Connect to the relay.
  Future<Stream<Event>> connectToRelay(WidgetRef ref) async {
    // Connect to the relay API and get a stream of messages.
    final Stream<Message> stream = await ref.read(relayApiProvider).connect();

    // Listen for relay events and update the connection status accordingly.
    ref.read(relayApiProvider).on((RelayEvent event) {
      if (event == RelayEvent.connect) {
        // If the event is "connect", set the isConnected state to true.
        ref.read(isConnectedProvider.notifier).state = true;
        print('Connected to relay: ${ref.watch(relayApiProvider).relayUrl}');
      } else if (event == RelayEvent.error) {
        // If the event is "error", set the isConnected state to false.
        ref.read(isConnectedProvider.notifier).state = false;
        print(
          'Error connecting to relay: ${ref.watch(relayApiProvider).relayUrl}',
        );
      } else if (event == RelayEvent.disconnect) {
        // If the event is "disconnect", set the isConnected state to false.
        ref.read(isConnectedProvider.notifier).state = false;
        print(
          'Disconnected from relay: ${ref.watch(relayApiProvider).relayUrl}',
        );
      }
    });

    // Subscribe to specific filters on the relay API.
    ref.read(relayApiProvider).sub(<Filter>[
      Filter(
        kinds: <int>[1],
        t: <String>['nost'],
        limit: 150,
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
