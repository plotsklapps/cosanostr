import 'package:cosanostr/all_imports.dart';

class ExplainKeypairModal extends StatelessWidget {
  const ExplainKeypairModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            FontAwesomeIcons.key,
            size: 36.0,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'KEYPAIR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const Text(
            'A keypair exists of a public key (npub) and a private key (nsec).',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            'NPUB: Cryptographic key that is shared openly and is used to find you on the Nostr protocol.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'NSEC: Secret cryptographic key that is NEVER shared openly. It is used to sign messages, decrypt encrypted data and proving ownership of the corresponding NPUB.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'This keypair is used for the entire Nostr protocol. It is YOUR identity, YOUR access to data on ANY client. We highly advise you to write them down and store them carefully.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('BACK'),
          ),
        ],
      ),
    );
  }
}
