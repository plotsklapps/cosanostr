import 'package:cosanostr/all_imports.dart';

final StateProvider<int> currentPageIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: <Widget>[
          const FeedScreen(),
          const Placeholder(),
          const Placeholder(),
          const Placeholder()
        ][ref.watch(currentPageIndexProvider)],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(currentPageIndexProvider.notifier).state = 1;
          },
          child: const Icon(Icons.add),
        ),
        // Only show the navigation bar when the timer is NOT running
        bottomNavigationBar: buildNavigationBar(ref).animate().slideY(
            begin: 1.0,
            end: 0.0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut),
      ),
    );
  }
}

// NavigationBar is shown on all screens, providing easy navigation for
// the user.
NavigationBar buildNavigationBar(WidgetRef ref) {
  return NavigationBar(
    onDestinationSelected: (int index) {
      ref.read(currentPageIndexProvider.notifier).state = index;
    },
    selectedIndex: ref.watch(currentPageIndexProvider),
    destinations: const <Widget>[
      // UI code for the navigation rail. Checking the booleans which icon
      // to show.
      NavigationDestination(
        icon: Icon(FontAwesomeIcons.house),
        selectedIcon: Icon(FontAwesomeIcons.houseCircleCheck),
        label: 'Feed',
      ),
      NavigationDestination(
        icon: Icon(FontAwesomeIcons.person),
        selectedIcon: Icon(FontAwesomeIcons.personCircleCheck),
        label: 'Account',
      ),
      NavigationDestination(
        icon: Icon(FontAwesomeIcons.solidHeart),
        selectedIcon: Icon(FontAwesomeIcons.heartCircleCheck),
        label: 'Stats',
      ),
      NavigationDestination(
        icon: Icon(FontAwesomeIcons.solidEnvelope),
        selectedIcon: Icon(FontAwesomeIcons.envelopeCircleCheck),
        label: 'Messages',
      ),
    ],
  );
}
