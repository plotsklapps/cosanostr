import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class GenerateNewKeysInfoModal extends StatelessWidget {
  const GenerateNewKeysInfoModal({super.key});

  @override
  Widget build(BuildContext context) {
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
                FontAwesomeIcons.circleInfo,
                size: 36.0,
              ),
              const Divider(),
              const Text('Generating New Keys'),
              const Divider(),
              const Text(
                """
Listen up, wise guy! In CosaNostr, we don't mess around with these keys. We're talking about creating a whole new Nostr identity - a flashy public key to show off to your pals and a secret private key that you stash away like a boss.""",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              const Text(
                """
These keys keep our communications locked down tight, capisce? So when you join the family, make sure you generate those fresh keys en keep 'em safe for prying eyes. Trust me, it's the key to being a made member in the CosaNostr crew.""",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
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
