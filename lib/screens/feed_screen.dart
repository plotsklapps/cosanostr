import 'dart:async';

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

  // Initialize an instance of FlutterSecureStorage
  final secureStorage = const FlutterSecureStorage();

  // Declare and initialize instances of TextEditingController, GlobalKey,
  // KeyApi, and Nip19
  final _keyController = TextEditingController();
  final _formKey = GlobalKey<FormFieldState>();
  final _keyGenerator = KeyApi();
  final _nip19 = Nip19();
  // Initialize a boolean variable to track if note publishing is in progress
  bool _isNotePublishing = false;

  // Implement the _addKeysToStorage() method to add keys to secure storage.
  // The _addKeysToStorage() method writes the private and public keys to a
  // secure storage, using the FlutterSecureStorage plugin.
  // It uses Future.wait() to wait for both write operations to complete.
  // It then updates the state variables and triggering a rebuild of the
  // widget.
  Future<bool> _addKeysToStorage(
    String privateKeyHex,
    String publicKeyHex,
  ) async {
    // 1 It uses Future.wait() to wait for both write operations to complete.
    Future.wait([
      secureStorage.write(key: 'privateKey', value: privateKeyHex),
      secureStorage.write(key: 'publicKey', value: publicKeyHex),
    ]);

    // 2 It then updates the state variables and triggering a rebuild of
    // the widget.
    ref.read(privateKeyProvider.notifier).state = privateKeyHex;
    ref.read(publicKeyProvider.notifier).state = publicKeyHex;
    ref.read(keysExistProvider.notifier).state = true;

    return ref.watch(keysExistProvider);
  }

  // Implement the _generateNewKeys() method to generate new keys and add them
  // to secure storage.
  // The generateNewKeys() method generates new private and public keys using
  // an instance of the _keyGenerator class, and then adds these keys to the
  // secure storage using the _addKeysToStorage() method that we implemented
  // above. Finally, it returns a boolean value indicating whether the keys
  // were successfully added to the storage or not.
  Future<bool> generateNewKeys() async {
    final newPrivateKey = _keyGenerator.generatePrivateKey();
    final newPublicKey = _keyGenerator.getPublicKey(newPrivateKey);

    return await _addKeysToStorage(newPrivateKey, newPublicKey);
  }

  // Implement the _getKeysFromStorage() method to retrieve keys from secure
  // storage
  Future<void> _getKeysFromStorage() async {
    // 1 We use the _secureStorage instance of FlutterSecureStorage to read
    // the values associated with the keys 'privateKey' and 'publicKey' from
    // the secure storage.
    final storedPrivateKey = await secureStorage.read(key: 'privateKey');
    final storedPublicKey = await secureStorage.read(key: 'publicKey');

    // 2 Here we're checking if both storedPrivateKey and storedPublicKey are
    // not null, which indicates that both private and public keys are stored
    // in the secure storage and then we're updating the state variables.
    if (storedPrivateKey != null && storedPublicKey != null) {
      ref.read(privateKeyProvider.notifier).state = storedPrivateKey;
      ref.read(publicKeyProvider.notifier).state = storedPublicKey;
      ref.read(keysExistProvider.notifier).state = true;
    }
  }

  // Implement the _deleteKeysFromStorage() method to delete keys from secure
  // storage
  Future<void> _deleteKeysFromStorage() async {
    // 1 Here we're making calls to secure storage to delete the keys from
    // the storage.
    Future.wait([
      secureStorage.delete(key: 'privateKey'),
      secureStorage.delete(key: 'publicKey'),
    ]);

    // 2 We're updating the state variables privateKeyProvider,
    // publicKeyProvider and keysExistProvider to reset the values after
    // deleting the keys from the storage.
    ref.read(privateKeyProvider.notifier).state = '';
    ref.read(publicKeyProvider.notifier).state = '';
    ref.read(keysExistProvider.notifier).state = false;
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

    return stream.where((message) {
      return message.type == 'EVENT';
    }).map((message) {
      return message.message;
    });
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

  // Implement the `_resubscribeStream` method to initialize a stream.
  // In the above _resubscribeStream() method, after a delay of 1 second,
  // we clear the eventsProvider and metaDataProvider collections. Then, we call
  // _initStream() method, which is responsible for initializing and
  // subscribing to a stream, to reconnect and resubscribe to the filter.
  Future<void> _resubscribeStream() async {
    await Future.delayed(const Duration(seconds: 1), () {
      ref.read(eventsProvider).clear();
      ref.read(metaDataProvider).clear();
      _initStream(); // Reconnect and resubscribe to the filter
    });
  }

  @override
  void initState() {
    super.initState();
    // Call _getKeysFromStorage()
    _getKeysFromStorage();
    _initStream();
  }

  @override
  void dispose() {
    ref.read(relayApiProvider).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Update the NoostAppBar widget with appropriate keysDialog, and
      // deleteKeysDialog parameters.
      appBar: AppBar(
        title: const Text(
          'CosaNostr',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              ref.watch(isConnectedProvider)
                  ? FontAwesomeIcons.solidCircleCheck
                  : FontAwesomeIcons.circleMinus,
              color: ref.watch(isConnectedProvider) ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CosaNostr',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Version 0.0.1'),
                ],
              )),
            ),
            ListTile(
                title: const Text('Thememode'),
                onTap: () {
                  Navigator.pop(context);
                },
                trailing: Switch(
                  value: ref.watch(isDarkThemeProvider),
                  onChanged: (_) {
                    ref.read(isDarkThemeProvider.notifier).state =
                        !ref.watch(isDarkThemeProvider);
                  },
                )),
            ListTile(
              title: const Text('Themecolor'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      //
      // CosaNostrAppBar(
      //   title: 'CosaNostr',
      //   isConnected: _isConnected,
      //   keysDialog: IconButton(
      //       icon: const Icon(Icons.key),
      //       onPressed: () {
      //         // 1 The updated NoostAppBar widget checks if keysExistProvider is true,
      //         // indicating that keys already exist.
      //         ref.watch(keysExistProvider)
      //             ?
      //             // 2 If so, it calls the keysExistDialog() function with the
      //             // appropriate arguments.
      //             keysExistDialog(
      //                 _nip19.npubEncode(ref.watch(publicKeyProvider),),
      //                 _nip19.nsecEncode(ref.watch(privateKeyProvider),),
      //               )
      //             :
      //             // 3 Otherwise, it calls the modalBottomSheet() function to
      //             // generate new keys if keys do not exist.
      //             modalBottomSheet();
      //       }),
      //   // Implement deleteKeysDialog parameter
      //   // In this code, we're checking if keysExistProvider is true, then only
      //   // we're showing the deleteKeysDialog() as an IconButton with a delete
      //   // icon in the top right of the appbar. Otherwise, we're displaying
      //   // an empty container.
      //   deleteKeysDialog: ref.watch(keysExistProvider)
      //       ? IconButton(
      //           icon: const Icon(Icons.delete),
      //           onPressed: () => deleteKeysDialog(),
      //         )
      //       : Container(),
      // ),

      // Implement the RefreshIndicator widget and its onRefresh callback
      // to handle refreshing of the page.
      // 1 The RefreshIndicator widget provides pull-to-refresh behavior to
      // its child widget, allowing the user to trigger a refresh action by
      // pulling down on the screen.
      body: RefreshIndicator(
        // 2 The onRefresh property of RefreshIndicator is set to an
        // asynchronous callback function that gets executed when the user
        // triggers the refresh action. In this case, the callback function
        // is _resubscribeStream(), which is a Future-based method that
        // performs asynchronous operations, clearing and resubscribing to
        // a stream.
        onRefresh: () async {
          await _resubscribeStream();
        },
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: ref.watch(eventsProvider).length,
                itemBuilder: (context, index) {
                  final event = ref.watch(eventsProvider)[index];
                  final metadata = ref.watch(metaDataProvider)[event.pubkey];
                  final noost = Noost(
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
                  return NoostCard(noost: noost);
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading....'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const CenteredCircularProgressIndicator();
          },
        ),
      ),

      // Implement the CreatePostFAB widget to enable users to create new
      // Noosts.
      // 1 If keysExistProvider is true, the floatingActionButton is built using the
      // CreatePostFAB widget. This custom widget represents a FAB with
      // specific decoration and widgets for publishing a note.
      floatingActionButton: ref.watch(keysExistProvider)
          ?
          // 2 The CreatePostFAB widget is configured with two properties:
          // publishNote and isNotePublishing. We will implement the publish
          // note functionality soon. The isNotePublishing property indicates
          // whether the note is currently being published, and it is likely
          // used to display a progress indicator on the FAB during the
          // publishing process.
          CreatePostFAB(
              // 1 The publishNote function is called when the user triggers
              // the "Noost!" button on the dialog.
              publishNote: (note) {
                // Publish Note functionality
                setState(() => _isNotePublishing = true);

                // 2 An instance of the EventApi class is created, which is
                // defined in the nostr_tools package.
                final eventApi = EventApi();
                // 3 The finishEvent method of the EventApi class is called
                // with the Event object and the privateKeyProvider variable.
                // finishEvent will set the id of the event with the event
                // hash and will sign the event with the given
                // privateKeyProvider.
                final event = eventApi.finishEvent(
                  // 4 Here, we're creating a new instance of the Event class
                  // with specific properties such as:
                  //
                  // kind: 1: Which means a simple text note.
                  //
                  // tags: [['t', 'nostr']]: Its data type is
                  // List<List<String>>, which means if we want to add
                  // another tag, we need to update its value as tags:
                  // [['t', 'nostr'], ['t', 'bitcoin']]. But for our event,
                  // we're simply using the "nostr" tag because we're
                  // filtering the feed in our app with "nostr". So when our
                  // event is published, it will be super easy to reflect
                  // that in our app, only if we publish the event with a
                  // tag of "nostr".
                  //
                  // content: note!: It's set to the plaintext content of a
                  // note (anything the user wants to say).
                  //
                  // created_at: It's set to the current Unix timestamp in
                  // seconds.
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

                // 5 The verifySignature method of the EventApi class is
                // called with the returned Event object to verify the
                // signature of the event.
                if (eventApi.verifySignature(event)) {
                  try {
                    // 6 If the signature is verified, the publish method is
                    // called on the _relay object to publish the event.
                    ref.read(relayApiProvider).publish(event);
                    // 7 After publishing the event, the _resubscribeStream
                    // method is called, likely to refresh the stream or
                    // subscription to reflect the newly published event.
                    _resubscribeStream();
                    // 8 A SnackBar is shown to display a message indicating
                    // that the note was successfully published.
                    ScaffoldMessenger.of(context).showSnackBar(
                      NoostSnackBar(label: 'Congratulations! Noost Published!'),
                    );
                  } catch (_) {
                    // 9 If any error occurs during the publishing process
                    // (e.g., an exception is caught), a warning SnackBar is
                    // shown instead.
                    ScaffoldMessenger.of(context).showSnackBar(NoostSnackBar(
                      label: 'Oops! Something went wrong!',
                      isWarning: true,
                    ));
                  }
                }
                setState(() => _isNotePublishing = false);
                Navigator.pop(context);
              },
              isNotePublishing: _isNotePublishing,
            )
          :
          // 3 If keysExistProvider is false, an empty Container() widget is
          // displayed, meaning that the FAB will not be visible.
          Container(),
    );
  }

  void modalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return KeysOptionModalBottomSheet(
          generateNewKeyPressed: () {
            // Implement logic to generate new keys
            // After keys are generated, show a SnackBar with the message "Congratulations! Keys Generated!"
            // and dismiss the bottom sheet using Navigator.pop(context)
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
            // Implement logic to handle input of private key.
            // After private key is input, dismiss the bottom sheet using
            // Navigator.pop(context) and show the pastePrivateKeyDialog()
            // to handle the input.
            Navigator.pop(context);
            _keyController.clear();
            pastePrivateKeyDialog();
          },
        );
      },
    );
  }

  // The pastePrivateKeyDialog() method is responsible for displaying a dialog
  // box with a custom widget called PastePrivateKeyDialog when called.
  void pastePrivateKeyDialog() {
    // Showing PastePrivateKeyDialog to handle the input
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastePrivateKeyDialog(
          keyController: _keyController,
          formKey: _formKey,
          // 1 The keyValidator function is used for validating the private
          // key entered by the user. We'll implement the validation logic
          // further.
          keyValidator: (value) {
            // Validating privateKey entered by the user
            // 1 It first checks if the value is null or empty, and if so,
            // it returns the appropriate error message.
            if (value == null || value.isEmpty) {
              return 'Please enter your private key.';
            }

            try {
              // 2 We use the isValidPrivateKey(value) method to validate the
              // user-entered private key. This method is defined in the
              // nostr_tools Dart package and only accepts a hexadecimal
              // value of the private key.
              bool isValidHexKey = _keyGenerator.isValidPrivateKey(value);
              // 3 If the user entered a bech32 encoded private key in the
              // "nsec" format as described in Nip-19, we first decode it
              // and then pass the decoded value (which is the hexadecimal
              // value of the private key) to the isValidPrivateKey(...) method.
              bool isValidNsec = value.trim().startsWith('nsec') &&
                  _keyGenerator.isValidPrivateKey(_nip19.decode(value)['data']);

              // 4 If the value is not a valid private key in either
              // hexadecimal or Nip-19 format, it returns the appropriate
              // error message.
              if (!(isValidHexKey || isValidNsec)) {
                return 'Your private key is not valid.';
              }

              // 5 If the value fails the checksum verification using a
              // ChecksumVerificationException, it returns the error message
              // from the exception.
            } on ChecksumVerificationException catch (e) {
              return e.message;

              // 6 If any other exception occurs during the validation process,
              // it returns an error message with the exception's error message.
            } catch (e) {
              return 'Error: $e';
            }

            // 7 If the value passes all the validation checks, it returns
            // null, indicating that the value is valid.
            return null;
          },
          // 2 If the form represented by _formKey is validated, the
          // onOKPressed callback function is called.
          onOKPressed: () {
            if (_formKey.currentState!.validate()) {
              // Adding user entered private key to the storage.
              // 1 It obtains the value of the private key from the
              // _keyController text field and assigns it to the privateKeyHex
              // variable.
              String privateKeyHex = _keyController.text.trim();
              String publicKeyHex;
              // 2 It checks if the privateKeyHex starts with the string
              // "nsec", indicating that it might be in NIP-19 format. If so,
              // it decodes the privateKeyHex using
              // _nip19.decode(privateKeyHex) method to obtain the 'data'
              // field, which represents the actual private key in hexadecimal
              // format.
              if (privateKeyHex.startsWith('nsec')) {
                final decoded = _nip19.decode(privateKeyHex);
                privateKeyHex = decoded['data'];
                publicKeyHex = _keyGenerator.getPublicKey(privateKeyHex);
              }
              // 3 If the privateKeyHex does not start with "nsec", indicating
              // that it is a regular hexadecimal private key.
              else {
                publicKeyHex = _keyGenerator.getPublicKey(privateKeyHex);
              }

              // 4 It then calls the _addKeysToStorage method to add the
              // private key and public key to the storage. It attaches a
              // then() callback to this method to handle the case when the
              // keys are successfully added to the storage.
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
          // Replace hexPriv and hexPub values
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
            // In this code, we're calling _deleteKeysFromStorage() method
            // when the "Yes" button is pressed in the deleteKeysDialog.
            // After deleting the keys, if keysExistProvider is false, we're
            // displaying a snackbar with a success message, and then closing
            // the dialog using Navigator.pop(context).
            final currentContext = context;
            _deleteKeysFromStorage().then((_) {
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
