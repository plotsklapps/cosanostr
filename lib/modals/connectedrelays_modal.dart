import 'dart:ui';

import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nostr_tools/src/api/relay_pool_api.dart';
import 'package:signals/signals_flutter.dart';

class ConnectedRelaysModal extends StatelessWidget {
  const ConnectedRelaysModal({super.key});

  @override
  Widget build(BuildContext context) {
    final RelayPoolApi relayPool = sRelayPoolApi.watch(context);
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
                FontAwesomeIcons.circleNodes,
                size: 36.0,
              ),
              const Divider(),
              const Text(
                'Connected Relays',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text('${relayPool.connectedRelays}'),
              const SizedBox(height: 16.0),
              TextButton(
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
