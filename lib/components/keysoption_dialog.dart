import 'package:cosanostr/all_imports.dart';

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
        ElevatedButton(
          onPressed: inputPrivateKeyPressed,
          child: const Text('USE YOUR PRIVATE KEY'),
        ),
      ],
    );
  }
}
