import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class UsePrivateKeyInfoModal extends StatelessWidget {
  const UsePrivateKeyInfoModal({super.key});

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
              const Text('Using Your Private Key'),
              const Divider(),
              const Text(
                """
Hey, pal! You wanna join CosaNostr with your own private key? No problemo. We treat that key like pure gold - encrypted, locked away ONLY on YOUR device. Safer than the boss's hidden stash! Join with your private key and we'll welcome you into the CosaNostr crew with open arms.""",
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
