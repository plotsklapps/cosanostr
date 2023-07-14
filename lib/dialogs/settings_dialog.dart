import 'package:cosanostr/all_imports.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              // Riverpod's way of toggling a bool (I think).
              ref.read(isDarkThemeProvider.notifier).state =
                  !ref.watch(isDarkThemeProvider);
            },
            title: const Text('MODE'),
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
            trailing: ref.watch(isFontQuestrialProvider)
                ? const Icon(FontAwesomeIcons.quora)
                : const Icon(FontAwesomeIcons.bold),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }
}
