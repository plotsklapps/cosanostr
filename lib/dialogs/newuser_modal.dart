import 'package:cosanostr/all_imports.dart';

class NewUserModal extends ConsumerStatefulWidget {
  const NewUserModal({super.key});

  @override
  ConsumerState<NewUserModal> createState() {
    return NewUserModalState();
  }
}

class NewUserModalState extends ConsumerState<NewUserModal> {
  late ConfettiController confettiController = ConfettiController();

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
              await FeedScreenLogic().generateNewKeys(ref).then((_) {
                if (ref.watch(keysExistProvider)) {
                  confettiController.play();
                  Future<void>.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                    snackJoiningSuccesful(context);
                  });
                } else {
                  Navigator.pop(context);
                  snackJoiningFailed(context);
                }
              });
            },
            child: const Text('GENERATE NEW KEYS'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              ref.read(keyControllerProvider).clear();
              await showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const PrivateKeyModal(),
                  );
                },
              );
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackJoiningFailed(
    BuildContext context,
  ) {
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
      snackJoiningSuccesful(BuildContext context) {
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
