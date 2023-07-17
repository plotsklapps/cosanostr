// This file is NOT used, it's just another option instead of nostr_tools.

import 'dart:async';

import 'package:cosanostr/all_imports.dart';

Future<void> nostrLogic() async {
  // This method will enable the logs of the library.
  Nostr.instance.enableLogs();

  // generates a key pair.
  final NostrKeyPairs keyPair = Nostr.instance.keysService.generateKeyPair();

  // init relays
  await Nostr.instance.relaysService.init(
    relaysUrl: <String>['wss://relay.damus.io'],
  );

  final String currentDateInMsAsString =
      DateTime.now().millisecondsSinceEpoch.toString();

  // create an event
  final NostrEvent event = NostrEvent.fromPartialData(
    kind: 1,
    content: 'example content',
    keyPairs: keyPair,
    tags: <List<String>>[
      <String>['t', currentDateInMsAsString],
    ],
  );

  // send the event
  Nostr.instance.relaysService.sendEventToRelays(event);

  await Future<void>.delayed(const Duration(seconds: 5));

  // create a subscription id.
  final String subscriptionId = Nostr.instance.utilsService.random64HexChars();

  // creating a request for listening to events.
  final NostrRequest request = NostrRequest(
    subscriptionId: subscriptionId,
    filters: <NostrFilter>[
      NostrFilter(
        kinds: const <int>[1],
        t: <String>[currentDateInMsAsString],
        authors: <String>[keyPair.public],
      ),
    ],
  );

// listen to events
  final NostrEventsStream sub =
      Nostr.instance.relaysService.startEventsSubscription(request: request);

  final StreamSubscription<dynamic> subscription = sub.stream.listen(
    (NostrEvent event) {
      print(event);
    },
    onDone: () {
      print('done');
    },
  );

  await Future<void>.delayed(const Duration(seconds: 5));

  // cancel the subscription
  await subscription.cancel().whenComplete(() {
    Nostr.instance.relaysService.closeEventsSubscription(subscriptionId);
  });

  await Future<void>.delayed(const Duration(seconds: 5));

  // create a new event that will not be received by the subscription because
  // it is closed.
  final NostrEvent event2 = NostrEvent.fromPartialData(
    kind: 1,
    content: 'example content',
    keyPairs: keyPair,
    tags: <List<String>>[
      <String>['t', currentDateInMsAsString],
    ],
  );

  // send the event 2 that will not be received by the subscription because
  // it is closed.
  Nostr.instance.relaysService.sendEventToRelays(event2);
}
