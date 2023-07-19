import 'package:cosanostr/all_imports.dart';

// Show a dialog to user when keys don't exist. Takes in context and ref.
// Provides choice to user to generate new keys or input a private key.
Future<void> showKeysOptionsDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return KeysOptionDialog(
        generateNewKeyPressed: () {
          FeedScreenLogic().generateNewKeys(ref).then((bool keysGenerated) {
            if (keysGenerated) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                ScaffoldSnackBar(
                  context: context,
                  content: const Text('Congratulations! New keys generated!'),
                ),
              );
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                ScaffoldSnackBar(
                  context: context,
                  content: const Text('Oops! Something went wrong!'),
                ),
              );
            }
          });
        },
        inputPrivateKeyPressed: () {
          ref.read(keyControllerProvider).clear();
          showPastePrivateKeyDialog(context, ref).then((_) {
            Navigator.pop(context);
          });
        },
      );
    },
  );
}

class KeysOptionDialog extends StatelessWidget {
  const KeysOptionDialog({
    super.key,
    required this.generateNewKeyPressed,
    required this.inputPrivateKeyPressed,
  });

  final void Function() generateNewKeyPressed;
  final void Function() inputPrivateKeyPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.key),
      title: const Text('WELCOME TO COSANOSTR'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '''
The anonymous, open-source, free, lightweight and cross-platform Nostr client.''',
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(
            'Please choose your poison:',
            textAlign: TextAlign.end,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: generateNewKeyPressed,
          child: const Text('GENERATE NEW KEYS'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: inputPrivateKeyPressed,
          child: const Text('USE YOUR PRIVATE KEY'),
        ),
      ],
    );
  }
}
