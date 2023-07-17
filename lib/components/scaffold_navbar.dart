import 'package:cosanostr/all_imports.dart';

class ScaffoldNavigationBar extends ConsumerWidget {
  const ScaffoldNavigationBar(this.pageController, {super.key});

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.house),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.searchengin),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.person),
          label: 'Profile',
        ),
      ],
      selectedIndex: ref.watch(currentPageIndexProvider),
      onDestinationSelected: (int index) async {
        ref.read(currentPageIndexProvider.notifier).state = index;
        // When the user taps on a BottomNavigationBarItem, the
        // PageController is used to animate to the corresponding
        // page.
        await pageController.animateToPage(
          ref.watch(currentPageIndexProvider),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.bounceOut,
        );
        // The currentPageIndexProvider is updated to reflect the
        // current page.
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    );
  }
}
