import 'package:cosanostr/all_imports.dart';

class ScaffoldScreen extends ConsumerStatefulWidget {
  const ScaffoldScreen({super.key});

  @override
  ConsumerState<ScaffoldScreen> createState() {
    return _ScaffoldScreenState();
  }
}

class _ScaffoldScreenState extends ConsumerState<ScaffoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosaNostrAppBar(
        title: 'CosaNostr',
        isConnected: ref.watch(isConnectedProvider),
      ),
      drawer: Drawer(
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
      ),
      body: const ResponsiveLayout(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            children: [
              Text('NEW'),
              SizedBox(width: 8.0),
              Icon(FontAwesomeIcons.featherPointed),
            ],
          )),
    );
  }
}
