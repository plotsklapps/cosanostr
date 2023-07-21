import 'package:cosanostr/all_imports.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() {
    return OnboardingScreenState();
  }
}

class OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  int currentPageIndex = 0;
  int currentPositionIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          children: <Widget>[
            OnboardingPage(
              title: 'Welcome to Cosanostr',
              description:
                  'Cosanostr is a social media app for sharing your thoughts and ideas with the world.',
              imagePath: 'assets/images/onboarding0.png',
            ),
            OnboardingPage(
              title: 'Share your thoughts',
              description: 'Share your thoughts and ideas with the world.',
              imagePath: 'assets/images/onboarding1.png',
            ),
            OnboardingPage(
              title: 'Share your thoughts',
              description: 'Share your thoughts and ideas with the world.',
              imagePath: 'assets/images/onboarding2.png',
            ),
            OnboardingPage(
              title: 'Share your thoughts',
              description: 'Share your thoughts and ideas with the world.',
              imagePath: 'assets/images/onboarding3.png',
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.currentIndex,
    required this.positionIndex,
  });

  final int currentIndex;
  final int positionIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: positionIndex == currentIndex ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
