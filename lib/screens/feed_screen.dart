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
  late Stream<Event> _stream;
  final _controller = StreamController<Event>();

  final _secureStorage = const FlutterSecureStorage();
  String _privateKey = '';
  String _publicKey = '';
  bool _keysExist = false;

  final _keyController = TextEditingController();
  final _formKey = GlobalKey<FormFieldState>();
  final _keyGenerator = KeyApi();
  final _nip19 = Nip19();

  @override
  void initState() {
    super.initState();
    _getKeysFromStorage();
    _initStream();
  }

  @override
  void dispose() {
    ref.read(relayApiProvider).close();
    super.dispose();
  }

  Future<void> _getKeysFromStorage() async {
    final storedPrivateKey = await _secureStorage.read(key: 'privateKey');
    final storedPublicKey = await _secureStorage.read(key: 'publicKey');

    if (storedPrivateKey != null && storedPublicKey != null) {
      setState(() {
        _privateKey = storedPrivateKey;
        _publicKey = storedPublicKey;
        _keysExist = true;
      });
    }
  }

  Future<bool> _addKeysToStorage(
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    Future.wait([
      _secureStorage.write(key: 'privateKey', value: privateKeyHex),
      _secureStorage.write(key: 'publicKey', value: publicKeyHex),
    ]);

    setState(() {
      _privateKey = privateKeyHex;
      _publicKey = publicKeyHex;
      _keysExist = true;
    });

    return _keysExist;
  }

  Future<void> _deleteKeysFromStorage() async {
    Future.wait([
      _secureStorage.delete(key: 'privateKey'),
      _secureStorage.delete(key: 'publicKey'),
    ]);

    setState(() {
      _privateKey = '';
      _publicKey = '';
      _keysExist = false;
    });
  }

  Future<bool> generateNewKeys() async {
    final newPrivateKey = _keyGenerator.generatePrivateKey();
    final newPublicKey = _keyGenerator.getPublicKey(newPrivateKey);

    return await _addKeysToStorage(newPrivateKey, newPublicKey);
  }

  Future<Stream<Event>> _connectToRelay() async {
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

  void _initStream() async {
    _stream = await _connectToRelay();
    _stream.listen((message) {
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
      _controller.add(event);
    });
  }

  Future<void> _resubscribeStream() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        ref.read(eventsProvider).clear();
        ref.read(metaDataProvider).clear();
      });
      _initStream(); // Reconnect and resubscribe to the filter
    });
  }

  @override
  Widget build(BuildContext context) {
    final nip19 = Nip19();

    return Scaffold(
      appBar: CosaNostrAppBar(
        title: 'CosaNostr',
        isConnected: ref.watch(isConnectedProvider),
        keysDialog: IconButton(
            icon: const Icon(Icons.key),
            onPressed: () {
              _keysExist
                  ? keysExistDialog(
                      nip19.npubEncode(_publicKey),
                      nip19.nsecEncode(_privateKey),
                    )
                  : modalBottomSheet();
            }),
        deleteKeysDialog: _keysExist
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteKeysDialog(),
              )
            : Container(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _resubscribeStream();
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
            stream: _controller.stream,
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
      floatingActionButton: _keysExist
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
                  _privateKey,
                );

                if (eventApi.verifySignature(event)) {
                  try {
                    ref.read(relayApiProvider).publish(event);
                    _resubscribeStream();
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
            _keyController.clear();
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
          keyController: _keyController,
          formKey: _formKey,
          keyValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your private key.';
            }

            try {
              bool isValidHexKey = _keyGenerator.isValidPrivateKey(value);
              bool isValidNsec = value.trim().startsWith('nsec') &&
                  _keyGenerator.isValidPrivateKey(_nip19.decode(value)['data']);

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
            if (_formKey.currentState!.validate()) {
              String privateKeyHex = _keyController.text.trim();
              String publicKeyHex;

              if (privateKeyHex.startsWith('nsec')) {
                final decoded = _nip19.decode(privateKeyHex);
                privateKeyHex = decoded['data'];
                publicKeyHex = _keyGenerator.getPublicKey(privateKeyHex);
              } else {
                publicKeyHex = _keyGenerator.getPublicKey(privateKeyHex);
              }

              _addKeysToStorage(privateKeyHex, publicKeyHex).then((keysAdded) {
                if (keysAdded) {
                  _keyController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    NoostSnackBar(label: 'Congratulations! Keys Stored!'),
                  );
                }
              });

              Navigator.pop(context);
            } else {
              _formKey.currentState?.setState(() {});
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
          hexPriv: _privateKey,
          hexPub: _publicKey,
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
            _deleteKeysFromStorage().then((_) {
              if (!_keysExist) {
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
