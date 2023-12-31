import 'package:cosanostr/all_imports.dart';

class ScaffoldNavBar extends StatelessWidget {
  const ScaffoldNavBar({
    super.key,
    required this.ref,
    required this.pageController,
  });

  final WidgetRef ref;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: ref.watch(currentPageIndexProvider),
      showUnselectedLabels: false,
      onTap: (int index) async {
        ref.read(currentPageIndexProvider.notifier).state = index;
        if (index == 0) {
          await pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else if (index == 1) {
          await pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else if (index == 2) {
          await pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else {
          return;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.idCardClip),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.earthEurope),
          label: 'Global',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.barsStaggered),
          label: 'More',
        ),
      ],
    );
  }
}
