import 'dart:ui';

import 'package:cosanostr/modals/credits_modal.dart';
import 'package:cosanostr/modals/donations_dialog.dart';
import 'package:cosanostr/utils/http_utils.dart';
import 'package:cosanostr/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutCosaNostrModal extends StatefulWidget {
  const AboutCosaNostrModal({super.key});

  @override
  State<AboutCosaNostrModal> createState() {
    return AboutCosaNostrModalState();
  }
}

class AboutCosaNostrModalState extends State<AboutCosaNostrModal> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                FontAwesomeIcons.circleInfo,
                size: 36.0,
              ),
              const Divider(),
              const Text(
                StringUtils.kCosaNostrByPlotsklapps,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const Text(
                StringUtils.kEnjoyedMakingIt,
                textAlign: TextAlign.center,
              ),

              // Button to open plotsklapps website.
              ListTile(
                onTap: () async {
                  await HttpUtils().launchWebsite();
                },
                title: const Text(StringUtils.kWebsite),
                subtitle: const Text('Visit :plotsklapps online'),
                trailing: const Icon(FontAwesomeIcons.houseChimney),
              )
                  .animate()
                  .fade(delay: 0.ms, duration: 1000.ms)
                  .move(delay: 0.ms, duration: 1000.ms),

              // Button to open source code on GitHub.
              ListTile(
                onTap: () async {
                  await HttpUtils().launchSourceCode();
                },
                title: const Text(StringUtils.kSourceCode),
                subtitle: const Text("Check out CosaNostr's repo"),
                trailing: const Icon(FontAwesomeIcons.code),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 1000.ms)
                  .move(delay: 500.ms, duration: 1000.ms),

              // Button to show the bottomsheet for donations.
              ListTile(
                onTap: () async {
                  await showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const DonationsModal();
                    },
                  );
                },
                title: const Text(StringUtils.kDonate),
                subtitle: const Text('Feed the developer'),
                trailing: const Icon(FontAwesomeIcons.heartCircleCheck),
              )
                  .animate()
                  .fade(delay: 1000.ms, duration: 1000.ms)
                  .move(delay: 1000.ms, duration: 1000.ms),

              // Button to show the bottomsheet with app related content, like
              // packages used.
              ListTile(
                onTap: () async {
                  await showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const CreditsModal();
                    },
                  );
                },
                title: const Text(StringUtils.kCredits),
                subtitle: const Text('Special thanks'),
                trailing: const Icon(FontAwesomeIcons.circleInfo),
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
