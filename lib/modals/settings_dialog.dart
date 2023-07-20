import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  // Riverpod's way of toggling a bool (I think).
                  ref.read(isDarkThemeProvider.notifier).state =
                      !ref.watch(isDarkThemeProvider);
                },
                title: const Text('MODE'),
                subtitle: const Text('Light or Dark'),
                // Check the current theme mode and display the appropriate icon.
                // Icons are up for debate, but I found these funny.
                trailing: ref.watch(isDarkThemeProvider)
                    ? const Icon(FontAwesomeIcons.ghost)
                    : const Icon(FontAwesomeIcons.faceFlushed),
              ),
              ListTile(
                onTap: () {
                  ref.read(isThemeIndigoProvider.notifier).state =
                      !ref.watch(isThemeIndigoProvider);
                },
                title: const Text('COLOR'),
                subtitle: const Text('Indigo Nights or Green Money'),
                trailing: ref.watch(isThemeIndigoProvider)
                    ? const Icon(FontAwesomeIcons.droplet)
                    : const Icon(FontAwesomeIcons.moneyBill),
              ),
              ListTile(
                onTap: () {
                  ref.read(isFontQuestrialProvider.notifier).state =
                      !ref.watch(isFontQuestrialProvider);
                },
                title: const Text('FONT'),
                subtitle: const Text('Questrial or Barlow'),
                trailing: ref.watch(isFontQuestrialProvider)
                    ? const Icon(FontAwesomeIcons.quora)
                    : const Icon(FontAwesomeIcons.bold),
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
