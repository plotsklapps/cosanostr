import 'dart:async';
import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() {
    return FeedScreenState();
  }
}

class FeedScreenState extends ConsumerState<FeedScreen> {
  // Some variables that could've been here were moved to their respective
  // providers. This is because they will soon be used in other screens as
  // well. Next step is setting up a StreamProvider to handle the stream
  // from the relay.
  // TODO(plotsklapps): Set up StreamProvider so it can be used throughout
  //  the app.
  late Stream<Event> stream;
  final StreamController<Event> streamController = StreamController<Event>();

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      await FeedScreenLogic().getKeysFromStorage(ref);
      await initStream();
    });
  }

  @override
  void dispose() {
    ref.read(relayApiProvider).close();
    ref.read(keyControllerProvider).dispose();
    super.dispose();
  }

  Future<void> initStream() async {
    // This line sets up a loop that listens for events from the stream object.
    // The await for construct allows the loop to be asynchronous, meaning
    // that it can listen for incoming events while continuing to run other
    // parts of the program.
    stream = await FeedScreenLogic().connectToRelay(ref);
    // This line checks the type of the incoming message. If it is an event
    // message, the code inside the if block is executed. There are other
    // types of messages that can be received as well, such as "REQ", "CLOSE",
    // "NOTICE", and "OK", but we're only interested in events for now.
    stream.listen((Event message) {
      // This line extracts the message object from the incoming message and
      // assigns it to the event variable. This event object contains all of
      // the information we need about the incoming event.
      final Event event = message;
      // If the kind of the event is 1, the event object is added to the
      // eventProvider list. Then, a new subscription is created to receive
      // messages from the event.pubkey of the author with a kind value of 0.
      // This might sound a bit confusing at first, but it's actually quite
      // simple. Basically, we're subscribing to events that have a kind of 1,
      // which are notes that meet our filtering criteria. After getting the
      // kind 1 note which looks something like:
      // kind: 1 => id: bunch_of_numbers, kind: 1, created_at: 1680869710,
      // pubkey: bunch_of_numbers, sig: bunch_of_numbers, subscriptionId:
      // bunch_of_numbers, tags: [[t, nostr]], content: gm #nostr
      // But, as you can see in the above example of kind 1, these notes
      // don't include any metadata about the user who created them. So, we
      // need to also subscribe to events that have a kind of 0, which are
      // metadata events that provide us with more information about the user
      // such as 'username', 'picture' and the other stuff which is related to
      // that specific user who made the particular event. By doing this, we
      // can associate each note with its corresponding user metadata.
      if (event.kind == 1) {
        ref.read(eventsProvider).add(event);
        ref.read(relayApiProvider).sub(<Filter>[
          Filter(kinds: <int>[0], authors: <String>[event.pubkey])
        ]);
        // If the kind of the event is 0, the content of the event is decoded
        // from JSON and assigned to a metadata variable. This metadata is
        // then associated with the event.pubkey of the author in the
        // metaDataProvider map. This allows us to keep track of the metadata
        // for each user who creates a note.
      } else if (event.kind == 0) {
        final Metadata metadata = Metadata.fromJson(
          jsonDecode(event.content) as Map<String, dynamic>,
        );
        ref.read(metaDataProvider)[event.pubkey] = metadata;
      }
      // Finally, the incoming message is added to the StreamController.
      // This makes the message available to any other parts of the program
      // that are listening to the Stream.
      streamController.add(event);
    });
  }

  // Reconnect and resubscribe to the stream
  Future<void> resubscribeStream(WidgetRef ref) async {
    await Future<void>.delayed(const Duration(seconds: 1), () {
      ref.read(eventsProvider).clear();
      ref.read(metaDataProvider).clear();
      initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pull to refresh, aaahhh!
      body: RefreshIndicator(
        onRefresh: () async {
          await resubscribeStream(ref);
        },
        // This is used to provide better scrolling experience on web.
        // It disables the scrollbar and enables more input devices then
        // just the damn scroll wheel.
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            scrollbars: false,
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
            },
          ),
          // StreamBuilder is a widget that listens to the streamController
          // and returns a widget tree based on the state of the stream.
          child: StreamBuilder<Event>(
            stream: streamController.stream,
            // The builder callback is called whenever a new event is
            // emitted from the stream.
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                // Inside the builder callback, the snapshot object
                // contains the latest event from the stream.
                // If snapshot.hasData is true, we have data to display.
                // In this case, we return a ListView.builder that displays
                // a list of FeedScreenCard widgets.
                return ListView.builder(
                  // The itemCount property of the ListView.builder is set
                  // to eventProvider list length.
                  itemCount: ref.watch(eventsProvider).length,
                  itemBuilder: (BuildContext context, int index) {
                    // For each event, we create a Nost object that
                    // encapsulates the details of the event, including the
                    // id, avatarUrl, name, username, time, content, and
                    // pubkey. Here is the power of the metaDataProvider map
                    // as we're able to map the event pubkey with the
                    // metadata of the author.
                    final Event event = ref.watch(eventsProvider)[index];
                    final Metadata? metadata =
                        ref.watch(metaDataProvider)[event.pubkey];
                    final Nost nost = Nost(
                      noteId: event.id,
                      avatarUrl: metadata?.picture ??
                          'https://robohash.org/${event.pubkey}',
                      name: metadata?.name ?? 'Anon',
                      username: metadata?.displayName ??
                          (metadata?.display_name ?? 'Anon'),
                      time: TimeAgo.format(event.created_at),
                      content: event.content,
                      pubkey: event.pubkey,
                    );
                    // We then create a FeedScreenCard widget with the Nost
                    // object as input and return it from the itemBuilder.
                    return FeedScreenCard(nost: nost);
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                // If snapshot.connectionState is ConnectionState.waiting,
                // we display a loading indicator.
                return const Center(
                  child: Column(
                    children: <Widget>[
                      Text('LOADING...'),
                      SizedBox(height: 8.0),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // If snapshot.hasError is true, we display an error message.
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // If none of the above conditions are met, we display a
              // loading indicator.
              return const Center(
                child: Column(
                  children: <Widget>[
                    Text('LOADING...'),
                    SizedBox(height: 8.0),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: ref.watch(keysExistProvider)
          ? FeedScreenFAB(
              publishNote: (String? note) async {
                ref.read(isNotePublishingProvider.notifier).state = true;

                final EventApi eventApi = EventApi();
                final Event event = eventApi.finishEvent(
                  Event(
                    kind: 1,
                    tags: <List<String>>[
                      <String>['t', 'nostr']
                    ],
                    content: note!,
                    created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  ),
                  ref.watch(privateKeyProvider),
                );

                if (eventApi.verifySignature(event)) {
                  try {
                    ref.read(relayApiProvider).publish(event);
                    await resubscribeStream(ref).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        ScaffoldSnackBar(
                          context: context,
                          content: const Text('Yay! Nost published!'),
                        ),
                      );
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ScaffoldSnackBar(
                        context: context,
                        content: Text('Oops: $error'),
                      ),
                    );
                  }
                }
                ref.read(isNotePublishingProvider.notifier).state = false;
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              isNotePublishing: ref.watch(isNotePublishingProvider),
            )
          : const JoinCosaNostrFAB(),
    );
  }
}
