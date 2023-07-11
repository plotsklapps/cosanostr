import 'package:cosanostr/all_imports.dart';

class KeysOptionBottomSheet extends StatelessWidget {
  const KeysOptionBottomSheet({
    super.key,
    required this.generateNewKeyPressed,
    required this.inputPrivateKeyPressed,
  });

  final void Function()? generateNewKeyPressed;
  final void Function()? inputPrivateKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Welcome to CosaNostr',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Anonymous, open-source, free, lightweight and cross-platform '
            'Nostr client.',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const Text('Please choose your poison:'),
          const SizedBox(height: 16.0),
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
      ),
    );
  }
}
