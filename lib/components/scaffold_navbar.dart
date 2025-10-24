import 'package:cosanostr/signals/pageindex_providers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

class ScaffoldNavBar extends StatelessWidget {
  const ScaffoldNavBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final int currentPage = sCurrentPageIndex.watch(context);

    return BottomNavigationBar(
      currentIndex: currentPage,
      showUnselectedLabels: false,
      onTap: (int index) async {
        sCurrentPageIndex.value = index;
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
