import 'package:cosanostr/all_imports.dart';

class UsePrivateKeyModal extends ConsumerWidget {
  const UsePrivateKeyModal({
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
            'Private Key',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter NSEC or HEX',
            ),
            controller: ref.watch(keyControllerProvider),
            key: ref.watch(formKeyProvider),
            validator: (String? value) {
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
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
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

                    await FeedScreenLogic()
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
                child: const Text('OK'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
