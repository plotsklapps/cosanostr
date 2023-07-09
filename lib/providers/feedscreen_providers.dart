import 'package:cosanostr/all_imports.dart';

final StateProvider<bool> isConnectedProvider = StateProvider<bool>((ref) {
  return false;
});

final StateProvider<RelayApi> relayApiProvider = StateProvider<RelayApi>((ref) {
  return RelayApi(relayUrl: 'wss://relay.damus.io');
});

final StateProvider<List<Event>> eventsProvider =
    StateProvider<List<Event>>((ref) {
  return [];
});

final StateProvider<Map<String, Metadata>> metaDataProvider =
    StateProvider((ref) {
  return {};
});

final StateProvider<String> privateKeyProvider = StateProvider<String>((ref) {
  return '';
});

final StateProvider<String> publicKeyProvider = StateProvider<String>((ref) {
  return '';
});

final StateProvider<bool> keysExistProvider = StateProvider<bool>((ref) {
  return false;
});

final StateProvider<bool> isNotePublishingProvider = StateProvider<bool>((ref) {
  return false;
});
