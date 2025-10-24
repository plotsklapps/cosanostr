import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExplainNostrModal extends StatelessWidget {
  const ExplainNostrModal({
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
            FontAwesomeIcons.circleNodes,
            size: 36.0,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'NOSTR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const Text(
            '''
The Nostr protocol is a decentralized network protocol for a distributed social networking system. It enables a global, decentralized and censorship-resistant social media.''',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            '''
Nostr allows users to share updates, messages and other content in a distributed and tamper-proof manner and consists of two main components: clients and relays.''',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Text(
            '''
Users are identified by public keys and clients fetch data from relays and publish their own content. Nostr provides an open standard upon which developers can build applications and services.''',
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
