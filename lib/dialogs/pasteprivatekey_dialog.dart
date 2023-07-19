import 'package:cosanostr/all_imports.dart';

// When user chooses to use his/her private key, show this dialog.
// Takes in context and ref. Snackbars don't seem to be working properly
// here on all devices, have to check.
Future<void> showPastePrivateKeyDialog(
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
                      ref.watch(nip19Provider).decode(value)['data'] as String,
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
            String privateKeyHex = ref.watch(keyControllerProvider).text.trim();
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
                Navigator.pop(context);
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
          } else {
            ref.watch(formKeyProvider).currentState?.dispose();
          }
        },
        onCancelPressed: () {
          Navigator.pop(context);
        },
      );
    },
  );
}

class PastePrivateKeyDialog extends StatelessWidget {
  const PastePrivateKeyDialog({
    super.key,
    required this.keyController,
    required this.formKey,
    required this.keyValidator,
    required this.onCancelPressed,
    required this.onOKPressed,
  });

  final TextEditingController keyController;
  final Key formKey;
  final String? Function(String?)? keyValidator;
  final void Function()? onCancelPressed;
  final void Function()? onOKPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.userLock),
      title: const Text('Enter your private key'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter NSEC or HEX',
            ),
            controller: keyController,
            key: formKey,
            validator: keyValidator,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: onOKPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
