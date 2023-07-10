import 'package:cosanostr/all_imports.dart';

class ScaffoldScreen extends ConsumerStatefulWidget {
  const ScaffoldScreen({super.key});

  @override
  ConsumerState<ScaffoldScreen> createState() {
    return _ScaffoldScreenState();
  }
}

class _ScaffoldScreenState extends ConsumerState<ScaffoldScreen> {
  // Instantiate a PageController to have access to animations during
  // navigation.
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    // Starting index = always 0.
    pageController =
        PageController(initialPage: ref.read(currentPageIndexProvider));
  }

  @override
  void dispose() {
    // Kill the PageController.
    pageController.dispose();
    super.dispose();
  }

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
      body: PageView(
        controller: pageController,
        children: const [
          FeedScreen(),
          Placeholder(),
          Placeholder(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Row(
            children: [
              Text('NEW'),
              SizedBox(width: 8.0),
              Icon(FontAwesomeIcons.featherPointed),
            ],
          )),
      bottomNavigationBar: CosaNostrNavBar(pageController),
    );
  }
}
