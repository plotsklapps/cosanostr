import 'package:cosanostr/screens/desktop/desktop_screen.dart';
import 'package:cosanostr/screens/scaffold_screen.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Pretty basic, just show a Scaffold with a PhoneContainer in the
        // center containing the entire application as a form of
        // responsiveness for bigger screens.
        if (constraints.maxWidth >= 720) {
          return const Scaffold(
            body: DesktopScreen(),
          );
        } else {
          // Focus is on mobile version for now.
          return const ScaffoldScreen();
        }
      },
    );
  }
}
