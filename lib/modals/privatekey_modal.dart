import 'package:cosanostr/all_imports.dart';

// [bool] to check if user pressed submit button, this will trigger the
// error message if the private key is not valid.
final StateProvider<bool> nsecSubmittedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

// [bool] to check if user wants to see his private key input, this is
// used on the eye/eye-slash icon.
final StateProvider<bool> nsecObscuredProvider = StateProvider<bool>(
  (StateProviderRef<bool> ref) {
    return true;
  },
);

class PrivateKeyModal extends ConsumerStatefulWidget {
  const PrivateKeyModal({
    super.key,
  });

  @override
  ConsumerState<PrivateKeyModal> createState() {
    return PrivateKeyModalState();
  }
}

class PrivateKeyModalState extends ConsumerState<PrivateKeyModal> {
  // [ConfettiController] to play the confetti animation inside the
  // bottom sheet when the user has entered a valid private key and
  // successfully joined CosaNostr.
  final ConfettiController confettiController = ConfettiController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // [ConfettiWidget] to play the confetti animation on top of the
          // bottom sheet.
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
          // [NSECTextField] is a custom widget that contains the
          // TextField and the submit button. It also takes a parameter
          // [confettiController] to play the confetti animation when the
          // user has successfully joined CosaNostr.
          NSECTextField(
            confettiController: confettiController,
          ),
        ],
      ),
    );
  }
}

class NSECTextField extends ConsumerStatefulWidget {
  const NSECTextField({
    super.key,
    required this.confettiController,
  });

  // Take the [ConfettiController] as a parameter to play the confetti
  final ConfettiController confettiController;

  @override
  ConsumerState<NSECTextField> createState() {
    return NSECTextFieldState();
  }
}

class NSECTextFieldState extends ConsumerState<NSECTextField> {
  // errorText is a getter that returns a [String] if the private key
  // is not valid. If the private key is valid, it will return null.
  String? get errorText {
    // [String] to store the private key from the TextField. Trim the
    // private key to remove any whitespaces.
    final String privateKey = ref.watch(keyControllerProvider).text.trim();

    try {
      // Check if the private key is valid as Hex. We use the isValidPrivateKey
      // method from [keyApiProvider] to check if the private key is valid.
      final bool isValidHexKey =
          ref.read(keyApiProvider).isValidPrivateKey(privateKey);

      // Check if the private key is valid as NSEC. We use the decode method
      // from [nip19Provider] to decode the NSEC private key.
      final bool isValidNsec = privateKey.trim().startsWith('nsec') &&
          ref.read(keyApiProvider).isValidPrivateKey(
                ref.read(nip19Provider).decode(privateKey)['data'] as String,
              );

      // If the input is not valid as Hex or NSEC, or other errors occur,
      // return an error message.
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

            // Do not show an errormessage until the user has pressed the
            // submit button.
            errorText: ref.watch(nsecSubmittedProvider) ? errorText : null,

            // Show a clear button to easily clear the TextField.
            suffixIcon: IconButton(
              onPressed: ref.read(keyControllerProvider).clear,
              icon: const Icon(FontAwesomeIcons.xmark),
            ),
          ),

          // [TextEditingController] to store the private key from the
          // TextField.
          controller: ref.watch(keyControllerProvider),
          keyboardType: TextInputType.text,
          autocorrect: false,

          // [obscureText] is a [bool] that is used to obscure the
          // private key input.
          obscureText: ref.watch(nsecObscuredProvider),

          // [keyboardAppearance] is used to set the keyboard theme (light
          // or dark) based on the [isDarkThemeProvider].
          keyboardAppearance: ref.watch(isDarkThemeProvider)
              ? Brightness.dark
              : Brightness.light,

          // [onChanged] is called when the user types in the TextField.
          // We use this to update the [keyControllerProvider] to store
          // the user's input.
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
                // Toggle the [nsecObscuredProvider] to show or hide the
                // private key input.
                ref.read(nsecObscuredProvider.notifier).state =
                    !ref.watch(nsecObscuredProvider);
              },
              icon: ref.watch(nsecObscuredProvider)
                  ? const Icon(FontAwesomeIcons.eyeSlash)
                  : const Icon(FontAwesomeIcons.eye),
            ),
            ElevatedButton(
              onPressed: () async {
                // Set the [nsecSubmittedProvider] to true to show the
                // error message if the private key is not valid.
                ref.read(nsecSubmittedProvider.notifier).state = true;

                // [String] to store the private key from the TextField.
                String privateKey =
                    ref.watch(keyControllerProvider).text.trim();

                // [String] to store the public key from the private key.
                String publicKey;

                // If there are no errors with the input, check if the user
                // has entered a NSEC or HEX private key. If the user has
                // entered a NSEC private key, decode it first so the public
                // key can be generated.
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

                  // Add the private key and public key to the storage.
                  await FeedScreenLogic()
                      .addKeysToStorage(
                    ref,
                    privateKey,
                    publicKey,
                  )
                      .then((_) {
                    // If keys are added correctly, clear the
                    // relevant Providers and get the keys from
                    // the storage.
                    if (ref.watch(keysExistProvider)) {
                      ref.read(keyControllerProvider).clear();
                      ref.read(nsecSubmittedProvider.notifier).state = false;

                      FeedScreenLogic().getKeysFromStorage(ref).then((_) {
                        // When the keys are fetched correctly from storage
                        // play the confetti animation and show a snackbar
                        // after a delay of 2 seconds.
                        widget.confettiController.play();
                        Future<void>.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          snackJoiningSuccesful(context);
                        });
                      });
                    }
                  });
                } else {
                  Logger().e('Error: $errorText');
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
