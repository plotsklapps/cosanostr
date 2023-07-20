import 'package:cosanostr/all_imports.dart';

final StateProvider<bool> nsecSubmittedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<bool> nsecObscuredProvider = StateProvider<bool>(
  (StateProviderRef<bool> ref) {
    return true;
  },
);

class UsePrivateKeyModal extends ConsumerWidget {
  const UsePrivateKeyModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Private Key',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          NSECTextField(),
        ],
      ),
    );
  }
}

class NSECTextField extends ConsumerStatefulWidget {
  const NSECTextField({
    super.key,
  });

  @override
  ConsumerState<NSECTextField> createState() {
    return NSECTextFieldState();
  }
}

class NSECTextFieldState extends ConsumerState<NSECTextField> {
  @override
  void dispose() {
    ref.read(keyControllerProvider).dispose();
    super.dispose();
  }

  String? get errorText {
    final String privateKey = ref.watch(keyControllerProvider).text.trim();

    try {
      final bool isValidHexKey =
          ref.read(keyApiProvider).isValidPrivateKey(privateKey);
      final bool isValidNsec = privateKey.trim().startsWith('nsec') &&
          ref.read(keyApiProvider).isValidPrivateKey(
                ref.read(nip19Provider).decode(privateKey)['data'] as String,
              );

      if (!(isValidHexKey || isValidNsec)) {
        return 'Your private key is not valid.';
      }
    } on ChecksumVerificationException catch (error) {
      Logger().e('ChecksumVerificationException: error.message');
      return error.message;
    } catch (error) {
      Logger().e(error);
      return 'Error: $error';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Enter NSEC or HEX',
            errorText: ref.watch(nsecSubmittedProvider) ? errorText : null,
            suffixIcon: IconButton(
              onPressed: ref.read(keyControllerProvider).clear,
              icon: const Icon(FontAwesomeIcons.xmark),
            ),
          ),
          controller: ref.watch(keyControllerProvider),
          keyboardType: TextInputType.name,
          autocorrect: false,
          obscureText: ref.watch(nsecObscuredProvider),
          onChanged: (String value) {
            ref.read(keyControllerProvider).text = value;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                ref.read(nsecObscuredProvider.notifier).state =
                    !ref.watch(nsecObscuredProvider);
              },
              icon: ref.watch(nsecObscuredProvider)
                  ? const Icon(FontAwesomeIcons.eyeSlash)
                  : const Icon(FontAwesomeIcons.eye),
            ),
            ElevatedButton(
              onPressed: () async {
                ref.read(nsecSubmittedProvider.notifier).state = true;
                String privateKey =
                    ref.watch(keyControllerProvider).text.trim();
                String publicKey;
                if (errorText == null) {
                  if (privateKey.startsWith('nsec')) {
                    final Map<String, dynamic> decoded =
                        ref.watch(nip19Provider).decode(privateKey);
                    privateKey = decoded['data'] as String;
                    publicKey =
                        ref.watch(keyApiProvider).getPublicKey(privateKey);
                  } else {
                    publicKey =
                        ref.watch(keyApiProvider).getPublicKey(privateKey);
                  }

                  await FeedScreenLogic()
                      .addKeysToStorage(
                    ref,
                    privateKey,
                    publicKey,
                  )
                      .then((_) {
                    if (ref.watch(keysExistProvider)) {
                      ref.read(keyControllerProvider).clear();
                      FeedScreenLogic().getKeysFromStorage(ref);
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
                  return;
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }
}
