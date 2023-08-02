import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() {
    return OnboardingScreenState();
  }
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController pageController;
  int currentOnboardingPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      currentOnboardingPageIndex = index;
                    });
                  },
                  children: const <Widget>[
                    OnboardingPageOne(),
                    OnboardingPageTwo(),
                    OnboardingPageThree(),
                    OnboardingPageFour(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Indicator(
                    positionIndex: 0,
                    currentIndex: currentOnboardingPageIndex,
                  ),
                  const SizedBox(width: 16.0),
                  Indicator(
                    positionIndex: 1,
                    currentIndex: currentOnboardingPageIndex,
                  ),
                  const SizedBox(width: 16.0),
                  Indicator(
                    positionIndex: 2,
                    currentIndex: currentOnboardingPageIndex,
                  ),
                  const SizedBox(width: 16.0),
                  Indicator(
                    positionIndex: 3,
                    currentIndex: currentOnboardingPageIndex,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (currentOnboardingPageIndex == 0) {
                        return;
                      } else {
                        await pageController.animateToPage(
                          currentOnboardingPageIndex - 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceOut,
                        );
                      }
                    },
                    child: const Text('PREVIOUS'),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () async {
                      if (currentOnboardingPageIndex == 1 &&
                          ref.watch(userNameProvider) == null) {
                        await showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    FontAwesomeIcons.bomb,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'ERROR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(),
                                  const Text(
                                    '''
Hey wiseguy, what are we supposed to call you?''',
                                  ),
                                  const SizedBox(height: 16.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('BACK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (currentOnboardingPageIndex == 2) {
                        // Nothing to do here yet, just skipping to the next
                        // page
                        await pageController.animateToPage(
                          currentOnboardingPageIndex + 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceOut,
                        );
                      } else if (currentOnboardingPageIndex == 3) {
                        await showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const NewUserModal();
                          },
                        );
                      } else {
                        await pageController.animateToPage(
                          currentOnboardingPageIndex + 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceOut,
                        );
                      }
                    },
                    child: const Text('NEXT'),
                  )
                      .animate(
                        onPlay: (AnimationController controller) {
                          controller.repeat(reverse: true);
                        },
                      )
                      .fade(
                        duration: const Duration(milliseconds: 1000),
                      )
                      .moveX(
                        duration: const Duration(milliseconds: 2000),
                      )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: positionIndex == currentIndex ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
