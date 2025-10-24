import 'dart:ui';

import 'package:cosanostr/utils/http_utils.dart';
import 'package:cosanostr/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreditsModal extends StatelessWidget {
  const CreditsModal({super.key});

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
              const Icon(FontAwesomeIcons.circleInfo),
              const Divider(),
              const Text(
                StringUtils.kCredits,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                StringUtils.kPackages,
                textAlign: TextAlign.center,
              ),
              const Divider(),

              // nostr_tools button
              ListTile(
                onTap: () async {
                  await HttpUtils().launchNostrTools();
                },
                title: const Text(StringUtils.kNostrTools),
                trailing: const Icon(FontAwesomeIcons.n),
              )
                  .animate()
                  .fade(delay: 0.ms, duration: 1000.ms)
                  .move(delay: 0.ms, duration: 1000.ms),

              // flutter_riverpod button
              ListTile(
                onTap: () async {
                  await HttpUtils().launchFlutterRiverpod();
                },
                title: const Text(StringUtils.kRiverpod),
                trailing: const Icon(FontAwesomeIcons.database),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 1000.ms)
                  .move(delay: 500.ms, duration: 1000.ms),

              // flex_color_scheme button
              ListTile(
                onTap: () async {
                  await HttpUtils().launchFlexColorScheme();
                },
                title: const Text(StringUtils.kFlexColorScheme),
                trailing: const Icon(FontAwesomeIcons.paintRoller),
              )
                  .animate()
                  .fade(delay: 1000.ms, duration: 1000.ms)
                  .move(delay: 1000.ms, duration: 1000.ms),

              // flutter_animate button
              ListTile(
                onTap: () async {
                  await HttpUtils().launchFlutterAnimate();
                },
                title: const Text(StringUtils.kFlutterAnimate),
                trailing: const Icon(FontAwesomeIcons.arrowsUpDownLeftRight),
              )
                  .animate()
                  .fade(delay: 1500.ms, duration: 1000.ms)
                  .move(delay: 1500.ms, duration: 1000.ms),
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
