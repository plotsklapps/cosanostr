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

class UsePrivateKeyModal extends ConsumerStatefulWidget {
  const UsePrivateKeyModal({
    super.key,
  });

  @override
  ConsumerState<UsePrivateKeyModal> createState() {
    return UsePrivateKeyModalState();
  }
}

class UsePrivateKeyModalState extends ConsumerState<UsePrivateKeyModal> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ref.read(confettiControllerProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    confettiController = ref.read(confettiControllerProvider);
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
            maxBlastForce: 50,
          ),
          const Text(
            'Private Key',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 16.0),
          const NSECTextField(),
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
          keyboardType: TextInputType.text,
          autocorrect: false,
          obscureText: ref.watch(nsecObscuredProvider),
          keyboardAppearance: ref.watch(isDarkThemeProvider)
              ? Brightness.dark
              : Brightness.light,
          onChanged: (String value) {
            ref.read(keyControllerProvider).text = value;
          },
        ),
        const SizedBox(height: 16.0),
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

                      FeedScreenLogic().getKeysFromStorage(ref).then((_) {
                        ref.read(confettiControllerProvider).play();
                        Future<void>.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          snackJoiningSuccesful(context);
                        });
                      });
                    }
                  });
                } else {
                  Navigator.pop(context);
                  snackJoiningFailed(context);
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackJoiningFailed(
    BuildContext context,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Oops, something is wrong!',
            ),
            Icon(FontAwesomeIcons.circleExclamation),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      snackJoiningSuccesful(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'You are now a proud member of CosaNostr!',
            ),
            Icon(FontAwesomeIcons.handshake),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
