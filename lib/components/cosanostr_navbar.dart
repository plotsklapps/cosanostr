import 'package:cosanostr/all_imports.dart';

class CosaNostrNavBar extends ConsumerWidget {
  final PageController pageController;
  const CosaNostrNavBar(
    this.pageController, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      onDestinationSelected: (int index) async {
        // This is where we needed the PageController for. First, we
        // set the new page index to the Riverpod Provider.
        // Second, we use that new index to navigate to the
        // corresponding widget in the PageView with a nice animation.
        ref.read(currentPageIndexProvider.notifier).state = index;
        await pageController.animateToPage(
          ref.watch(currentPageIndexProvider),
          duration: const Duration(
            milliseconds: 1000,
          ),
          curve: Curves.bounceOut,
        );
      },
      // The currentIndex is read from the pageIndexProvider.
      selectedIndex: ref.watch(currentPageIndexProvider),
      destinations: <Widget>[
        // Icons animate on tap and receive a checkmark.
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.house),
          selectedIcon: Icon(FontAwesomeIcons.houseCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.solidHeart),
          selectedIcon: Icon(FontAwesomeIcons.heartCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.solidEnvelope),
          selectedIcon: Icon(FontAwesomeIcons.envelopeCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Messages',
        ),
      ],
    );
  }
}