import 'package:cosanostr/all_imports.dart';

class FeedScreenLogic {
  // Generate new keys and add them to secure storage.
  Future<bool> generateNewKeys(WidgetRef ref) async {
    final String newPrivateKey = ref.watch(keyApiProvider).generatePrivateKey();
    final String newPublicKey =
        ref.watch(keyApiProvider).getPublicKey(newPrivateKey);

    return FeedScreenLogic().addKeysToStorage(ref, newPrivateKey, newPublicKey);
  }

  // Add keys to secure storage.
  Future<bool> addKeysToStorage(
    WidgetRef ref,
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);
    await Future.wait(<Future<void>>[
      secureStorage.write(key: 'privateKey', value: privateKeyHex),
      secureStorage.write(key: 'publicKey', value: publicKeyHex),
    ]);
    ref.read(privateKeyProvider.notifier).state = privateKeyHex;
    ref.read(publicKeyProvider.notifier).state = publicKeyHex;
    ref.read(keysExistProvider.notifier).state = true;

    return ref.watch(keysExistProvider);
  }

  // Get keys from secure storage.
  Future<void> getKeysFromStorage(WidgetRef ref) async {
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

    final String? storedPrivateKey =
        await secureStorage.read(key: 'privateKey');
    final String? storedPublicKey = await secureStorage.read(key: 'publicKey');

    if (storedPrivateKey != null && storedPublicKey != null) {
      ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
      ref.read(publicKeyProvider.notifier).state = storedPublicKey;
      ref.read(keysExistProvider.notifier).state = true;
    }
  }

  // Delete keys from secure storage.
  Future<void> deleteKeysFromStorage(WidgetRef ref) async {
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);
    await Future.wait(<Future<void>>[
      secureStorage.delete(key: 'privateKey'),
      secureStorage.delete(key: 'publicKey'),
    ]);
    ref.read(privateKeyProvider.notifier).state = '';
    ref.read(publicKeyProvider.notifier).state = '';
    ref.read(keysExistProvider.notifier).state = false;
  }

  // Connect to the relay.
  Future<Stream<Event>> connectToRelay(WidgetRef ref) async {
    final Stream<Message> stream = await ref.read(relayApiProvider).connect();

    // This sets up an event listener for relayApiProvider, which will be
    // triggered whenever relayApiProvider emits a RelayEvent.
    ref.read(relayApiProvider).on((RelayEvent event) {
      // This code block checks the type of the emitted RelayEvent.
      // If it is a connect event, isConnectedProvider is set to true.
      // If it is an error event, isConnectedProvider is set to false.
      if (event == RelayEvent.connect) {
        ref.read(isConnectedProvider.notifier).state = true;
      } else if (event == RelayEvent.error) {
        ref.read(isConnectedProvider.notifier).state = false;
      }
    });

    // This code subscribes to nostr relay and specifies that we only want
    // to receive events with a kind value of 1 which is registered for short
    // text note. We also set a limit of 100 events and a tag of nostr.
    // This tag helps us filter out unwanted events and only receive the ones
    // that has the "nostr" tag.
    ref.read(relayApiProvider).sub(<Filter>[
      Filter(
        kinds: <int>[1],
        limit: 100,
        t: <String>['nostr'],
      )
    ]);

    return stream
        .where((Message message) => message.type == 'EVENT')
        .map((Message message) => message.message as Event);
  }
}
