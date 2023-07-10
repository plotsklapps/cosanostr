import 'package:cosanostr/all_imports.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Pretty basic, just show a Scaffold with a PhoneContainer in the
        // center containing the entire application as a form of
        // responsiveness for bigger screens.
        if (constraints.maxWidth >= 720) {
          return const Scaffold(
            body: PhoneContainer(
              child: ScaffoldScreen(),
            ),
          );
        } else {
          // Focus is on mobile version for now.
          return const ScaffoldScreen();
        }
      },
    );
  }
}
