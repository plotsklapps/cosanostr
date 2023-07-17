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
    final Stream<Message> stream = await ref.read(relayApiProvider).connect();

    ref.read(relayApiProvider).on((RelayEvent event) {
      if (event == RelayEvent.connect) {
        ref.read(isConnectedProvider.notifier).state = true;
      } else if (event == RelayEvent.error) {
        ref.read(isConnectedProvider.notifier).state = false;
      } else if (event == RelayEvent.disconnect) {
        ref.read(isConnectedProvider.notifier).state = false;
      }
    });

    ref.read(relayApiProvider).sub(<Filter>[
      Filter(
        kinds: <int>[1],
        limit: 100,
        t: <String>['nostr'],
      )
    ]);

    return stream.where((Message message) {
      return message.type == 'EVENT';
    }).map((Message message) {
      return message.message as Event;
    });
  }
}
