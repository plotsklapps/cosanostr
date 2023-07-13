import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class CreditsDialog extends StatelessWidget {
  const CreditsDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                StringUtils.kCredits,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                StringUtils.kPackages,
                textAlign: TextAlign.center,
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchNostrTools();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.n),
                    SizedBox(width: 16),
                    Text(StringUtils.kNostrTools),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchFlutterRiverpod();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.database),
                    SizedBox(width: 16),
                    Text(StringUtils.kRiverpod),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchFlexColorScheme();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.paintRoller),
                    SizedBox(width: 16),
                    Text(StringUtils.kFlexColorScheme),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchFlutterAnimate();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.arrowsUpDownLeftRight),
                    SizedBox(width: 16),
                    Text(StringUtils.kFlutterAnimate),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchJustAudio();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.music),
                    SizedBox(width: 16),
                    Text(StringUtils.kJustAudio),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
