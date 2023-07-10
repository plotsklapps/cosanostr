import 'package:cosanostr/all_imports.dart';

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
              Text('Version: 0.0.1'),
            ],
          )),
          ListTile(
            onTap: () {
              ref.read(isDarkThemeProvider.notifier).state =
                  !ref.watch(isDarkThemeProvider);
            },
            title: const Text('THEMEMODE'),
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
