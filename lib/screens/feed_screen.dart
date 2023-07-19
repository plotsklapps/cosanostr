import 'dart:async';
import 'dart:ui';

import 'package:cosanostr/all_imports.dart';
import 'package:flutter/rendering.dart';

final StateProvider<bool> isUserScrollingProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() {
    return FeedScreenState();
  }
}

// AutomaticKeepAliveClient Mixin makes sure that the state of the
// FeedScreen is kept alive even when the user navigates to another
// screen. This is important because the FeedScreen is the main screen
// of the app and should not be reloaded every time the user navigates
// back to it.
class FeedScreenState extends ConsumerState<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  late Stream<Event> stream;
  final StreamController<Event> streamController = StreamController<Event>();
  final ScrollController scrollController = ScrollController();

  // Override the wantKeepAlive getter to return true.
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();

    // Get the keys from storage, connect to the relay and start
    // listening to the stream.
    Future<void>.delayed(Duration.zero, () async {
      await FeedScreenLogic().getKeysFromStorage(ref);
      await initStream();
    });
    // Add a listener to the scrollController to check if the user
    // is scrolling or not. If the user is scrolling, set the
    // isUserScrollingProvider to true which in turn will change the FAB to
    // a smaller version. If the user is not scrolling, set the
    // isUserScrollingProvider to false which in turn will change the FAB to
    // the extended version.
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        ref.read(isUserScrollingProvider.notifier).state = true;
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        ref.read(isUserScrollingProvider.notifier).state = true;
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.idle) {
        ref.read(isUserScrollingProvider.notifier).state = false;
      } else {
        ref.read(isUserScrollingProvider.notifier).state = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the keys from storage, connect to the relay and start
    // listening to the stream.
    Future<void>.delayed(Duration.zero, () async {
      await FeedScreenLogic().getKeysFromStorage(ref);
      await initStream();
    });
    // Add a listener to the scrollController to check if the user
    // is scrolling or not. If the user is scrolling, set the
    // isUserScrollingProvider to true which in turn will change the FAB to
    // a smaller version. If the user is not scrolling, set the
    // isUserScrollingProvider to false which in turn will change the FAB to
    // the extended version.
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        ref.read(isUserScrollingProvider.notifier).state = true;
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        ref.read(isUserScrollingProvider.notifier).state = true;
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.idle) {
        ref.read(isUserScrollingProvider.notifier).state = false;
      } else {
        ref.read(isUserScrollingProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    // Close the stream and the relay pool on dispose.
    Future<void>.delayed(Duration.zero, () async {
      await streamController.close();
    });
    ref.read(relayPoolProvider).close();
    super.dispose();
  }

  Future<void> initStream() async {
    // First, connect to the relayPool and subscribe to the events
    stream = await FeedScreenLogic().connectToRelay(ref);
    // Then, listen to the stream and add the events to the
    // eventsProvider and the metaDataProvider.
    stream.listen((Event message) {
      final Event event = message;
      // If the event is a note, add it to the eventsProvider
      if (event.kind == 1) {
        ref.read(eventsProvider).add(event);
        ref.read(relayPoolProvider).sub(<Filter>[
          Filter(
            kinds: <int>[0],
            authors: <String>[event.pubkey],
          )
        ]);
        // If the event is a metadata, add it to the metaDataProvider
      } else if (event.kind == 0) {
        final Metadata metadata = Metadata.fromJson(
          jsonDecode(event.content) as Map<String, dynamic>,
        );
        ref.read(metaDataProvider)[event.pubkey] = metadata;
      }
      // Add the event to the streamController if it is not closed already.
      if (!streamController.isClosed) {
        streamController.add(event);
      } else {
        return;
      }
    });
  }

  Future<void> resubscribeStream() async {
    // Clear the eventsProvider and the metaDataProvider and resubscribe
    // to the relayPool.
    await Future<void>.delayed(const Duration(seconds: 1), () {
      ref.read(eventsProvider).clear();
      ref.read(metaDataProvider).clear();
    }).then((_) async {
      await initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Make sure to call super.build(context) first because it is
    // required by the AutomaticKeepAliveClientMixin.
    super.build(context);

    Logger().i('Rebuilt FeedScreen because of a state change.');
    return Scaffold(
      // The RefreshIndicator is used to refresh the stream and
      // resubscribe to the relayPool.
      body: RefreshIndicator(
        onRefresh: () async {
          await resubscribeStream();
        },
        // The ScrollConfiguration is used to disable the scrollbars
        // and to enable scrolling with the various input devices on
        // the web.
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            scrollbars: false,
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
          ),
          // The StreamBuilder is used to build the list of nosts from
          // the stream.
          child: StreamBuilder<Event>(
            stream: streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
              if (snapshot.hasData) {
                // If the snapshot has data, build the list of nosts.
                return ListView.builder(
                  controller: scrollController,
                  itemCount: ref.watch(eventsProvider).length,
                  itemBuilder: (BuildContext context, int index) {
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
                    return FeedScreenCard(nost: nost);
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                // If the snapshot is loading, show a 'loading screen'.
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/cosanostr_icon.png',
                        scale: 2.0,
                      ),
                      const SizedBox(height: 32.0),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 32.0),
                      const Text(
                        'Connecting to the relays...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                // If the snapshot is terminated, print it to console
                Logger().i('Connection to the relayPool closed.');
              } else if (snapshot.connectionState == ConnectionState.none) {
                // If the snapshot has no connection, show a 'no connection
                // screen'.
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image.asset(
                          'assets/images/cosanostr_icon.png',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('No connection to the relays...'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // If the snapshot has an error, print it to console.
                Logger().e('Error: ${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: ref.watch(keysExistProvider)
          ? FeedScreenFAB(
              ref: ref,
              publishNote: (String? nost) async {
                ref.read(isNotePublishingProvider.notifier).state = true;
                final EventApi eventApi = EventApi();
                final Event event = eventApi.finishEvent(
                  Event(
                    kind: 1,
                    tags: <List<String>>[
                      <String>[
                        't',
                        'nostr',
                      ]
                    ],
                    content: nost!,
                    created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  ),
                  ref.watch(privateKeyProvider),
                );

                if (eventApi.verifySignature(event)) {
                  try {
                    ref.read(relayPoolProvider).publish(event);
                    await resubscribeStream().then((_) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        ScaffoldSnackBar(
                          context: context,
                          content: const Text('Nost published!'),
                        ),
                      );
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ScaffoldSnackBar(
                        context: context,
                        content: Text('Oops! Something went wrong: $error'),
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
          : Container(),
    );
  }
}
