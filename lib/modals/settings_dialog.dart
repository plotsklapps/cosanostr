import 'dart:ui';

import 'package:cosanostr/signals/theme_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                FontAwesomeIcons.gear,
                size: 36.0,
              ),
              const Divider(),
              const Text(
                'CosaNostr Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  if (sThemeMode.value == ThemeMode.light) {
                    sThemeMode.value = ThemeMode.dark;
                  } else {
                    sThemeMode.value = ThemeMode.light;
                  }
                },
                title: const Text('MODE'),
                subtitle: const Text('Light or Dark'),
                // Check the current theme mode and display the appropriate
                // icon. Icons are up for debate, but I found these funny.
                trailing: sThemeMode.value == ThemeMode.light
                    ? const Icon(FontAwesomeIcons.ghost)
                    : const Icon(FontAwesomeIcons.faceFlushed),
              ),
              ListTile(
                onTap: () {
                  // Doesn't work for now.
                },
                title: const Text('COLOR'),
                subtitle: const Text('Indigo Nights or Green Money'),
                trailing: const Icon(FontAwesomeIcons.moneyBill),
              ),
              ListTile(
                onTap: () {
                  // Doesn't work for now.
                },
                title: const Text('FONT'),
                subtitle: const Text('Questrial or Barlow'),
                trailing: const Icon(FontAwesomeIcons.bold),
              ),
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
