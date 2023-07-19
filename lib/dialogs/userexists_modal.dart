import 'package:cosanostr/all_imports.dart';

final StateProvider<bool> isHexProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

class UserExistsModal extends ConsumerWidget {
  const UserExistsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
            ref.watch(isHexProvider)
                ? ref
                    .watch(nip19Provider)
                    .npubEncode(ref.watch(publicKeyProvider))
                : ref.watch(publicKeyProvider),
            textAlign: TextAlign.center,
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
            ref.watch(isHexProvider)
                ? ref
                    .watch(nip19Provider)
                    .nsecEncode(ref.watch(privateKeyProvider))
                : ref.watch(privateKeyProvider),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await showDeleteKeysDialog(context, ref);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlexColor.material3LightError,
                ),
                child: const Text('DELETE KEYS'),
              ),
              const SizedBox(width: 8.0),
              if (!ref.watch(isHexProvider))
                ElevatedButton(
                  onPressed: () {
                    ref.read(isHexProvider.notifier).state =
                        !ref.watch(isHexProvider);
                  },
                  child: const Text('SHOW NPUB'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    ref.read(isHexProvider.notifier).state =
                        !ref.watch(isHexProvider);
                  },
                  child: const Text('SHOW HEX'),
                ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
