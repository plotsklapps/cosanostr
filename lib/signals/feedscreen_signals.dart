import 'package:nostr_tools/nostr_tools.dart';
import 'package:signals/signals.dart';

final Signal<String> sPrivateKey = Signal<String>(
  '',
  debugLabel: 'sPrivateKey',
);

final Signal<String> sPublicKey = Signal<String>(
  '',
  debugLabel: 'sPublicKey',
);

final Signal<bool> sConnected = Signal<bool>(
  false,
  debugLabel: 'sConnected',
);

final Signal<RelayPoolApi> sRelayPoolApi = Signal<RelayPoolApi>(
  RelayPoolApi(
    relaysList: <String>[
      'wss://relay.damus.io',
      'wss://relay.plebstr.com',
      'wss://relay.snort.social',
      'wss://relay.primal.net',
    ],
  ),
  debugLabel: 'sRelayPool',
);

final Signal<RelayApi> sRelayApi = Signal<RelayApi>(
  RelayApi(relayUrl: 'wss://relay.damus.io'),
  debugLabel: 'sRelayApi',
);

final Signal<List<Event>> sEventsList = Signal<List<Event>>(
  <Event>[],
  debugLabel: 'sEventsList',
);

final Signal<Map<String, Metadata>> sMetaDataMap =
    Signal<Map<String, Metadata>>(
  <String, Metadata>{},
  debugLabel: 'sMetaDataMap',
);

final Signal<bool> sKeysExist = Signal<bool>(
  false,
  debugLabel: 'sKeysExist',
);

final Signal<bool> sNotePublishing = Signal<bool>(
  false,
  debugLabel: 'sNotePublishing',
);
