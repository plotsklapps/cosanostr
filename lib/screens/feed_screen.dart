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
  // TODO: Set up StreamProvider so it can be used throughout the app.
  late Stream<Event> stream;
  final streamController = StreamController<Event>();

  final secureStorage = const FlutterSecureStorage();

  final keyController = TextEditingController();
  final formKey = GlobalKey<FormFieldState>();
  final keyGenerator = KeyApi();
  final nip19 = Nip19();

  @override
  void initState() {
    super.initState();
    getKeysFromStorage();
    initStream();
  }

  @override
  void dispose() {
    ref.read(relayApiProvider).close();
    super.dispose();
  }

  Future<void> getKeysFromStorage() async {
    final storedPrivateKey = await secureStorage.read(key: 'privateKey');
    final storedPublicKey = await secureStorage.read(key: 'publicKey');

    if (storedPrivateKey != null && storedPublicKey != null) {
      ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
      ref.read(publicKeyProvider.notifier).state = storedPublicKey;
      ref.read(keysExistProvider.notifier).state = true;
    }
  }

  Future<bool> addKeysToStorage(
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    Future.wait([
      secureStorage.write(key: 'privateKey', value: privateKeyHex),
      secureStorage.write(key: 'publicKey', value: publicKeyHex),
    ]);
    ref.read(privateKeyProvider.notifier).state = privateKeyHex;
    ref.read(publicKeyProvider.notifier).state = publicKeyHex;
    ref.read(keysExistProvider.notifier).state = true;

    return ref.watch(keysExistProvider);
  }

  Future<void> deleteKeysFromStorage() async {
    Future.wait([
      secureStorage.delete(key: 'privateKey'),
      secureStorage.delete(key: 'publicKey'),
    ]);
    ref.read(privateKeyProvider.notifier).state = '';
    ref.read(publicKeyProvider.notifier).state = '';
    ref.read(keysExistProvider.notifier).state = false;
  }

  Future<bool> generateNewKeys() async {
    final newPrivateKey = keyGenerator.generatePrivateKey();
    final newPublicKey = keyGenerator.getPublicKey(newPrivateKey);

    return await addKeysToStorage(newPrivateKey, newPublicKey);
  }

  Future<Stream<Event>> connectToRelay() async {
    final stream = await ref.read(relayApiProvider).connect();

    // This sets up an event listener for relayApiProvider, which will be
    // triggered whenever relayApiProvider emits a RelayEvent.
    ref.read(relayApiProvider).on((event) {
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
    ref.read(relayApiProvider).sub([
      Filter(
        kinds: [1],
        limit: 100,
        t: ["nostr"],
      )
    ]);

    return stream.where((message) {
      return message.type == 'EVENT';
    }).map((message) {
      return message.message;
    });
  }

  void initStream() async {
    // This line sets up a loop that listens for events from the stream object.
    // The await for construct allows the loop to be asynchronous, meaning
    // that it can listen for incoming events while continuing to run other
    // parts of the program.
    stream = await connectToRelay();
    // This line checks the type of the incoming message. If it is an event
    // message, the code inside the if block is executed. There are other
    // types of messages that can be received as well, such as "REQ", "CLOSE",
    // "NOTICE", and "OK", but we're only interested in events for now.
    stream.listen((message) {
      // This line extracts the message object from the incoming message and
      // assigns it to the event variable. This event object contains all of
      // the information we need about the incoming event.
      final event = message;
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
        ref.read(relayApiProvider).sub([
          Filter(kinds: [0], authors: [event.pubkey])
        ]);
        // If the kind of the event is 0, the content of the event is decoded
        // from JSON and assigned to a metadata variable. This metadata is
        // then associated with the event.pubkey of the author in the
        // metaDataProvider map. This allows us to keep track of the metadata
        // for each user who creates a note.
      } else if (event.kind == 0) {
        final metadata = Metadata.fromJson(jsonDecode(event.content));
        ref.read(metaDataProvider)[event.pubkey] = metadata;
      }
      // Finally, the incoming message is added to the StreamController.
      // This makes the message available to any other parts of the program
      // that are listening to the Stream.
      streamController.add(event);
    });
  }

  Future<void> resubscribeStream() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        ref.read(eventsProvider).clear();
        ref.read(metaDataProvider).clear();
      });
      initStream(); // Reconnect and resubscribe to the filter
    });
  }

  @override
  Widget build(BuildContext context) {
    final nip19 = Nip19();

    return Scaffold(
      appBar: FeedScreenAppBar(
        title: '',
        isConnected: ref.watch(isConnectedProvider),
        keysDialog: IconButton(
            icon: const Icon(Icons.key),
            onPressed: () {
              ref.watch(keysExistProvider)
                  ? keysExistDialog(
                      nip19.npubEncode(ref.watch(publicKeyProvider)),
                      nip19.nsecEncode(ref.watch(privateKeyProvider)))
                  : modalBottomSheet();
            }),
        deleteKeysDialog: ref.watch(keysExistProvider)
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteKeysDialog(),
              )
            : Container(),
      ),
      // Pull to refresh, aaahhh!
      body: RefreshIndicator(
        onRefresh: () async {
          await resubscribeStream();
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
          child: StreamBuilder(
            stream: streamController.stream,
            // The builder callback is called whenever a new event is
            // emitted from the stream.
            builder: (context, snapshot) {
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
                  itemBuilder: (context, index) {
                    // For each event, we create a Nost object that
                    // encapsulates the details of the event, including the
                    // id, avatarUrl, name, username, time, content, and
                    // pubkey. Here is the power of the metaDataProvider map
                    // as we're able to map the event pubkey with the
                    // metadata of the author.
                    final event = ref.watch(eventsProvider)[index];
                    final metadata = ref.watch(metaDataProvider)[event.pubkey];
                    final nost = Nost(
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
                  children: [
                    Text('LOADING...'),
                    SizedBox(height: 8.0),
                    CircularProgressIndicator(),
                  ],
                ));
              } else if (snapshot.hasError) {
                // If snapshot.hasError is true, we display an error message.
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // If none of the above conditions are met, we display a
              // loading indicator.
              return const Center(
                child: Column(
                  children: [
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
              publishNote: (note) {
                ref.read(isNotePublishingProvider.notifier).state = true;

                final eventApi = EventApi();
                final event = eventApi.finishEvent(
                  Event(
                    kind: 1,
                    tags: [
                      ['t', 'nostr']
                    ],
                    content: note!,
                    created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  ),
                  ref.watch(privateKeyProvider),
                );

                if (eventApi.verifySignature(event)) {
                  try {
                    ref.read(relayApiProvider).publish(event);
                    resubscribeStream();
                    ScaffoldMessenger.of(context).showSnackBar(
                      NoostSnackBar(label: 'Congratulations! Noost Published!'),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(NoostSnackBar(
                      label: 'Oops! Something went wrong!',
                      isWarning: true,
                    ));
                  }
                }
                ref.read(isNotePublishingProvider.notifier).state = false;
                Navigator.pop(context);
              },
              isNotePublishing: ref.watch(isNotePublishingProvider),
            )
          : Container(),
    );
  }

  void modalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return KeysOptionModalBottomSheet(
          generateNewKeyPressed: () {
            final currentContext = context;
            generateNewKeys().then((keysGenerated) {
              if (keysGenerated) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                    NoostSnackBar(label: 'Congratulations! Keys Generated!'));
              }
            });
            Navigator.pop(context);
          },
          inputPrivateKeyPressed: () {
            Navigator.pop(context);
            keyController.clear();
            pastePrivateKeyDialog();
          },
        );
      },
    );
  }

  void pastePrivateKeyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastePrivateKeyDialog(
          keyController: keyController,
          formKey: formKey,
          keyValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your private key.';
            }

            try {
              bool isValidHexKey = keyGenerator.isValidPrivateKey(value);
              bool isValidNsec = value.trim().startsWith('nsec') &&
                  keyGenerator.isValidPrivateKey(nip19.decode(value)['data']);

              if (!(isValidHexKey || isValidNsec)) {
                return 'Your private key is not valid.';
              }
            } on ChecksumVerificationException catch (e) {
              return e.message;
            } catch (e) {
              return 'Error: $e';
            }

            return null;
          },
          onOKPressed: () {
            if (formKey.currentState!.validate()) {
              String privateKeyHex = keyController.text.trim();
              String publicKeyHex;

              if (privateKeyHex.startsWith('nsec')) {
                final decoded = nip19.decode(privateKeyHex);
                privateKeyHex = decoded['data'];
                publicKeyHex = keyGenerator.getPublicKey(privateKeyHex);
              } else {
                publicKeyHex = keyGenerator.getPublicKey(privateKeyHex);
              }

              addKeysToStorage(privateKeyHex, publicKeyHex).then((keysAdded) {
                if (keysAdded) {
                  keyController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    NoostSnackBar(label: 'Congratulations! Keys Stored!'),
                  );
                }
              });

              Navigator.pop(context);
            } else {
              formKey.currentState?.setState(() {});
            }
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void keysExistDialog(String npubEncode, String nsecEncode) async {
    await showDialog(
      context: context,
      builder: ((context) {
        return KeysExistDialog(
          npubEncoded: npubEncode,
          nsecEncoded: nsecEncode,
          hexPriv: ref.watch(privateKeyProvider),
          hexPub: ref.watch(publicKeyProvider),
        );
      }),
    );
  }

  void deleteKeysDialog() async {
    await showDialog(
      context: context,
      builder: ((context) {
        return DeleteKeysDialog(
          onNoPressed: () {
            Navigator.pop(context);
          },
          onYesPressed: () {
            final currentContext = context;
            deleteKeysFromStorage().then((_) {
              if (!ref.watch(keysExistProvider)) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  NoostSnackBar(
                    label: 'Keys successfully deleted!',
                    isWarning: true,
                  ),
                );
              }
            });
            Navigator.pop(context);
          },
        );
      }),
    );
  }
}
