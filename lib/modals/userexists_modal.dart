import 'dart:ui';

import 'package:cosanostr/modals/deletekeys_modal.dart';
import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:signals/signals_flutter.dart';

final Signal<bool> sHex = Signal<bool>(
  true,
  debugLabel: 'sHex',
);

final Signal<bool> sNsecVisible = Signal<bool>(
  false,
  debugLabel: 'sNsecVisible',
);

class UserExistsModal extends StatelessWidget {
  const UserExistsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Nip19 nip19 = Nip19();
    final String publicKey = sPublicKey.watch(context);
    final String privateKey = sPrivateKey.watch(context);
    final bool nsecVisible = sNsecVisible.watch(context);
    final bool hex = sHex.watch(context);

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
                sHex.value ? nip19.npubEncode(publicKey) : publicKey,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Private Key',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (nsecVisible)
                SelectableText(
                  hex ? nip19.nsecEncode(privateKey) : privateKey,
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
                  if (hex)
                    TextButton(
                      onPressed: () {
                        sHex.value = !sHex.value;
                      },
                      child: const Text('SHOW NPUB'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        sHex.value = !sHex.value;
                      },
                      child: const Text('SHOW HEX'),
                    ),
                  IconButton(
                    onPressed: () {
                      sNsecVisible.value = !sNsecVisible.value;
                    },
                    icon: nsecVisible
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
