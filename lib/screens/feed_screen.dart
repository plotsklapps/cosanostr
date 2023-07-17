import 'dart:async';

import 'package:cosanostr/all_imports.dart';

class NewFeedScreen extends ConsumerStatefulWidget {
  const NewFeedScreen({super.key});

  @override
  ConsumerState<NewFeedScreen> createState() {
    return NewFeedScreenState();
  }
}

class NewFeedScreenState extends ConsumerState<NewFeedScreen> {
  late Stream<Event> _stream;
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
    ref.read(relayPoolProvider).close();
    Future<void>.delayed(Duration.zero, () async {
      await streamController.close();
    });
    super.dispose();
  }

  Future<void> initStream() async {
    _stream = await FeedScreenLogic().connectToRelay(ref);
    _stream.listen((Event message) {
      final Event event = message;
      if (event.kind == 1) {
        ref.read(eventsProvider).add(event);
        ref.read(relayApiProvider).sub(<Filter>[
          Filter(
            kinds: <int>[0],
            authors: <String>[event.pubkey],
          )
        ]);
      } else if (event.kind == 0) {
        final Metadata metadata = Metadata.fromJson(
          jsonDecode(event.content) as Map<String, dynamic>,
        );
        ref.read(metaDataProvider)[event.pubkey] = metadata;
      }
      streamController.add(event);
    });
  }

  Future<void> resubscribeStream() async {
    await Future<void>.delayed(const Duration(seconds: 1), () {
      ref.read(eventsProvider).clear();
      ref.read(metaDataProvider).clear();
      initStream(); // Reconnect and resubscribe to the filter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await resubscribeStream();
        },
        child: StreamBuilder<Event>(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
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
              return const Center(child: Text('Loading....'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: ref.watch(keysExistProvider)
          ? FeedScreenFAB(
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
                    ref.read(relayApiProvider).publish(event);
                    await resubscribeStream().then((_) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        ScaffoldSnackBar(
                          context: context,
                          content: const Text('Nost published!'),
                        ),
                      );
                    });
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ScaffoldSnackBar(
                        context: context,
                        content: const Text('Oops! Something went wrong!'),
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
