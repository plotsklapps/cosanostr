import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. More is not always better though, so keep this minimal.
class ScaffoldNavBar extends ConsumerWidget {
  final PageController pageController;
  const ScaffoldNavBar(
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
          icon: const Icon(FontAwesomeIcons.house),
          selectedIcon: const Icon(FontAwesomeIcons.houseCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: const Icon(FontAwesomeIcons.solidHeart),
          selectedIcon: const Icon(FontAwesomeIcons.heartCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: const Icon(FontAwesomeIcons.solidEnvelope),
          selectedIcon: const Icon(FontAwesomeIcons.envelopeCircleCheck)
              .animate()
              .flip(duration: const Duration(milliseconds: 1000)),
          label: 'Messages',
        ),
      ],
    );
  }
}
