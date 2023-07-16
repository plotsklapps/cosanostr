import 'package:cosanostr/all_imports.dart';

final StateProvider<bool> isHexProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

// The Dialog that is only shown to users when they click on the
// 'key' icon on the FeedScreen() IF keys already exist.
// Takes in keys as String and shows them as HEX or NPUB,
// according to the isHexProvider boolean.
// The SelectableText widget makes it possible for a user
// to copy/paste the keys for use elsewhere.
class KeysExistDialog extends ConsumerWidget {
  const KeysExistDialog(
    this.npubEncoded,
    this.nsecEncoded,
    this.hexPriv,
    this.hexPub, {
    super.key,
  });

  final String npubEncoded;
  final String nsecEncoded;
  final String hexPriv;
  final String hexPub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.key),
      title: const Text('KEYS'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Public Key',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          SelectableText(
            ref.watch(isHexProvider) ? hexPub : npubEncoded,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Private Key',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          SelectableText(
            ref.watch(isHexProvider) ? hexPriv : nsecEncoded,
          ),
        ],
      ),
      actions: <Widget>[
        if (ref.watch(isHexProvider))
          ElevatedButton(
            onPressed: () {
              ref.read(isHexProvider.notifier).state =
                  !ref.watch(isHexProvider);
            },
            child: const Text('NPUB'),
          )
        else
          ElevatedButton(
            onPressed: () {
              ref.read(isHexProvider.notifier).state =
                  !ref.watch(isHexProvider);
            },
            child: const Text('HEX'),
          ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await Dialogs().deleteKeysDialog(context, ref);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: FlexColor.material3LightError,
          ),
          child: const Text('DELETE KEYS'),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
