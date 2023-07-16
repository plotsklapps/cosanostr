import 'package:cosanostr/all_imports.dart';

class FeedScreenLogic {
  // Generate new keys and add them to secure storage.
  Future<bool> generateNewKeys(WidgetRef ref) async {
    // First, create a variable String newPrivateKey with the generatePrivateKey
    // method from KeyApi() instance.
    // This is the nsec.
    final String newPrivateKey = ref.watch(keyApiProvider).generatePrivateKey();

    // Second, create a variable String newPublicKey with the getPublicKey
    // method with the newPrivateKey parameter from KeyApi() instance.
    // This is the npub.
    final String newPublicKey =
        ref.watch(keyApiProvider).getPublicKey(newPrivateKey);

    // Third, store  these new keys to the secure storage via
    // flutter_secure_storage package.
    return FeedScreenLogic().addKeysToStorage(ref, newPrivateKey, newPublicKey);
  }

  // Add keys to secure storage.
  Future<bool> addKeysToStorage(
    WidgetRef ref,
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    // Retrieves an instance of FlutterSecureStorage using the
    // secureStorageProvider.
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

    // The keys from generateNewKeys method get written to the
    // FlutterSecureStorage instance, for which we wait.
    await Future.wait(<Future<void>>[
      secureStorage.write(key: 'privateKey', value: privateKeyHex),
      secureStorage.write(key: 'publicKey', value: publicKeyHex),
    ]);

    // Set the variables to their respective Providers.
    ref.read(privateKeyProvider.notifier).state = privateKeyHex;
    ref.read(publicKeyProvider.notifier).state = publicKeyHex;
    ref.read(keysExistProvider.notifier).state = true;

    // Return the bool for if the keys exist. In this case, should be true.
    return ref.watch(keysExistProvider);
  }

  // Get keys from secure storage.
  Future<void> getKeysFromStorage(WidgetRef ref) async {
    // Retrieves an instance of FlutterSecureStorage using the
    // secureStorageProvider.
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

    // Fetch the npub & nsec from secureStorage and store them in local Strings
    final String? storedPrivateKey =
        await secureStorage.read(key: 'privateKey');
    final String? storedPublicKey = await secureStorage.read(key: 'publicKey');

    // Store the local Strings to their respective Providers and set bool
    // for if the keys exist to true.
    if (storedPrivateKey != null && storedPublicKey != null) {
      ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
      ref.read(publicKeyProvider.notifier).state = storedPublicKey;
      ref.read(keysExistProvider.notifier).state = true;
    }
  }

  // Delete keys from secure storage.
  Future<void> deleteKeysFromStorage(WidgetRef ref) async {
    // Retrieves an instance of FlutterSecureStorage using the
    // secureStorageProvider.
    final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

    // Delete the npub & nsec from secureStorage
    await Future.wait(<Future<void>>[
      secureStorage.delete(key: 'privateKey'),
      secureStorage.delete(key: 'publicKey'),
    ]);

    // Set the Providers to an empty String and set bool for if the keys
    // exist to false.
    ref.read(privateKeyProvider.notifier).state = '';
    ref.read(publicKeyProvider.notifier).state = '';
    ref.read(keysExistProvider.notifier).state = false;
  }

  // Connect to the relay.
  Future<Stream<Event>> connectToRelay(WidgetRef ref) async {
    // Establishes a connection to the relay API and returns a stream of
    // messages.
    final Stream<Message> stream = await ref.read(relayPoolProvider).connect();

    // This sets up an event listener for relayApiProvider, which will be
    // triggered whenever relayApiProvider emits a RelayEvent.
    ref.read(relayPoolProvider).on((RelayEvent event) {
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
    ref.read(relayPoolProvider).sub(<Filter>[
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
