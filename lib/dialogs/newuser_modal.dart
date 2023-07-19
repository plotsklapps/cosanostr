import 'package:cosanostr/all_imports.dart';

class NewUserModal extends ConsumerWidget {
  const NewUserModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
              await FeedScreenLogic()
                  .generateNewKeys(ref)
                  .then((bool keysGenerated) {
                if (keysGenerated) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    ScaffoldSnackBar(
                      context: context,
                      content: const Text(
                        'Congratulations! New keys generated!',
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    ScaffoldSnackBar(
                      context: context,
                      content: const Text(
                        'Oops! Something went wrong!',
                      ),
                    ),
                  );
                }
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
}
