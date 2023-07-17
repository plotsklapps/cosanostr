import 'package:cosanostr/all_imports.dart';

// isConnectedProvider holds the status of our relay connection.
final StateProvider<bool> isConnectedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<RelayPoolApi> relayPoolProvider =
    StateProvider<RelayPoolApi>((StateProviderRef<RelayPoolApi> ref) {
  return RelayPoolApi(
    relaysList: <String>[
      'wss://relay.damus.io',
      'wss://nostr.wine',
      'wss://relay.plebstr.com',
      'wss://relay.snort.social',
      'wss://relay.primal.net',
    ],
  );
});

// relayApiProvider creates an instance of RelayApi, which is defined in
// nostr_tools. It requires the relay URL as an argument.
final StateProvider<RelayApi> relayApiProvider =
    StateProvider<RelayApi>((StateProviderRef<RelayApi> ref) {
  return RelayApi(relayUrl: 'wss://relay.damus.io');
});

// keyApiProvider creates an instance of KeyApi, which is defined in
// nostr_tools.
final StateProvider<KeyApi> keyApiProvider =
    StateProvider<KeyApi>((StateProviderRef<KeyApi> ref) {
  return KeyApi();
});

final StateProvider<FlutterSecureStorage> secureStorageProvider =
    StateProvider<FlutterSecureStorage>(
        (StateProviderRef<FlutterSecureStorage> ref) {
  return const FlutterSecureStorage();
});

final StateProvider<Nip19> nip19Provider =
    StateProvider<Nip19>((StateProviderRef<Nip19> ref) {
  return Nip19();
});

// eventsProvider is a list that will hold all the events that we'll get
// from the relay after subscribing.
final StateProvider<List<Event>> eventsProvider =
    StateProvider<List<Event>>((StateProviderRef<List<Event>> ref) {
  return <Event>[];
});

// metaDataProvider  is a map that will hold the mapping of the public key
// with the user metadata.
final StateProvider<Map<String, Metadata>> metaDataProvider =
    StateProvider<Map<String, Metadata>>(
        (StateProviderRef<Map<String, Metadata>> ref) {
  return <String, Metadata>{};
});

final StateProvider<String> privateKeyProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});

final StateProvider<String> publicKeyProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});

final StateProvider<bool> keysExistProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<GlobalKey<FormFieldState<dynamic>>> formKeyProvider =
    StateProvider<GlobalKey<FormFieldState<dynamic>>>((_) {
  return GlobalKey<FormFieldState<dynamic>>();
});

final StateProvider<bool> isNotePublishingProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

// keyControllerProvider provides a TextEditingController for the
// private key input field.
final StateProvider<TextEditingController> keyControllerProvider =
    StateProvider<TextEditingController>(
        (StateProviderRef<TextEditingController> ref) {
  return TextEditingController();
});
