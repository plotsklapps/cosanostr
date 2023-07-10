import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. Thinking of adding a settingsscreen and profilescreen for
// example. Also, the generateKeys() function should be moved here in a
// later stage.
class ScaffoldDrawer extends StatelessWidget {
  const ScaffoldDrawer({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CosaNostr'),
              // Bump this version every time something insanely cool is added.
              Text('Version: 0.0.1'),
            ],
          )),
          ListTile(
            onTap: () {
              // Riverpod's way of toggling a bool (I think).
              ref.read(isDarkThemeProvider.notifier).state =
                  !ref.watch(isDarkThemeProvider);
            },
            title: const Text('THEMEMODE'),
            // Check the current theme mode and display the appropriate icon.
            // Icons are up for debate, but I found these funny.
            trailing: ref.watch(isDarkThemeProvider)
                ? const Icon(FontAwesomeIcons.ghost)
                : const Icon(FontAwesomeIcons.faceFlushed),
          ),
          const ListTile(),
          const ListTile(),
        ],
      ),
    );
  }
}
