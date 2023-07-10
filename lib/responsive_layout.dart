import 'package:cosanostr/all_imports.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return const Scaffold(
            body: PhoneContainer(
              child: FeedScreen(),
            ),
          );
        } else {
          return const FeedScreen();
        }
      },
    );
  }
}
