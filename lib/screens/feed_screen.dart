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

    ref.read(relayApiProvider).on((event) {
      if (event == RelayEvent.connect) {
        ref.read(isConnectedProvider.notifier).state = true;
      } else if (event == RelayEvent.error) {
        ref.read(isConnectedProvider.notifier).state = false;
      }
    });

    ref.read(relayApiProvider).sub([
      Filter(
        kinds: [1],
        limit: 100,
        t: ["nostr"],
      )
    ]);

    return stream
        .where((message) => message.type == 'EVENT')
        .map((message) => message.message);
  }

  void initStream() async {
    stream = await connectToRelay();
    stream.listen((message) {
      final event = message;
      if (event.kind == 1) {
        ref.read(eventsProvider).add(event);
        ref.read(relayApiProvider).sub([
          Filter(kinds: [0], authors: [event.pubkey])
        ]);
      } else if (event.kind == 0) {
        final metadata = Metadata.fromJson(jsonDecode(event.content));
        ref.read(metaDataProvider)[event.pubkey] = metadata;
      }
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
      appBar: CosaNostrAppBar(
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
      body: RefreshIndicator(
        onRefresh: () async {
          await resubscribeStream();
        },
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
          child: StreamBuilder(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: ref.watch(eventsProvider).length,
                  itemBuilder: (context, index) {
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
                    return CosaNostrCard(nost: nost);
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text('Loading....'));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: ref.watch(keysExistProvider)
          ? CreatePostFAB(
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
