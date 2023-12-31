import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

final StateProvider<bool> isHexProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});

final StateProvider<bool> isNsecVisibleProvider =
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
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                FontAwesomeIcons.key,
                size: 36.0,
              ),
              const Divider(),
              const Text(
                'Your Securely Stored Keys',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                'Public Key',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              if (ref.watch(isNsecVisibleProvider))
                SelectableText(
                  ref.watch(isHexProvider)
                      ? ref
                          .watch(nip19Provider)
                          .nsecEncode(ref.watch(privateKeyProvider))
                      : ref.watch(privateKeyProvider),
                  textAlign: TextAlign.center,
                )
              else
                const SelectableText(
                  '''
******** ******** ******** ******** ******** ******** ******** ********''',
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return const DeleteKeysModal();
                        },
                      );
                    },
                    child: const Text(
                      'DELETE KEYS',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (!ref.watch(isHexProvider))
                    TextButton(
                      onPressed: () {
                        ref.read(isHexProvider.notifier).state =
                            !ref.watch(isHexProvider);
                      },
                      child: const Text('SHOW NPUB'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        ref.read(isHexProvider.notifier).state =
                            !ref.watch(isHexProvider);
                      },
                      child: const Text('SHOW HEX'),
                    ),
                  IconButton(
                    onPressed: () {
                      ref.read(isNsecVisibleProvider.notifier).state =
                          !ref.watch(isNsecVisibleProvider);
                    },
                    icon: ref.watch(isNsecVisibleProvider)
                        ? const Icon(FontAwesomeIcons.eye)
                        : const Icon(FontAwesomeIcons.eyeSlash),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
