import 'package:cosanostr/all_imports.dart';

class NewUserModal extends ConsumerStatefulWidget {
  const NewUserModal({super.key});

  @override
  ConsumerState<NewUserModal> createState() {
    return NewUserModalState();
  }
}

class NewUserModalState extends ConsumerState<NewUserModal> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ref.read(confettiControllerProvider);
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
            maxBlastForce: 50,
          ),
          const Text(
            'Welcome to CosaNostr!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const Text(
            '''
The anonymous, open-source, free, lightweight and cross-platform Nostr client.''',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const Text(
            'Please choose your poison:',
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              confettiController.play();

              Future<void>.delayed(const Duration(seconds: 2), () async {
                await FeedScreenLogic().generateNewKeys(ref).then((_) {
                  if (ref.watch(keysExistProvider)) {
                    Navigator.pop(context);
                    snackSuccessfullyJoined(context);
                  } else {
                    Navigator.pop(context);
                    snackJoiningCosaNostrFailed(context);
                  }
                });
              });
            },
            child: const Text('GENERATE NEW KEYS'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              ref.read(keyControllerProvider).clear();
              await showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const UsePrivateKeyModal(),
                  );
                },
              ).then((_) {
                Navigator.pop(context);
              });
            },
            child: const Text('USE YOUR PRIVATE KEY'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      snackJoiningCosaNostrFailed(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Oops, something is wrong!',
            ),
            Icon(FontAwesomeIcons.circleExclamation),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      snackSuccessfullyJoined(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'You are now a proud member of CosaNostr!',
            ),
            Icon(FontAwesomeIcons.handshake),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
