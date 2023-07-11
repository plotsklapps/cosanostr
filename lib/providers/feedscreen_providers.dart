import 'package:cosanostr/all_imports.dart';

// isConnectedProvider holds the status of our relay connection.
final StateProvider<bool> isConnectedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

// relayApiProvider creates an instance of RelayApi, which is defined in
// nostr_tools. It requires the relay URL as an argument.
final StateProvider<RelayApi> relayApiProvider =
    StateProvider<RelayApi>((StateProviderRef<RelayApi> ref) {
  return RelayApi(relayUrl: 'wss://relay.damus.io');
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

final StateProvider<bool> isNotePublishingProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});
