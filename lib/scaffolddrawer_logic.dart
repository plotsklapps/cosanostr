import 'package:cosanostr/all_imports.dart';

class ScaffoldDrawerLogic {
  Future<void> keysExistDialog(
    BuildContext context,
    WidgetRef ref,
    String npubEncode,
    String nsecEncode,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return KeysExistDialog(
          npubEncode,
          nsecEncode,
          ref.watch(privateKeyProvider),
          ref.watch(publicKeyProvider),
        );
      },
    );
  }

  Future<void> keysOptionDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return KeysOptionDialog(
          generateNewKeyPressed: () {
            FeedScreenLogic().generateNewKeys(ref).then((bool keysGenerated) {
              if (keysGenerated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text('Congratulations! New keys generated!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text('Oops! Something went wrong!'),
                  ),
                );
              }
            });
            Navigator.pop(context);
          },
          inputPrivateKeyPressed: () {
            Navigator.pop(context);
            ref.read(keyControllerProvider).clear();
            pastePrivateKeyDialog(context, ref);
          },
        );
      },
    );
  }

  Future<void> pastePrivateKeyDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PastePrivateKeyDialog(
          keyController: ref.watch(keyControllerProvider),
          formKey: ref.watch(formKeyProvider),
          keyValidator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your private key.';
            }

            try {
              final bool isValidHexKey =
                  ref.watch(keyApiProvider).isValidPrivateKey(value);
              final bool isValidNsec = value.trim().startsWith('nsec') &&
                  ref.watch(keyApiProvider).isValidPrivateKey(
                        ref.watch(nip19Provider).decode(value)['data']
                            as String,
                      );

              if (!(isValidHexKey || isValidNsec)) {
                return 'Your private key is not valid.';
              }
            } on ChecksumVerificationException catch (e) {
              return e.message;
            } catch (e) {
              return 'Error: $e';
            }

            return null;
          },
          onOKPressed: () {
            if (ref.watch(formKeyProvider).currentState!.validate()) {
              String privateKeyHex =
                  ref.watch(keyControllerProvider).text.trim();
              String publicKeyHex;

              if (privateKeyHex.startsWith('nsec')) {
                final Map<String, dynamic> decoded =
                    ref.watch(nip19Provider).decode(privateKeyHex);
                privateKeyHex = decoded['data'] as String;
                publicKeyHex =
                    ref.watch(keyApiProvider).getPublicKey(privateKeyHex);
              } else {
                publicKeyHex =
                    ref.watch(keyApiProvider).getPublicKey(privateKeyHex);
              }

              FeedScreenLogic()
                  .addKeysToStorage(
                ref,
                privateKeyHex,
                publicKeyHex,
              )
                  .then((bool keysAdded) {
                if (keysAdded) {
                  ref.read(keyControllerProvider).clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    ScaffoldSnackBar(
                      context: context,
                      content: const Text(
                        'Congratulations! Private keys securely stored!',
                      ),
                    ),
                  );
                }
              });

              Navigator.pop(context);
            } else {
              ref.watch(formKeyProvider).currentState?.setState(() {});
            }
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> deleteKeysDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DeleteKeysDialog(
          onNoPressed: () {
            Navigator.pop(context);
          },
          onYesPressed: () {
            FeedScreenLogic().deleteKeysFromStorage(ref).then((_) {
              if (!ref.watch(keysExistProvider)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text('Keys successfully deleted!'),
                  ),
                );
              }
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
