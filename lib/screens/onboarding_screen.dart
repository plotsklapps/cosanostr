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
  int currentPageIndex = 0;
  static const Duration kDuration = Duration(milliseconds: 500);
  static const Curve kCurve = Curves.bounceOut;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> nextFunction() async {
    await pageController.nextPage(
      duration: kDuration,
      curve: kCurve,
    );
  }

  Future<void> previousFunction() async {
    await pageController.previousPage(
      duration: kDuration,
      curve: kCurve,
    );
  }

  Future<void> onChangedFunction(int index) async {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ScrollConfiguration(
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
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: PageView(
                  controller: pageController,
                  onPageChanged: onChangedFunction,
                  children: const <Widget>[
                    OnboardingPageOne(),
                    OnboardingPageTwo(),
                    OnboardingPageThree(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.2,
            left: 30,
            child: Row(
              children: <Widget>[
                Indicator(
                  positionIndex: 0,
                  currentIndex: currentPageIndex,
                ),
                const SizedBox(
                  width: 10,
                ),
                Indicator(
                  positionIndex: 1,
                  currentIndex: currentPageIndex,
                ),
                const SizedBox(
                  width: 10,
                ),
                Indicator(
                  positionIndex: 2,
                  currentIndex: currentPageIndex,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.1,
            left: 30,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: previousFunction,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 36.0),
                InkWell(
                  onTap: nextFunction,
                  child: const Text('Next'),
                ),
              ],
            ),
          )
        ],
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

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({
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
                    "So you've decided to check out CosaNostr!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Before we can let you join the family...",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Let's get you set up!",
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

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Are you familiar with Nostr?",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return const ResponsiveLayout();
                          },
                        ),
                      );
                    },
                    child: const Text("JUMP RIGHT IN"),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Otherwise, let's get you some keys!",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
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
