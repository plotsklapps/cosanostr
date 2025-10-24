import 'dart:ui';

import 'package:cosanostr/modals/aboutcosanostr_modal.dart';
import 'package:cosanostr/modals/changelog_modal.dart';
import 'package:cosanostr/modals/connectedrelays_modal.dart';
import 'package:cosanostr/modals/newuser_modal.dart';
import 'package:cosanostr/modals/settings_dialog.dart';
import 'package:cosanostr/modals/userexists_modal.dart';
import 'package:cosanostr/modals/wtfisnostr_dialog.dart';
import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:cosanostr/signals/theme_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() {
    return MoreScreenState();
  }
}

class MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final bool keysExist = sKeysExist.watch(context);

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: sThemeMode.value == ThemeMode.light
                            ? Image.asset(
                                'assets/images/cosanostr_white_icon.png',
                              )
                            : Image.asset(
                                'assets/images/cosanostr_black_icon.png',
                              ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'CosaNostr',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Bump this version every time something insanely cool is
                      // added.
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const ChangelogModal();
                            },
                          );
                        },
                        child: const Text('Version: 0.0.3'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    if (keysExist) {
                      await showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const UserExistsModal();
                        },
                      );
                    } else {
                      await showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const NewUserModal();
                        },
                      );
                    }
                  },
                  title: keysExist
                      ? const Text('SHOW YOUR KEYS')
                      : const Text('GENERATE NEW KEYS'),
                  subtitle: keysExist
                      ? const Text('Your keys are securely stored')
                      : const Text('Join the CosaNostr client'),
                  trailing: keysExist
                      ? const Icon(FontAwesomeIcons.check)
                      : const Icon(FontAwesomeIcons.plus),
                ),
                if (keysExist)
                  ListTile(
                    onTap: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return const ConnectedRelaysModal();
                        },
                      );
                    },
                    title: const Text('SHOW RELAYS'),
                    subtitle: const Text('Select connected relays'),
                    trailing: const Icon(FontAwesomeIcons.circleNodes),
                  )
                else
                  const SizedBox(),
                ListTile(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const WtfIsNostrModal();
                      },
                    );
                  },
                  title: const Text('WTF IS NOSTR?'),
                  subtitle: const Text('About the Nostr protocol'),
                  trailing: const Icon(FontAwesomeIcons.solidCircleQuestion),
                ),
                ListTile(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const AboutCosaNostrModal();
                      },
                    );
                  },
                  title: const Text('ABOUT COSANOSTR'),
                  subtitle: const Text('Developer info'),
                  trailing: const Icon(FontAwesomeIcons.circleInfo),
                ),
                ListTile(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsModal();
                      },
                    );
                  },
                  title: const Text('SETTINGS'),
                  subtitle: const Text('Change the app look and feel'),
                  trailing: const Icon(FontAwesomeIcons.gear),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
