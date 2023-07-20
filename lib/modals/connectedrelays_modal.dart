import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class ConnectedRelaysModal extends ConsumerWidget {
  const ConnectedRelaysModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Text('${ref.watch(relayPoolProvider).connectedRelays}'),
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
