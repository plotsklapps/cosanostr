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
                  const SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    positionIndex: 1,
                    currentIndex: currentOnboardingPageIndex,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    positionIndex: 2,
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
                  TextButton(
                    onPressed: () async {
                      if (currentOnboardingPageIndex == 2) {
                        return;
                      } else {
                        await pageController.animateToPage(
                          currentOnboardingPageIndex + 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceOut,
                        );
                      }
                    },
                    child: const Text('NEXT'),
                  ),
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

class OnboardingPageThree extends StatelessWidget {
  const OnboardingPageThree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'We will give you access to Nostr with a public and private key.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '''
The public key can be shared with anyone and is a way to find you within the Nostr network. The private key is yours and yours alone... do not ever, under any circumstance share it with anyone. This key is used to sign transactions and verify your identity.''',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'We will generate keys and show them to you, we advise you to write them down and keep them safe.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/gangster_in_white.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
